class MessageModel {
  String? date;
  String? receiverId;
  String? id;
  String? senderId;
  String? type;
  String? text;
  String? sender;
  bool? isRead;
  bool? isLastMessage;
  MessageModel({
    required this.date,
    required this.text,
    required this.sender,
    required this.receiverId,
    required this.senderId,
  });

  MessageModel.fromJson(Map<String, dynamic>? json) {
    date = json!['date'];
    receiverId = json['receiverId'];

    id = json['id'];
    senderId = json['senderId'];
    type = json['type'];
    text = json['text'];
    sender = json['sender'];
  }

  Map<String, dynamic> toMap(id) => {
    'id': id,
    'date': date,
    'receiverId': receiverId,
    'senderId': senderId,
    'type': type,
    'text': text,
    'sender': sender,
  };
}
