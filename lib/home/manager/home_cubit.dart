import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';

import '../../constants.dart';
import '../../models/chat_user_model.dart';
import '../../models/message_model.dart';
import '../../models/user_model.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  static HomeCubit get(context) => BlocProvider.of(context);
  bool isEditing = false;
  bool isEditingPhone = false;
  List<ChatUserModel> users = [];

  List allUsers = [];
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
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userModel!.id)
          .get()
          .then((value) {
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
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userModel!.id)
          .get()
          .then((value) {
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
      privateChatUser.clear();
      for (var element in value.docs) {
        List<MessageModel> messages = [];
        await element.reference.collection('messages').get().then((value) {
          for (var element in value.docs) {
            messages.add(MessageModel.fromJson(element.data()));
          }
        });
        privateChatUser.add(ChatUserModel.fromJson(element.data(), messages));
      }
      print(privateChatUser.toString());
      //intance of chatusermodel
      emit(GetAllUsersSuccessfully());
    });
  }
  List<MessageModel> messages = [];
  void getUsers() {
    final currentUserID = userModel!.id;
    FirebaseFirestore.instance.collection("users").get().then((value) {
      for (var element in value.docs) {
        final userId = element.id;
        if (userId != currentUserID) {
          allUsers.add(ChatUserModel.fromJson(element.data(), messages));
        }
      }
      emit(GetUsers());
    });
  }

  void getMyData() {
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel!.id)
        .get()
        .then((value) {
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
                            style: TextStyle(
                                fontSize: 16, color: Colors.black),
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
          await FirebaseFirestore.instance
              .collection('users')
              .doc(userModel!.id)
              .update({'image': value});
          getMyData();
        });
      });
      emit(ChangeImage());
    });
  }

  Future<void> pickAndUploadAudio() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.audio,
      allowMultiple: false,
    );
    if (result != null) {
      File file = File(result.files.single.path!);
      String fileName = result.files.single.name;
      Reference ref = FirebaseStorage.instance.ref().child('audio/$fileName');
      UploadTask task = ref.putFile(file);
      await task.whenComplete(() async {
        String downloadURL = await ref.getDownloadURL();
        await FirebaseFirestore.instance.collection('audio').add({
          'name': fileName,
          'url': downloadURL,
        });
      });
    }
  }
}
