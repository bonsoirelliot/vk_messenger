import 'package:scoped_model/scoped_model.dart';
import 'package:vk_messenger/scoped_models/chat_page_model.dart';
import 'package:vk_messenger/scoped_models/conversation_page_model.dart';
import 'package:vk_messenger/service_locator.dart';
import 'package:vk_messenger/services/vk_auth.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class VkMethods extends Model {
  //Модель для запросов к api
  String VkApiMethod(String _method, String access_token, [String parameters]) {
    String api_url =
        'https://api.vk.com/method/$_method?$parameters&access_token=$access_token&v=5.130';
    return api_url;
  }
}
