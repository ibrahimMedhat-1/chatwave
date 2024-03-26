import 'package:chatwave/chat/manager/chat_cubit.dart';
import 'package:chatwave/constants.dart';
import 'package:chatwave/models/chat_user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/message_model.dart';
import '../chat_bubble.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key,required this.userModel2,required this.reciverUserId, required this.reciverName});
  final ChatUserModel userModel2;
  final reciverUserId;
  final reciverName;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
  create: (context) => ChatCubit()..getMessages(userModel2.id),
  child: BlocConsumer<ChatCubit, ChatState>(
  listener: (context, state) {
    // TODO: implement listener
  },
  builder: (context, state) {
    final ChatCubit cubit = ChatCubit.get(context);
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage('assets/images/a7829c5e3f4c8ea3810d24a064f6c0a1.jpg')),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: Text(userModel2.name!),
            centerTitle: true,
          ),
          body: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  reverse: true,
                  controller: cubit.scrollController,
                  itemCount: cubit.reversedChatMessage.length,
                  itemBuilder: (context, index) {
                    final message = cubit.reversedChatMessage[index];
                    return ChatBubble(
                      image: userModel2.image.toString(),
                      text: message.text!,
                      isUser: message.senderId == userModel!.id ? true : false,
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.07,
                  child: TextField(
                    controller: cubit.messageController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: "Send Message",
                      hintStyle: Theme.of(context).textTheme.bodyMedium,
                      suffixIcon: IconButton(
                        onPressed: () {
                          MessageModel message = MessageModel(
                            date: DateTime.now().toString(),
                            text: cubit.messageController.text,
                            sender: userModel!.name,
                            receiverId: userModel2.id,
                            senderId: userModel!.id,
                          );
                          cubit.sendMessage(message,userModel2.name!,userModel2.image!,userModel2.id!);
                          cubit.messageController.clear();
                        },
                        icon: const Icon(Icons.send),
                      ),
                      border: const OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: Colors.yellow,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  },
),
);
  }
}


