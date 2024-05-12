import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter/return_code.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../../constants.dart';
import '../../models/chat_user_model.dart';
import '../../models/message_model.dart';
import '../../models/user_model.dart';
import '../../shared/network/remote/end_points.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  static HomeCubit get(context) => BlocProvider.of(context);
  bool isEditing = false;
  bool isEditingPhone = false;
  List<ChatUserModel> users = [];
  List<ChatUserModel> searchUsersList = [];

  List<ChatUserModel> allUsers = [];
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  void toggleEditing() {
    isEditing = !isEditing;
    if (!isEditing) {
      nameController.text = userModel!.name.toString();
    }
    emit(ChangeName());
  }

  void toggleEditingPhone() {
    isEditingPhone = !isEditingPhone;
    if (!isEditing) {
      phoneController.text = userModel!.phone.toString();
    }
    emit(ChangePhone());
  }

  void saveChangesPhone() {
    FirebaseFirestore.instance.collection('users').doc(userModel!.id).update({
      'phone': phoneController.text,
    }).then((value) async {
      await FirebaseFirestore.instance.collection('users').doc(userModel!.id).get().then((value) {
        userModel = UserModel.fromJson(value.data());
        emit(ChangePhone());
      });
    });

    isEditingPhone = false;

    emit(ChangePhone());
  }

  void saveChanges() {
    FirebaseFirestore.instance.collection('users').doc(userModel!.id).update({
      'name': nameController.text,
    }).then((value) async {
      await FirebaseFirestore.instance.collection('users').doc(userModel!.id).get().then((value) {
        userModel = UserModel.fromJson(value.data());
        emit(ChangeName());
      });
    });

    isEditing = false;
    emit(ChangeName());
  }

  List<ChatUserModel> privateChatUser = [];

  void getUsersChats() {
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel!.id)
        .collection('chat')
        .snapshots()
        .listen((value) async {
      print(value.docs.length);
      privateChatUser.clear();
      for (var element in value.docs) {
        List<MessageModel> messages = [];
        print(element.data());
        // await element.reference.collection('messages').get().then((value) {
        //   for (var element in value.docs) {
        //     messages.add(MessageModel.fromJson(element.data()));
        //   }
        // });
        privateChatUser.add(ChatUserModel.fromJson(element.data(), messages));
      }
      print(privateChatUser);
      //intance of chatusermodel
      emit(GetAllUsersSuccessfully());
    });
  }

  List<MessageModel> messages = [];

  void getUsers() {
    final currentUserID = userModel!.id;
    FirebaseFirestore.instance.collection("users").get().then((value) {
      allUsers = [];
      for (var element in value.docs) {
        final userId = element.id;
        if (userId != currentUserID) {
          allUsers.add(ChatUserModel.fromJson(element.data(), messages));
        }
      }
      users = allUsers;
      emit(GetUsers());
    });
  }

  void getMyData() {
    FirebaseFirestore.instance.collection('users').doc(userModel!.id).get().then((value) {
      userModel = UserModel.fromJson(value.data());
      emit(GetMYData());
    });
  }

  void showImagePicker(
    BuildContext context,
  ) {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return Card(
            child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 5.2,
                margin: const EdgeInsets.only(top: 8.0),
                padding: const EdgeInsets.all(12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                        child: InkWell(
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.image,
                            size: 60.0,
                            color: Colors.grey,
                          ),
                          Text(
                            ('Gallery'),
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          )
                        ],
                      ),
                      onTap: () async {
                        await pickImageFromGallery();
                      },
                    )),
                  ],
                )),
          );
        });
  }

  String? path;

  Future<void> pickImageFromGallery() async {
    final picker = ImagePicker();

    await picker.pickImage(source: ImageSource.gallery).then((value) {
      FirebaseStorage.instance
          .ref()
          .child('ProfileImage/${userModel!.id!}')
          .putFile(File(value!.path.toString()))
          .then((value) {
        value.ref.getDownloadURL().then((value) async {
          await FirebaseFirestore.instance.collection('users').doc(userModel!.id).update({'image': value});
          getMyData();
        });
      });
      emit(ChangeImage());
    });
  }

  String fileName = '';
  String stringResult = '';

  Future<void> pickAndUploadAudio() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.audio,
      allowMultiple: false,
    );
    if (result != null) {
      File file = File(result.files.single.path!);
      fileName = result.files.single.name;
      path = file.path;
      print(path);
      // String path = await ChatCubit().saveVoice(file.path, '${file.path.split('/').last}.mp3');
      await FFmpegKit.execute('-i $path $path.wav').then((session) async {
        final returnCode = await session.getReturnCode();

        if (ReturnCode.isSuccess(returnCode)) {
          // SUCCESS
          file = File('$path.wav');
          print('done');
        } else if (ReturnCode.isCancel(returnCode)) {
          print('cancel');
          // CANCEL
        } else {
          print('error');
          print(returnCode.toString());
          // ERROR
        }
      });

      var request = await http.MultipartRequest('POST', Uri.parse(baseUrl));
      request.fields['audio'] = 'audio';
      var audio = await http.MultipartFile.fromBytes(
        'audio',
        (await file.readAsBytes()).buffer.asUint8List(),
        filename: 'audio.wav',
      );
      request.files.add(audio);
      var response = await request.send();
      var responseData = await response.stream.toBytes();

      stringResult = String.fromCharCodes(responseData);
      // var response = await DioHelper.postData(
      //   url: baseUrl,
      //   data: FormData.fromMap({
      //     'audio': audio,
      //   }),
      // );
      // result = response.data['result'];
      stringResult = stringResult.split('result').last.split('"').getRange(2, 3).last;
      print(stringResult);
      emit(ChangeFile());
    }
  }

  void isNotSearching() {
    users = allUsers;
    emit(IsNotSearching());
  }

  void searchUsers(String value) {
    searchUsersList.clear();
    print(value);
    for (ChatUserModel user in allUsers) {
      if (user.name.toString().toLowerCase().startsWith(value.toLowerCase())) {
        searchUsersList.add(user);
      }
    }
    print(searchUsersList);
    users = searchUsersList;
    emit(IsSearching());
  }
}
