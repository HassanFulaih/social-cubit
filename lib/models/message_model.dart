class MessageModel {
  final String senderId;
  final String receiverId;
  final String text;
  final String time;

  MessageModel({
    required this.senderId,
    required this.receiverId,
    required this.text,
    required this.time,
  });

  factory MessageModel.fromJson(dynamic map) {
    return MessageModel(
      senderId: map['senderId'],
      receiverId: map['receiverId'],
      text: map['message'],
      time: map['time'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'senderId': senderId,
      'receiverId': receiverId,
      'message': text,
      'time': time,
    };
  }
}
