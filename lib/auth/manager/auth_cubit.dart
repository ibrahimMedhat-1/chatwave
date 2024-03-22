import 'package:chatwave/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../home/home_page.dart';
import '../../models/user_model.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  static AuthCubit get(context) => BlocProvider.of(context);
  TextEditingController emailLoginController = TextEditingController();
  TextEditingController emailSignUpController = TextEditingController();
  TextEditingController passwordLoginController = TextEditingController();
  TextEditingController passwordSignUpController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  GlobalKey<FormState> signUpFormKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool isLoadingSignUp = false;

  Future<void> signup(
      context, {
        required UserModel userModel,
        required String password,
      }) async {
    isLoadingSignUp = true;
    emit(IsLoading());
    String uid;
    FirebaseAuth.instance.createUserWithEmailAndPassword(email: userModel.email!, password: password).then((value) {
      uid = value.user!.uid;
      FirebaseFirestore.instance.collection("users").doc(uid).set(userModel.toMap(id: uid)).then((value) {
        emailSignUpController.clear();
        nameController.clear();
        phoneController.clear();
        passwordSignUpController.clear();
        isLoadingSignUp = false;
        emit(IsLoading());
        Navigator.pop(context);
      });
    }).catchError((onError) {
      isLoadingSignUp = false;
      emit(IsLoading());
      Fluttertoast.showToast(msg: onError.message.toString());
    });
  }


  Future<void> login({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    isLoading = true;
    emit(IsLoading());
    String uid;
    FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password).then((value) {
      uid = value.user!.uid;
      FirebaseFirestore.instance.collection("users").doc(uid).get().then((value) async {
        userModel =  UserModel.fromJson(value.data());

            Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => const  HomePage(),
            ));
            isLoading = false;
            emit(IsLoading());
          });

    }).catchError((onError) {
      isLoading = false;
      emit(IsLoading());
      Fluttertoast.showToast(msg: onError.message.toString());
    });
  }


}
