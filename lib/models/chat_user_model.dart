import 'message_model.dart';

class ChatUserModel {
  List<MessageModel>? messages;
  String? lastMessage;
  String? lastMessageDate;
  String? name;
  String? image;
  String? id;

  ChatUserModel.fromJson(Map<String, dynamic>? json, this.messages) {
    id = json!['id'];
    name = json['name'];
    image = json['image'];
    lastMessage = json['lastMessage'];
    lastMessageDate = json['lastMessageDate'];
  }
}
