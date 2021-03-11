import 'package:scoped_model/scoped_model.dart';
import 'package:vk_messenger/service_locator.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:vk_messenger/services/vk_auth.dart';
import 'package:vk_messenger/services/vk_methods.dart';
import 'dart:math';

class ChatPageModel extends Model {
  List<Message> messages = new List<Message>();
  String id;
  String name;

  Future<void> getDialog() async {
    String access_token =
        await locator<VkAuthModel>().storage.read(key: 'access_token');
    String url = locator<VkMethods>()
        .VkApiMethod('messages.getHistory', access_token, 'user_id=$id');

    var response = await http.get(url);

    try {
      if (response.statusCode == 200) {
        messages = (json.decode(response.body)['response']['items'] as List)
            .map((e) => Message.fromJson(e))
            .toList();
      }
    } catch (error) {
      print(error);
    }
    notifyListeners();
  }

  void sendMessage(String message) async {
    String access_token =
        await locator<VkAuthModel>().storage.read(key: 'access_token');

    String rand = Random().nextInt(32).toString();
    String url = locator<VkMethods>().VkApiMethod('messages.send', access_token,
        'user_id=$id&random_id=$rand&message=$message');

    print(url);

    var response = await http.get(url);
    notifyListeners();
  }
}

class Message {
  String from_id;
  String text;

  Message(this.from_id, this.text);

  factory Message.fromJson(dynamic json) {
    return Message(json['from_id'].toString(), json['text']);
  }
}
