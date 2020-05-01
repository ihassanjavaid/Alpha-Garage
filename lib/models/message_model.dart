class Message {
  final String messageSender;
  final String timestamp;
  final String messageText;
  bool _isRead = false;

  Message({
    this.messageSender,
    this.messageText,
    this.timestamp,
  });

  factory Message.fromMap(Map<String, dynamic> message) {
    return Message(
      messageSender: message['messageSender'],
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
