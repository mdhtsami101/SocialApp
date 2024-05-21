



import 'package:ayhaga/shared/cubit/states.dart';
import 'package:ayhaga/shared/network/local/cache_helper.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';



class AppCubit extends Cubit<AppStates>{
  AppCubit() : super(AppInitialState());
  static AppCubit get(context)=>BlocProvider.of(context);

  bool isDark=false;
  ThemeMode appMod= ThemeMode.dark;

  void changeAppMod({bool? fromShared}){
    if(fromShared!=null){
      fromShared=isDark;
    }else
    isDark = !isDark;
   CacheHelper.putData(key: 'isDark', value: isDark).then((value) {
     emit(AppChangeModState());
   });

  }

}



