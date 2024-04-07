import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:chatwave/chat/manager/chat_cubit.dart';
import 'package:chatwave/constants.dart';
import 'package:chatwave/models/chat_user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:intl/intl.dart' as intl;
import 'package:intl/intl.dart';

import '../../models/message_model.dart';
import '../chat_bubble.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, required this.userModel2});

  final ChatUserModel userModel2;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChatCubit()
        ..getMessages(widget.userModel2.id)
        ..initRecorder(),
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
                  title: Text(widget.userModel2.name!),
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
                          return message.type == 'text'
                              ? ChatBubble(
                                  image: widget.userModel2.image.toString(),
                                  text: message.text!,
                                  isUser: message.senderId == userModel!.id,
                                )
                              : message.senderId == userModel!.id
                                  ? Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Container(
                                              margin:
                                                  const EdgeInsets.only(bottom: 10.0, right: 10, left: 10),
                                              padding:
                                                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
                                              decoration: BoxDecoration(
                                                  color: Colors.blue[200],
                                                  borderRadius: const BorderRadius.only(
                                                    topLeft: Radius.circular(18.0),
                                                    topRight: Radius.circular(18.0),
                                                    bottomLeft: Radius.circular(18.0),
                                                  )),
                                              child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        IconButton(
                                                            onPressed: () async {
                                                              if (!cubit.isPlaying[index]) {
                                                                cubit.changeIsPlaying(index);
                                                                late StreamSubscription<void> subscription,
                                                                    durationSubscription,
                                                                    positionSubscription;
                                                                durationSubscription = cubit
                                                                    .audioPlayer.onDurationChanged
                                                                    .listen((event) {
                                                                  setState(() {
                                                                    cubit.duration[index] = event;
                                                                  });
                                                                });
                                                                positionSubscription = cubit
                                                                    .audioPlayer.onPositionChanged
                                                                    .listen((event) {
                                                                  setState(() {
                                                                    cubit.position[index] = event;
                                                                  });
                                                                });
                                                                subscription = cubit
                                                                    .audioPlayer.onPlayerComplete
                                                                    .listen((event) {
                                                                  cubit.changeIsPlaying(index);
                                                                  subscription.cancel();
                                                                  durationSubscription.cancel();
                                                                  positionSubscription.cancel();
                                                                });
                                                                await cubit.audioPlayer
                                                                    .play(UrlSource(message.text.toString()))
                                                                    .then((value) {});
                                                              } else {
                                                                cubit.audioPlayer.pause();
                                                                cubit.changeIsPlaying(index);
                                                              }
                                                            },
                                                            icon: cubit.isPlaying[index]
                                                                ? const Icon(Icons.pause)
                                                                : const Icon(Icons.play_arrow)),
                                                        Expanded(
                                                          child: Slider(
                                                            min: 0,
                                                            max: cubit.duration[index].inSeconds.toDouble(),
                                                            value: cubit.position[index].inSeconds.toDouble(),
                                                            onChanged: (value) async {},
                                                          ),
                                                        ),
                                                        cubit.isPlaying[index]
                                                            ? Text(cubit.printDuration(cubit.position[index]))
                                                            : Text(message.duration.toString())
                                                      ],
                                                    ),
                                                    Align(
                                                      alignment: Alignment.bottomRight,
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.end,
                                                        children: [
                                                          Text(
                                                            '${message.result.toString()} - ${intl.DateFormat.jm().format(DateTime.parse(message.date.toString()))}',
                                                            style: Theme.of(context).textTheme.bodySmall,
                                                          ),
                                                          Text(
                                                            '${intl.DateFormat.yMd().format(DateTime.parse(message.date.toString()))} - ${intl.DateFormat.jm().format(DateTime.parse(message.date.toString()))}',
                                                            style: Theme.of(context).textTheme.bodySmall,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ]),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Container(
                                              margin:
                                                  const EdgeInsets.only(left: 10.0, right: 10, bottom: 10),
                                              padding:
                                                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
                                              decoration: const BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.only(
                                                    topLeft: Radius.circular(18.0),
                                                    topRight: Radius.circular(18.0),
                                                    bottomRight: Radius.circular(18.0)),
                                              ),
                                              child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        IconButton(
                                                            onPressed: () async {
                                                              if (!cubit.isPlaying[index]) {
                                                                cubit.changeIsPlaying(index);

                                                                late StreamSubscription<void> subscription,
                                                                    durationSubscription,
                                                                    positionSubscription;
                                                                durationSubscription = cubit
                                                                    .audioPlayer.onDurationChanged
                                                                    .listen((event) {
                                                                  setState(() {
                                                                    cubit.duration[index] = event;
                                                                  });
                                                                });
                                                                positionSubscription = cubit
                                                                    .audioPlayer.onPositionChanged
                                                                    .listen((event) {
                                                                  setState(() {
                                                                    cubit.position[index] = event;
                                                                  });
                                                                });
                                                                subscription = cubit
                                                                    .audioPlayer.onPlayerComplete
                                                                    .listen((event) {
                                                                  cubit.changeIsPlaying(index);
                                                                  subscription.cancel();
                                                                  durationSubscription.cancel();
                                                                  positionSubscription.cancel();
                                                                });
                                                                await cubit.audioPlayer
                                                                    .play(UrlSource(message.text.toString()))
                                                                    .then((value) {});
                                                              } else {
                                                                cubit.audioPlayer.pause();
                                                                cubit.changeIsPlaying(index);
                                                              }
                                                            },
                                                            icon: cubit.isPlaying[index]
                                                                ? const Icon(Icons.pause)
                                                                : const Icon(Icons.play_arrow)),
                                                        Expanded(
                                                          child: Slider(
                                                            min: 0,
                                                            max: cubit.duration[index].inSeconds.toDouble(),
                                                            value: cubit.position[index].inSeconds.toDouble(),
                                                            onChanged: (value) async {},
                                                          ),
                                                        ),
                                                        cubit.isPlaying[index]
                                                            ? Text(cubit.printDuration(cubit.position[index]))
                                                            : Text(message.duration.toString())
                                                      ],
                                                    ),
                                                    Align(
                                                      alignment: Alignment.bottomRight,
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.end,
                                                        children: [
                                                          Text(
                                                            '${message.result.toString()} - ${intl.DateFormat.jm().format(DateTime.parse(message.date.toString()))}',
                                                            style: Theme.of(context).textTheme.bodySmall,
                                                          ),
                                                          Text(
                                                            '${intl.DateFormat.yMd().format(DateTime.parse(message.date.toString()))} - ${intl.DateFormat.jm().format(DateTime.parse(message.date.toString()))}',
                                                            style: Theme.of(context).textTheme.bodySmall,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ]),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.07,
                        child: Stack(
                          children: [
                            TextField(
                              controller: cubit.messageController,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                hintText: "Send Message",
                                hintStyle: Theme.of(context).textTheme.bodyMedium,
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    print(userModel!.id);
                                    print(widget.userModel2.id);
                                    MessageModel message = MessageModel(
                                      result: 'none',
                                      date: DateTime.now().toString(),
                                      text: cubit.messageController.text,
                                      sender: widget.userModel2.name,
                                      receiverId: widget.userModel2.id,
                                      senderId: userModel!.id,
                                      type: 'text',
                                      duration: '',
                                      image: widget.userModel2.image,
                                      lastMessage: cubit.messageController.text,
                                      lastMessageDate: DateFormat('hh:mm').format(DateTime.now()),
                                    );
                                    cubit.sendMessage(
                                      message: message,
                                    );
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
                                prefixIcon: IconButton(
                                    onPressed: () async {
                                      if (cubit.recorder.isRecording) {
                                        await cubit.stop(
                                          senderId: widget.userModel2.id!,
                                          secondUserImage: widget.userModel2.image,
                                          secondUserName: widget.userModel2.name,
                                          receiverId: userModel!.id,
                                        );
                                        setState(() {});
                                      } else {
                                        debugPrint('object');
                                        debugPrint(cubit.recorder.isRecording.toString());
                                        await cubit.record();
                                        setState(() {});
                                      }
                                    },
                                    icon: cubit.recorder.isRecording
                                        ? const Icon(Icons.stop)
                                        : const Icon(Icons.mic)),
                              ),
                            ),
                            if (cubit.recorder.isRecording)
                              StreamBuilder<RecordingDisposition>(
                                  stream: cubit.recorder.onProgress,
                                  builder: (context, snapshot) {
                                    final duration =
                                        snapshot.hasData ? snapshot.data!.duration : Duration.zero;
                                    String twoDigits(int n) => n.toString().padLeft(2, "0");
                                    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
                                    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
                                    return TextFormField(
                                      decoration: InputDecoration(
                                        fillColor: Colors.white,
                                        filled: true,
                                        label: Text(
                                          "$twoDigitMinutes:$twoDigitSeconds",
                                          style: const TextStyle(color: Colors.black),
                                        ),
                                        suffixIcon: IconButton(
                                            onPressed: () async {
                                              await cubit.stop(
                                                receiverId: widget.userModel2.id!,
                                                secondUserImage: widget.userModel2.image,
                                                secondUserName: widget.userModel2.name,
                                                senderId: userModel!.id,
                                              );
                                              setState(() {});
                                            },
                                            icon: const Icon(
                                              Icons.send,
                                              color: Colors.blue,
                                            )),
                                        prefixIcon: IconButton(
                                            onPressed: () {
                                              cubit.deleteRecord();
                                            },
                                            icon: const Icon(
                                              Icons.delete,
                                              color: Colors.red,
                                            )),
                                      ),
                                      readOnly: true,
                                    );
                                  })
                          ],
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
