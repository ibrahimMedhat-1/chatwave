
import 'package:chatwave/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';


import '../../models/message_model.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit() : super(ChatInitial());
  static ChatCubit get(context) => BlocProvider.of(context);
  final TextEditingController messageController = TextEditingController();
  List<MessageModel> chatMessage = [];
  List<MessageModel> reversedChatMessage = [];
  ScrollController scrollController = ScrollController();


  void sendMessage(MessageModel message,String seconduserName,String seconduserImage,String id) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(message.senderId)
        .collection('chat')
        .doc(message.receiverId)
        .set({
      'id':id,
      'name': seconduserName,
      'image':seconduserImage,
      'lastMessage': message.text,
      'lastMessageDate': DateFormat('hh:mm').format(DateTime.now()),
    });
    var firstUserDoc = FirebaseFirestore.instance
        .collection('users')
        .doc(message.senderId)
        .collection('chat')
        .doc(message.receiverId)
        .collection('messages')
        .doc();
    firstUserDoc.set(message.toMap(firstUserDoc.id));
    FirebaseFirestore.instance
        .collection('users')
        .doc(message.receiverId)
        .collection('chat')
        .doc(message.senderId)
        .set({
      'lastMessage': message.text,
      'name': userModel!.name,
      'image': userModel!.image,
      'lastMessageDate': DateFormat('hh:mm').format(DateTime.now()),
      'id': userModel!.id,
    });
    var secondUserDoc = FirebaseFirestore.instance
        .collection('users')
        .doc(message.receiverId)
        .collection('chat')
        .doc(message.senderId)
        .collection('messages')
        .doc();
    secondUserDoc.set(message.toMap(secondUserDoc.id));
  }

  void getMessages(secondUserId) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel!.id)
        .collection('chat')
        .doc(secondUserId)
        .collection('messages')
        .orderBy('date')
        .snapshots()
        .listen((event) {
      chatMessage.clear();
      for (var element in event.docs) {
        chatMessage.add(MessageModel.fromJson(element.data()));
        emit(GetAllMessagesSuccessfully());
      }
      reversedChatMessage = chatMessage.reversed.toList();
      scrollController.animateTo(
        double.minPositive,
        duration: const Duration(microseconds: 1),
        curve: Curves.bounceIn,
      );
    });
  }



}
