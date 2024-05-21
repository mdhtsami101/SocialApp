import 'package:ayhaga/models/social_app/social_usre_model.dart';
import 'package:ayhaga/modules/social_app/social_register/cubit/states.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class SocialRegisterCubit extends Cubit<SocialRegisterStates> {
  SocialRegisterCubit() : super(SocialRegisterInitialState());

  static SocialRegisterCubit get(context) => BlocProvider.of(context);

  // SocialLoginModel loginModel;

  void userRegister({
    required String name,
    required String email,
    required String password,
    required String phone,
  })
  {
    emit(SocialRegisterLoadingState());
    FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password
    ).then((value) {
      createUser(
        uId:value.user!.uid,
        phone: phone,
        name: name,
        email: email,
      );
      // emit(SocialRegisterSuccessState());
    }).catchError((error){
      emit(SocialRegisterErrorState(error.toString()));
    });
  }

  void createUser({
    required String name,
    required String email,
    required String phone,
    required String uId,
}){
    SocialUserModel model = SocialUserModel(
      name: name,
      email:email,
      phone: phone,
      uId: uId,
      bio: 'write your bio ...',
      image: 'https://img.freepik.com/free-psd/cartoon-young-boy-illustration_23-2151263874.jpg?t=st=1713337955~exp=1713341555~hmac=38c563d5145565883b5a024afc5a80e3ca52cfccc3e5b4f87843b18d3808f4dd&w=740',
      cover: 'https://img.freepik.com/free-psd/cartoon-young-boy-illustration_23-2151263874.jpg?t=st=1713337955~exp=1713341555~hmac=38c563d5145565883b5a024afc5a80e3ca52cfccc3e5b4f87843b18d3808f4dd&w=740',
      isEmailVerifide: false,
    );
   FirebaseFirestore.instance
       .collection('users')
       .doc(uId)
       .set(model.toMap())
       .then((value){
         emit(SocialCreateUserSuccessState());
   }).catchError((error){
         // print(error.toString());
         emit(SocialCreateUserErrorState(error.toString()));
   });
}

  IconData suffix = Icons.visibility_outlined;
  bool isPassword = true;

  void changePasswordVisibility()
  {
    isPassword = !isPassword;
    suffix = isPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined ;

    emit(SocialRegisterChangePasswordVisibilityState());
  }
}