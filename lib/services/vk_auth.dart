import 'package:flutter/cupertino.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:vk_messenger/service_locator.dart';
import 'package:vk_messenger/services/LongPoll.dart';
import 'package:vk_messenger/services/vk_methods.dart';

class VkAuthModel extends Model {
  final storage = new FlutterSecureStorage();

  void saveLogin(String login) async {
    await storage.write(key: 'login', value: login);
  }

  void savePassword(String password) async {
    await storage.write(key: 'password', value: password);
  }

  void saveToken(String _token) async {
    await storage.write(key: 'access_token', value: _token);
  }

  void logOut() async {
    await storage.deleteAll();
  }

  void logIn() async {
    String _log = await storage.read(key: 'login');
    String _pass = await storage.read(key: 'password');
    String VK_AUTH_URL =
        'https://oauth.vk.com/token?grant_type=password&client_id=2274003&client_secret=hHbZxrka2uZ6jB1inYsH&username=$_log&password=$_pass';

    var response = await http.get(VK_AUTH_URL);

    try {
      saveToken(json.decode(response.body)['access_token'] as String);
      if (response.statusCode == 200) {
        print('ok');
      }
    } catch (error) {
      print(error);
    }
  }
}
