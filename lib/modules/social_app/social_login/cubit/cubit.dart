

import 'package:ayhaga/modules/social_app/social_login/cubit/states.dart';

import 'package:ayhaga/shared/network/end_points.dart';
import 'package:ayhaga/shared/network/remote/dio_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class SocialLoginCubit extends Cubit<SocialLoginStates>{
  SocialLoginCubit():super(SocialLoginInitialState());

  static SocialLoginCubit get(context)=>BlocProvider.of(context);

   // SocialLoginModel? loginModel ;
  
  void userLogin({
    required String email,
    required String password,
}){

    emit(SocialLoginLoadingState());
    FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
    ).then((value) {
      print(value.user!.email);
      print(value.user!.uid);
      emit(SocialLoginSuccessState(value.user!.uid));
    }).catchError((error){
      emit(SocialLoginErrorState(error.toString()));
    });
  }


  IconData suffix = Icons.visibility_off_outlined;
  bool isPassword = true;

  void changePasswordVisibility(){
    isPassword= !isPassword ;
    suffix = isPassword ? Icons.visibility_off_outlined: Icons.visibility_outlined;
    emit(SocialChangePasswordVisibilityState());
  }

}