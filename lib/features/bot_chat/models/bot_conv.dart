import 'bot_chat_message.dart';

class BotConv {
  List<BotChatMessage> messages;
  BotConv(this.messages);

  static from(BotConv convParams) {
    return BotConv(
        convParams.messages);
    }
}
