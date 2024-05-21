import 'package:ayhaga/layout/social_app/cubit/cubit.dart';
import 'package:ayhaga/layout/social_app/cubit/states.dart';

import 'package:ayhaga/modules/social_app/new_post/new_post_screen.dart';
import 'package:ayhaga/shared/components/components.dart';
import 'package:ayhaga/shared/styles/icon_broken.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SocialLayout extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit , SocialStates>(
      listener: (context, state) {
        if(state is SocialNewPostState){
          navigateTo(context, NewPostScreen());
        }
      },
      builder: (context, state) {
        var cubit =  SocialCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            title: Text(
             cubit.titles[cubit.currentIndex],
            ),
            actions: [
              IconButton(onPressed: (){}, icon: Icon(IconBroken.Notification),),
              IconButton(onPressed: (){}, icon: Icon(IconBroken.Search),),
            ],
          ),
          body: cubit.bottomScreens[cubit.currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: cubit.currentIndex,
            onTap: (index) {
              cubit.changeBottom(index);
             },
            items: [
              BottomNavigationBarItem(
                icon: Icon(
                    IconBroken.Home,
                ),
                label: 'Home'
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  IconBroken.Chat,
                ),
                label: 'Chats'
              ),
              BottomNavigationBarItem(
                icon: Icon(
                    IconBroken.Paper_Upload,
                ),
                label: 'Post'
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  IconBroken.Location,
                ),
                label: 'Users'
              ),
              BottomNavigationBarItem(
                icon: Icon(
                    IconBroken.Setting,
                ),
                label: 'Settings'
              ),
            ],
          ),
        );
      },
    );
  }
}




















//if(!FirebaseAuth.instance.currentUser!.emailVerified)
//                     Container(
//                       color: Colors.amber.withOpacity(0.6),
//                       child: Padding(
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 20.0
//                         ),
//                         child: Row(
//                           children: [
//                             Icon(
//                               Icons.info_outline,
//                             ),
//                             SizedBox(
//                               width: 15.0,
//                             ),
//                             Expanded(
//                               child: Text(
//                                 'please verify your email ',
//                               ),
//                             ),
//                             SizedBox(
//                               width: 15.0,
//                             ),
//                             defaultTextButton(
//                               Function: (){
//                                 FirebaseAuth.instance.currentUser
//                                     ?.sendEmailVerification()
//                                     .then((value) {
//                                       showToast(text: 'check your mail', state: ToastStates.SUCCESS);
//                                 })
//                                     .catchError((error){});
//                               },
//                               text: 'send',
//                             )
//                           ],
//                         ),
//                       ),
//                     ),