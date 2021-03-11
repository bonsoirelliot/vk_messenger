import 'package:flutter/cupertino.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:vk_messenger/scoped_models/chat_page_model.dart';
import 'package:vk_messenger/service_locator.dart';
import 'package:vk_messenger/services/vk_auth.dart';
import 'package:vk_messenger/services/vk_methods.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ConversationsPageModel extends Model {
  List<Conversation> conversations = new List<Conversation>();
  List<String> user_ids = new List<String>();
  List<User> users = new List<User>();

  Future<void> getConversations() async {
    String access_token =
        await locator<VkAuthModel>().storage.read(key: 'access_token');
    String url = locator<VkMethods>()
        .VkApiMethod('messages.getConversations', access_token);

    var response = await http.get(url);

    try {
      if (response.statusCode == 200) {
        conversations =
            (json.decode(response.body)['response']['items'] as List)
                .map((e) => Conversation.fromJson(e))
                .toList();
        getUsers();
        compareLists();
        notifyListeners();
        return Future.value();
      }
    } catch (error) {
      print(error);
    }
  }

  void getUsers() async {
    for (int i = 0; i < conversations.length; i++) {
      user_ids.add(conversations[i].id);
    }
    String ids = user_ids.join(',');
    String access_token =
        await locator<VkAuthModel>().storage.read(key: 'access_token');
    String url = locator<VkMethods>()
        .VkApiMethod('users.get', access_token, 'user_ids=$ids');

    var response = await http.get(url);

    try {
      if (response.statusCode == 200) {
        users = (json.decode(response.body)['response'] as List)
            .map((e) => User.fromJson(e))
            .toList();
        //print(json.decode(response.body)['response']);
      }
    } catch (error) {
      print(error);
    }
  }

  void compareLists() {
    for (int i = 0; i < users.length; i++) {
      for (int j = 0; j < users.length; j++) {
        if (users[i].id.toString() == conversations[j].id) {
          conversations[j].name = users[i].name.toString();
        }
      }
    }
  }
}

class Conversation {
  String last_message;
  String id;
  String name;

  Conversation(this.last_message, this.id);

  factory Conversation.fromJson(dynamic json) {
    return Conversation(json['last_message']['text'] as String,
        (json['conversation']['peer']['id'] as int).toString());
  }
}

class User {
  String id;
  String name;

  User(this.id, this.name);

  factory User.fromJson(dynamic json) {
    return User(json['id'].toString(),
        (json['first_name'] + ' ' + json['last_name']) as String);
  }
}
