

import 'package:ayhaga/firebase_options.dart';

import 'package:ayhaga/layout/social_app/cubit/cubit.dart';
import 'package:ayhaga/layout/social_app/social_layout.dart';

import 'package:ayhaga/modules/native_code.dart';


import 'package:ayhaga/modules/social_app/social_login/social_login_screen.dart';

import 'package:ayhaga/shared/bloc_observer.dart';
import 'package:ayhaga/shared/components/components.dart';
import 'package:ayhaga/shared/components/constants.dart';
import 'package:ayhaga/shared/cubit/cubit.dart';
import 'package:ayhaga/shared/cubit/states.dart';
import 'package:ayhaga/shared/network/local/cache_helper.dart';
import 'package:ayhaga/shared/network/remote/dio_helper.dart';
import 'package:ayhaga/shared/styles/themes.dart';
import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';


Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('on background message');
  print(message.data.toString());
  showToast(text: 'on background message', state: ToastStates.SUCCESS);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  var token = await FirebaseMessaging.instance.getToken();
  print(token);

  FirebaseMessaging.onMessage.listen((event) {
    print('on message');
    print(event.data.toString());
    showToast(text: 'on message', state: ToastStates.SUCCESS);
  });


  FirebaseMessaging.onMessageOpenedApp.listen((event) {
    print('on message opened app');
    print(event.data.toString());
    showToast(text: 'on message opened app', state: ToastStates.SUCCESS);
  });

  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  Bloc.observer = MyBlocObserver();
  DioHelper.init();
  await CacheHelper.init();

    Widget? widget;
    // bool onBoarding = CacheHelper.getData(key: 'onBoarding');
    // String token = CacheHelper.getData(key: 'token');
    uId = CacheHelper.getData(key: 'uId');
      //token = CacheHelper.getData(key: 'token');
    //
    // if(onBoarding!=null){
    //   if(token!=null) widget= ShopLayout() ;
    //   else widget= ShopLoginScreen() ;
    // }else{
    //   widget= OnBoardingScreen() ;
    // }

  if(uId!= null){
    widget = SocialLayout();
  }else{
    widget = SocialLoginScreen();
  }




  runApp(MyApp(
   // isDark:isDark ,
    startWidget: widget,
  ));

}


//Statelass
//Stateful

class MyApp extends StatelessWidget{
//  final bool isDark;
 final Widget startWidget;
//
 MyApp({
   // required this.isDark,
   required this.startWidget
});

  //Constructor
  //build

  @override
  Widget build(BuildContext context)
  {
    return MultiBlocProvider(
      providers: [

        BlocProvider(create: (context) => AppCubit()..changeAppMod(
          // fromShared: isDark,
        )),

        BlocProvider(create: (context) => SocialCubit()..getUserData()..getPosts()),
      ],
      child: BlocConsumer<AppCubit,AppStates>(
        listener: (context, state) {

        },
        builder: (context, state) {
          return  MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: lightTheme,
            darkTheme: darkTheme,
            // themeMode:AppCubit.get(context).isDark?ThemeMode.dark:ThemeMode.light ,
            home:Directionality(
                textDirection: TextDirection.ltr,
                child:NativeCodeScreen(),
                // child:ShopLayout(),
              //child:onBoarding? ShopLoginScreen() :OnBoardingScreen()
              // child:startWidget
            ),
          );
        },
      ),
    );
  }

}

