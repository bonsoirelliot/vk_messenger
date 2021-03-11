import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:vk_messenger/scoped_models/chat_page_model.dart';
import 'package:vk_messenger/service_locator.dart';
import 'dart:math';

import 'package:vk_messenger/services/LongPoll.dart';

class ChatPage extends StatelessWidget {
  static const String id = 'CHAT';
  List<String> messages = ['1', '2', '3', '4'];
  var _controller = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return ScopedModel<ChatPageModel>(
      model: locator<ChatPageModel>(),
      child: ScopedModelDescendant<ChatPageModel>(
        builder: (context, child, model) => new Scaffold(
          appBar: AppBar(
            title: Text(model.name),
          ),
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: FutureBuilder(
                      initialData: CircularProgressIndicator(),
                      future: model.getDialog(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState != ConnectionState.none &&
                            snapshot.hasData) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          } else {
                            return StreamBuilder(
                              initialData: false,
                              stream: locator<LongPollModel>().getLongPoll(),
                              // ignore: missing_return
                              builder: (context, snapShot) {
                                switch (snapShot.connectionState) {
                                  case ConnectionState.none:
                                    return Text("none");
                                    break;
                                  case ConnectionState.waiting:
                                    return ListView.builder(
                                      reverse: true,
                                      itemCount: model.messages.length,
                                      itemBuilder: (context, i) {
                                        return Row(
                                          children: [
                                            Flexible(
                                              child: SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    2,
                                                child: RaisedButton(
                                                  child: Text(
                                                    model.messages[i].text,
                                                    softWrap: true,
                                                  ),
                                                  onPressed: () {},
                                                ),
                                              ),
                                            ),
                                          ],
                                          mainAxisAlignment:
                                              model.messages[i].from_id !=
                                                      model.id
                                                  ? MainAxisAlignment.end
                                                  : MainAxisAlignment.start,
                                        );
                                      },
                                    );
                                  case ConnectionState.active:
                                    if (id == snapShot.data[1]) {
                                      model.messages.add(Message(
                                          snapShot.data[1], snapShot.data[5]));
                                    }
                                    return ListView.builder(
                                      reverse: true,
                                      itemCount: model.messages.length,
                                      itemBuilder: (context, i) {
                                        return Row(
                                          children: [
                                            Flexible(
                                              child: SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    2,
                                                child: RaisedButton(
                                                  child: Text(
                                                    model.messages[i].text,
                                                    softWrap: true,
                                                  ),
                                                  onPressed: () {},
                                                ),
                                              ),
                                            ),
                                          ],
                                          mainAxisAlignment:
                                              model.messages[i].from_id !=
                                                      model.id
                                                  ? MainAxisAlignment.end
                                                  : MainAxisAlignment.start,
                                        );
                                      },
                                    );
                                    break;
                                  case ConnectionState.done:
                                    return Text("done");
                                    break;
                                }
                              },
                            );
                          }
                        }
                        return ListView.builder(
                          reverse: true,
                          itemCount: model.messages.length,
                          itemBuilder: (context, i) {
                            return Row(
                              children: [
                                Flexible(
                                  child: SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width / 2,
                                    child: RaisedButton(
                                      child: Text(
                                        model.messages[i].text,
                                        softWrap: true,
                                      ),
                                      onPressed: () {},
                                    ),
                                  ),
                                ),
                              ],
                              mainAxisAlignment:
                                  model.messages[i].from_id != model.id
                                      ? MainAxisAlignment.end
                                      : MainAxisAlignment.start,
                            );
                          },
                        );
                      }),
                ),
                TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    prefixIcon: IconButton(
                      icon: Icon(Icons.add,
                          size: MediaQuery.of(context).size.width / 10),
                      onPressed: () {},
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.send,
                          size: MediaQuery.of(context).size.width / 10),
                      onPressed: () {
                        if (_controller.text.isNotEmpty) {
                          model.sendMessage(_controller.text);
                          _controller.clear();
                        }
                      },
                    ),
                  ),
                )
              ],
              mainAxisAlignment: MainAxisAlignment.end,
            ),
          ),
        ),
      ),
    );
  }
}
