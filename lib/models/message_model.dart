class Message {
  final String messageSender;
  final String messageReceiver;
  final int timestamp;
  final String messageText;
  bool _isRead = false;

  Message({
    this.messageSender,
    this.messageReceiver,
    this.messageText,
    this.timestamp,
  });

  factory Message.fromMap(Map<String, dynamic> message) {
    print(message['timestamp'].runtimeType);
    return Message(
      messageSender: message['messageSender'],
      messageReceiver: message['messageReceiver'],
      messageText: message['messageText'],
      timestamp: message['timestamp'],
    );
  }

  bool get isRead => _isRead;

  void toggleMessageRead() {
    _isRead = !_isRead;
  }

  Map<String, dynamic> toMap() {
    return {'messageText': this.messageText, 'timestamp': this.timestamp};
  }
}
