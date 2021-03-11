import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:vk_messenger/pages/chat_page.dart';
import 'package:vk_messenger/scoped_models/chat_page_model.dart';
import 'package:vk_messenger/scoped_models/conversation_page_model.dart';
import 'package:vk_messenger/service_locator.dart';
import 'package:vk_messenger/services/LongPoll.dart';
import 'package:vk_messenger/services/vk_auth.dart';
import 'login_page.dart';

class ConversationsPage extends StatelessWidget {
  static const String id = 'CONVERSATIONS';
  @override
  Widget build(BuildContext context) {
    return ScopedModel<ConversationsPageModel>(
      model: locator<ConversationsPageModel>(),
      child: ScopedModelDescendant<ConversationsPageModel>(
        builder: (context, child, model) => Scaffold(
          appBar: AppBar(
            title: Text('Messages'),
            actions: [
              IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  model.getConversations();
                },
              ),
              IconButton(
                icon: Icon(Icons.menu_open),
                onPressed: () {
                  locator<VkAuthModel>().logOut();
                  Navigator.pushReplacementNamed(context, LoginPage.id);
                },
              ),
              IconButton(
                  icon: Icon(Icons.stop_circle),
                  onPressed: () {
                    model.compareLists();
                  }),
            ],
          ),
          body: SafeArea(
            child: FutureBuilder(
              initialData: CircularProgressIndicator(),
              // ignore: missing_return
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.none &&
                    snapshot.hasData) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
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
                              itemCount: model.conversations.length,
                              itemBuilder: (context, index) {
                                return TextButton(
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        child: Text('12'),
                                        maxRadius:
                                            MediaQuery.of(context).size.width /
                                                10,
                                      ),
                                      Flexible(
                                        child: Column(
                                          children: [
                                            Text(model.conversations[index]
                                                        .name ==
                                                    null
                                                ? 'Public'
                                                : model
                                                    .conversations[index].name),
                                            Text(model.conversations[index]
                                                .last_message)
                                          ],
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                        ),
                                      ),
                                    ],
                                  ),
                                  onPressed: () {},
                                  onLongPress: () {},
                                );
                              },
                            );
                          case ConnectionState.active:
                            for (int i = 0;
                                i < model.conversations.length;
                                i++) {
                              var item = model.conversations[i];
                              if (item.id == snapShot.data[1]) {
                                item.last_message = snapShot.data[2];
                                model.conversations[i] = item;
                                model.conversations.removeAt(i);
                                model.conversations.insert(0, item);
                                break;
                              }
                            }
                            return ListView.builder(
                              itemCount: model.conversations.length,
                              itemBuilder: (context, index) {
                                return TextButton(
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        child: Text('12'),
                                        maxRadius:
                                            MediaQuery.of(context).size.width /
                                                10,
                                      ),
                                      Flexible(
                                        child: Column(
                                          children: [
                                            Text(model.conversations[index]
                                                        .name ==
                                                    null
                                                ? 'Public'
                                                : model
                                                    .conversations[index].name),
                                            Text(model.conversations[index]
                                                .last_message)
                                          ],
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                        ),
                                      ),
                                    ],
                                  ),
                                  onPressed: () {},
                                  onLongPress: () {},
                                );
                              },
                            );
                          case ConnectionState.done:
                            return Text("done");
                            break;
                        }
                      },
                    );
                  }
                }
                return ListView.builder(
                  itemCount: model.conversations.length,
                  itemBuilder: (context, index) {
                    return TextButton(
                      child: Row(
                        children: [
                          CircleAvatar(
                            child: Text('12'),
                            maxRadius: MediaQuery.of(context).size.width / 10,
                          ),
                          Flexible(
                            child: Column(
                              children: [
                                Text(model.conversations[index].name == null
                                    ? 'Public'
                                    : model.conversations[index].name),
                                Text(
                                  model.conversations[index].id !=
                                          model.users[index].id
                                      ? model.conversations[index].last_message
                                      : 'Вы:' +
                                          model.conversations[index]
                                              .last_message,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                              crossAxisAlignment: CrossAxisAlignment.start,
                            ),
                          ),
                        ],
                      ),
                      onPressed: () {
                        locator<ChatPageModel>().id =
                            model.conversations[index].id;
                        locator<ChatPageModel>().name =
                            model.conversations[index].name;
                        Navigator.of(context).pushNamed(ChatPage.id);
                      },
                      onLongPress: () {},
                    );
                  },
                );
              },
              future: model.getConversations(),
            ),
          ),
        ),
      ),
    );
  }
}
