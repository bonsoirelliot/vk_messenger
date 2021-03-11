import 'package:scoped_model/scoped_model.dart';
import 'package:vk_messenger/service_locator.dart';
import 'package:http/http.dart' as http;
import 'package:vk_messenger/services/vk_auth.dart';
import 'dart:convert';

import 'package:vk_messenger/services/vk_methods.dart';

class LongPollModel extends Model {
  String server;
  String key;
  String ts;

  Future<void> getMainDataLongPoll() async {
    String access_token =
        await locator<VkAuthModel>().storage.read(key: 'access_token');
    String url = locator<VkMethods>().VkApiMethod(
        'messages.getLongPollServer', access_token, 'lp_version=3');

    var response = await http.get(url);

    try {
      server = json.decode(response.body)['server'] as String;
      key = json.decode(response.body)['key'] as String;
      ts = json.decode(response.body)['ts'].toString();
    } catch (error) {
      print(error);
    }
  }

  Stream<List<Object>> getLongPoll() async* {
    while (true) {
      if (server == null && key == null && ts == null) {
        await getMainDataLongPoll();
      } else {
        String access_token =
            await locator<VkAuthModel>().storage.read(key: 'access_token');
        String main_url = locator<VkMethods>().VkApiMethod(
            'messages.getLongPollServer', access_token, 'lp_version=3');

        var response_main = await http.get(main_url);

        if (response_main.statusCode == 200) {
          server = json.decode(response_main.body)['response']['server'];
          key = json.decode(response_main.body)['response']['key'];
          ts = json.decode(response_main.body)['response']['ts'].toString();
        }
        var url =
            'https://$server?act=a_check&key=$key&ts=$ts&wait=25&mode=2&version=3';

        var response = await http.get(url);

        LongPollAnswer answer =
            LongPollAnswer.fromJson(jsonDecode(response.body));

        for (var update in answer.updates) {
          switch (update.code) {
            case 4:
              ts = answer.ts;
              yield [update.code, update.user_id, update.text];
          }
        }
      }
    }
  }
}

class LongPollAnswer {
  String ts;
  List<Update> updates;

  LongPollAnswer(this.ts, this.updates);

  factory LongPollAnswer.fromJson(dynamic json) {
    var _ts = json['ts'].toString();
    List _updates =
        (json['updates'] as List).map((e) => Update.fromJson(e)).toList();

    return LongPollAnswer(_ts, _updates);
  }
}

class Update {
  int code;
  int user_id;
  String text;

  Update(this.code, this.user_id, this.text);

  factory Update.fromJson(dynamic json) {
    return Update(json[0] as int, json[3] as int, json[5].toString());
  }
}
