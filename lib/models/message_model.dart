class MessageModel {
  String? date;
  String? receiverId;
  String? id;
  String? senderId;
  String? type;
  String? duration;
  String? text;
  String? sender;
  String? lastMessage;
  String? lastMessageDate;
  String? image;
  bool? isRead;
  bool? isLastMessage;
  MessageModel({
    required this.date,
    required this.text,
    required this.sender,
    required this.receiverId,
    required this.image,
    required this.senderId,
    required this.type,
    required this.duration,
    required this.lastMessage,
    required this.lastMessageDate,
  });

  MessageModel.fromJson(Map<String, dynamic>? json) {
    date = json!['date'];
    receiverId = json['id'];
    image = json['image'];
    lastMessage = json['lastMessage'];
    lastMessageDate = json['lastMessageDate'];
    type = json['type'];
    duration = json['duration'];

    id = json['id'];
    senderId = json['senderId'];
    type = json['type'];
    text = json['text'];
    sender = json['sender'];
  }

  Map<String, dynamic> toMap() => {
        'date': date,
        'image': image,
        'lastMessage': lastMessage,
        'lastMessageDate': lastMessageDate,
        'id': receiverId,
        'senderId': senderId,
        'type': type,
        'text': text,
        'name': sender,
        'duration': duration,
      };
}
