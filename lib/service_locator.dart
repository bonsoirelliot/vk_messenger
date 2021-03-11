import 'package:get_it/get_it.dart';
import 'package:vk_messenger/scoped_models/chat_page_model.dart';
import 'package:vk_messenger/scoped_models/conversation_page_model.dart';
import 'package:vk_messenger/scoped_models/login_page_model.dart';
import 'package:vk_messenger/services/LongPoll.dart';
import 'package:vk_messenger/services/vk_auth.dart';
import 'package:vk_messenger/services/vk_methods.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerSingleton<VkAuthModel>(VkAuthModel());
  locator.registerSingleton<LoginPageModel>(LoginPageModel());
  locator.registerSingleton<ConversationsPageModel>(ConversationsPageModel());
  locator.registerSingleton<VkMethods>(VkMethods());
  locator.registerSingleton<ChatPageModel>(ChatPageModel());
  locator.registerSingleton<LongPollModel>(LongPollModel());
}
