import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/models/loginModel.dart';
import 'package:social_app/shared/bloc/registerCubit/states.dart';
import 'package:social_app/shared/components/components.dart';

class RegisterCubit extends Cubit<RegisterStates> {
  RegisterCubit(RegisterStates initialState) : super(RegisterInitState());

  static RegisterCubit get(context) => BlocProvider.of(context);

  IconData visible = Icons.visibility;
  bool isShown = true;

  void changePasswordVisibility() {
    isShown = !isShown;
    visible = isShown ? Icons.visibility : Icons.visibility_off_sharp;

    emit(ChangePasswordVisibilityState());
  }

  LoginModel? loginModel;

  void userRegister({
    required String name,
    required String phone,
    required String email,
    required String password,
  }) {
    emit(RegisterLoadingState());
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(
      email: email,
      password: password,
    )
        .then((value) {

      createUser(name: name, phone: phone, email: email, uId: value.user!.uid);
    }).catchError((onError) {
      pint(onError.toString());
      emit(RegisterErrorState(onError.toString()));
    });
  }

  void createUser({
    required String name,
    required String phone,
    required String email,
    String? uId,
  }) {
    emit(RegisterLoadingState());
    loginModel = LoginModel(
        name: name,
        phone: phone,
        email: email,
        bio: 'Write your bio',
        uId: uId!,
        profileImage:
            'https://wallpapers.com/images/high/spiderman-aesthetic-digital-art-bcbsuqaqzhzj065d.webp',
        profileCover:
            'https://images.pexels.com/photos/1323550/pexels-photo-1323550.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1');
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .set(loginModel!.toMap())
        .then((value) {
      emit(RegisterCreateUserSuccessState());
    }).catchError((onError) {
      pint(onError.toString());
      emit(RegisterCreateUserErrorState(onError));
    });
  }
}
