import 'package:flutter/material.dart';
import 'package:vk_messenger/pages/chat_page.dart';
import 'package:vk_messenger/pages/conversations_page.dart';
import 'package:vk_messenger/pages/login_page.dart';
import 'package:vk_messenger/services/vk_auth.dart';
import 'package:vk_messenger/services/vk_methods.dart';
import 'service_locator.dart';

void main() {
  setupLocator();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      //home: TestPage(),

      initialRoute:
          locator<VkAuthModel>().storage.read(key: 'access_token') != null
              ? ConversationsPage.id
              : LoginPage.id,
      routes: {
        LoginPage.id: (context) => LoginPage(),
        ConversationsPage.id: (context) => ConversationsPage(),
        ChatPage.id: (context) => ChatPage(),
      },
    );
  }
}
