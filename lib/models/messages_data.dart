import 'package:alphagarage/models/message_model.dart';

class MessagesData {
  List<Message> _messages = [];

  set addMessage(Message message) => _messages.add(message);
}
