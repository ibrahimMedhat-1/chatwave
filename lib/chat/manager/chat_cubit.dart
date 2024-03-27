import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:chatwave/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../models/message_model.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit() : super(ChatInitial());

  static ChatCubit get(context) => BlocProvider.of(context);
  final TextEditingController messageController = TextEditingController();
  List<MessageModel> chatMessage = [];
  List<MessageModel> reversedChatMessage = [];
  ScrollController scrollController = ScrollController();

  void sendMessage({
    required MessageModel message,
  }) async {
    print(message.senderId);
    print(message.receiverId);
    await FirebaseFirestore.instance
        .collection('users')
        .doc(message.senderId)
        .collection('chat')
        .doc(message.receiverId)
        .set(message.toMap());
    var firstUserDoc = FirebaseFirestore.instance
        .collection('users')
        .doc(message.senderId)
        .collection('chat')
        .doc(message.receiverId)
        .collection('messages')
        .doc();
    await firstUserDoc.set(message.toMap());
    await FirebaseFirestore.instance
        .collection('users')
        .doc(message.receiverId)
        .collection('chat')
        .doc(message.senderId)
        .set(message.toMap());
    var secondUserDoc = FirebaseFirestore.instance
        .collection('users')
        .doc(message.receiverId)
        .collection('chat')
        .doc(message.senderId)
        .collection('messages')
        .doc();
    await secondUserDoc.set(message.toMap());
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
      isPlaying.clear();
      duration.clear();
      position.clear();
      for (var element in event.docs) {
        chatMessage.add(MessageModel.fromJson(element.data()));
        isPlaying.add(false);
        duration.add(Duration.zero);
        position.add(Duration.zero);
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

  var recorder = FlutterSoundRecorder();

  Future initRecorder() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw 'Microphone permission not granted';
    }
    await recorder.openRecorder();
    recorder.setSubscriptionDuration(const Duration(milliseconds: 500));
  }

  Timer? timer;
  Duration recordDuration = Duration.zero;

  Future record() async {
    await recorder.startRecorder(toFile: 'audio');
    var startTime = DateTime.now();
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      recordDuration = DateTime.now().difference(startTime);
    });
  }

  String printDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  String? url;

  Future stop({
    required receiverId,
    required secondUserName,
    required secondUserImage,
    required senderId,
  }) async {
    final path = await recorder.stopRecorder();
    timer!.cancel();
    debugPrint(printDuration(recordDuration));

    final audioFile = File(path!);
    FirebaseStorage.instance
        .ref()
        .child('records/records/${DateTime.now()}')
        .putFile(audioFile, SettableMetadata(contentType: 'mp3'))
        .then((p0) {
      p0.ref.getDownloadURL().then((value) async {
        url = value.toString();
        sendMessage(
          message: MessageModel(
            date: DateTime.now().toString(),
            text: url.toString(),
            sender: secondUserName,
            receiverId: receiverId,
            image: secondUserImage,
            senderId: senderId,
            lastMessage: 'Record',
            lastMessageDate: DateFormat('hh:mm').format(DateTime.now()),
            type: 'record',
            duration: printDuration(recordDuration),
          ),
        );
        debugPrint('done');
      });
    }).catchError((onError) {
      debugPrint('audio error');
      debugPrint(onError.toString());
    });
    debugPrint('Recorded audio: $audioFile');
  }

  void deleteRecord() async {
    await recorder.stopRecorder();
    timer!.cancel();
    emit(DeleteRecord());
  }

  List<bool> isPlaying = [];
  final audioPlayer = AudioPlayer();
  List<Duration> duration = [];
  List<Duration> position = [];
  changeIsPlaying(index) {
    isPlaying[index] = !isPlaying[index];
    emit(ChangeIsPlaying());
  }
}
