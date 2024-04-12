import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:chatwave/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter/return_code.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../models/message_model.dart';
import '../../shared/network/remote/end_points.dart';

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
  String result = 'none';

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
        print(url);
        String path =
            await saveVoice(url!, '${url.toString().split('/').last.split('=').last.split('-').last}.mp3');
        File file = File(path);
        print(path);

        /// /data/user/0/com.example.chatwave/cache/file_picker/1712898450370/audio.mp3
        await FFmpegKit.execute('-i $path $path.wav').then((session) async {
          final returnCode = await session.getReturnCode();
          // print(session.get.toString());

          if (ReturnCode.isSuccess(returnCode)) {
            // SUCCESS
            print(returnCode.toString());
            file = File('$path.wav');
            print('done');
          } else if (ReturnCode.isCancel(returnCode)) {
            print('cancel');
            // CANCEL
          } else {
            print(await session.getOutput());
            print('errorgfg');
            // ERROR
          }
        });
        var request = http.MultipartRequest('POST', Uri.parse(baseUrl));
        request.fields['audio'] = 'audio';
        var audio = http.MultipartFile.fromBytes('audio', await file.readAsBytes(), filename: 'audio.wav');
        request.files.add(audio);
        var response = await request.send();
        var responseData = await response.stream.toBytes();

        result = String.fromCharCodes(responseData);
        result = result.split('result').last.split('"').getRange(2, 3).last;

        // var response = await DioHelper.postData(
        //   url: baseUrl,
        //   data: FormData.fromMap({
        //     'audio': audio,
        //   }),
        // );
        // result = response.data['result'];
        print(result);
        sendMessage(
          message: MessageModel(
            result: result,
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
        // debugPrint('done');
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

  Future<String> saveVoice(String url, String fileName) async {
    Directory? directory;
    try {
      if (Platform.isAndroid) {
        print('here-----------------------here');
        await _requestPermission(Permission.storage);
        await _requestPermission(Permission.photos);
        await _requestPermission(Permission.storage);
        if (true) {
          directory = await getExternalStorageDirectory();
          String newPath = "";
          List<String> paths = directory!.path.split("/");
          for (int x = 1; x < paths.length; x++) {
            String folder = paths[x];
            if (folder != "Android") {
              newPath += "/$folder";
            } else {
              break;
            }
          }
          newPath = "$newPath/Download";
          print(newPath);
          print(directory.path);
          directory = Directory(newPath);
        } else {
          return '';
        }
      } else {
        if (await _requestPermission(Permission.photos)) {
          directory = await getTemporaryDirectory();
        } else {
          return '';
        }
      }
      File saveFile = File("${directory.path}/$fileName");
      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }
      if (await directory.exists()) {
        await Dio().download(url, saveFile.path, onReceiveProgress: (value1, value2) {
          // setState(() {
          //   progress = value1 / value2;
          // });
        }).then((value) {
          // showToast('Downloaded Successfully');
          print('-----------------------------------------');
          print(saveFile.path);
          print('-----------------------------------------');
        }).catchError((onError) {
          print('ghj');
          print(onError);
        });
        if (Platform.isIOS) {
          // await ImageGallerySaver.saveFile(saveFile.path, isReturnPathOfIOS: true);
        }
        return saveFile.path;
      }
      return '';
    } catch (e) {
      print(e);
      return '';
    }
  }

  void checkFileSystemPermission() async {
    PermissionStatus status = await Permission.storage.status;
    await _requestPermission(Permission.storage);
    await _requestPermission(Permission.photos);
    if (status.isGranted) {
      print('File system permission granted!');
      // Access to the file system is granted. Proceed with file operations.
    } else {
      print('File system permission not granted. Requesting permission...');
      // Request permission from the user.
      status = await Permission.photos.request();
      await Permission.storage.request();
      await Permission.accessMediaLocation.request();
      await Permission.manageExternalStorage.request();
      if (status.isGranted) {
        print('File system permission granted!');
        // Access to the file system is granted. Proceed with file operations.
      } else {
        print('File system permission denied!');
        // Access to the file system is denied. Handle accordingly.
      }
    }
  }

  Future<bool> _requestPermission(Permission permission) async {
    print('1');
    if (await permission.isGranted) {
      print('2');
      return true;
    } else {
      print('3');
      var result = await permission.request();
      if (result == PermissionStatus.granted) {
        print('4');
        return true;
      }
    }
    print('5');
    return false;
  }
}
