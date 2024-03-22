import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../constants.dart';
import '../../models/user_model.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());
  static HomeCubit get(context) => BlocProvider.of(context);
  bool isEditing = false;
  bool isEditingPhone = false;

  List allUsers =[];
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
      'phone': phoneController.text ?? userModel?.phone ?? '',
    }).then((value)async{
      await FirebaseFirestore.instance.collection('users').doc(userModel!.id).get().then((value) {
        userModel =  UserModel.fromJson(value.data());
        emit(ChangePhone());

      });
    });

    isEditingPhone = false;

    emit(ChangePhone());
  }
  void saveChanges() {
    FirebaseFirestore.instance.collection('users').doc(userModel!.id).update({
      'name': nameController.text ?? userModel?.name ?? '',
    }).then((value)async{
    await FirebaseFirestore.instance.collection('users').doc(userModel!.id).get().then((value) {
    userModel =  UserModel.fromJson(value.data());
    emit(ChangeName());

    });
    });

    isEditing = false;
    emit(ChangeName());

  }


  void getUsers(){

    FirebaseFirestore.instance.collection("users").get().then((value) {
      for (var element in value.docs) {
        allUsers.add(UserModel.fromJson(element.data()));
        emit(GetUsers());
      }
    });
  }
}
