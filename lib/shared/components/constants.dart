


import 'package:ayhaga/modules/social_app/social_login/social_login_screen.dart';
import 'package:ayhaga/shared/components/components.dart';
import 'package:ayhaga/shared/network/local/cache_helper.dart';

void signOut (context){
  CacheHelper.removeData(key: 'token').then((value) {
    if (value){
      navigateAndFinish(context, SocialLoginScreen());
    }
  });
}



String ?uId;