import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:vk_messenger/pages/conversations_page.dart';
import 'package:vk_messenger/scoped_models/conversation_page_model.dart';
import 'package:vk_messenger/scoped_models/login_page_model.dart';
import 'package:vk_messenger/service_locator.dart';
import 'package:vk_messenger/services/LongPoll.dart';
import 'package:vk_messenger/services/vk_auth.dart';

class LoginPage extends StatelessWidget {
  static const String id = 'LOGIN';
  @override
  Widget build(BuildContext context) {
    return ScopedModel<LoginPageModel>(
      model: locator<LoginPageModel>(),
      child: ScopedModelDescendant<LoginPageModel>(
        builder: (context, child, model) => Scaffold(
          body: Container(
            padding: EdgeInsets.all(45),
            child: Column(
              children: [
                FlutterLogo(
                  size: 70,
                ),
                Form(
                  key: locator<LoginPageModel>().formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        keyboardType: TextInputType.text,
                        validator: (String inValue) {
                          if (inValue.isEmpty) {
                            return 'Введите логин';
                          }
                          return null;
                        },
                        onSaved: (String inValue) {
                          locator<VkAuthModel>().saveLogin(inValue);
                        },
                        decoration: InputDecoration(
                            hintText: 'Номер телефона или email'),
                      ),
                      TextFormField(
                        obscureText: true,
                        validator: (String inValue) {
                          if (inValue.isEmpty) {
                            return 'Введите пароль';
                          }
                          return null;
                        },
                        onSaved: (String inValue) {
                          locator<VkAuthModel>().savePassword(inValue);
                        },
                        decoration: InputDecoration(hintText: 'Пароль'),
                      ),
                    ],
                  ),
                ),
                RaisedButton(
                  child: Text("Log in"),
                  onPressed: () {
                    if (locator<LoginPageModel>()
                        .formKey
                        .currentState
                        .validate()) {
                      locator<LoginPageModel>().formKey.currentState.save();
                      locator<VkAuthModel>().logIn();
                      locator<LongPollModel>().getLongPoll();
                      Navigator.pushReplacementNamed(
                          context, ConversationsPage.id);
                    }
                  },
                ),
              ],
              mainAxisAlignment: MainAxisAlignment.center,
            ),
          ),
        ),
      ),
    );
  }
}
