import 'package:ayhaga/layout/social_app/cubit/cubit.dart';
import 'package:ayhaga/layout/social_app/cubit/states.dart';
import 'package:ayhaga/models/social_app/social_usre_model.dart';
import 'package:ayhaga/modules/social_app/chat_details/chat_details_screen.dart';
import 'package:ayhaga/shared/components/components.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatsScreen extends StatelessWidget {
  const ChatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit,SocialStates>(
     listener: (context, state) {

     },
      builder: (context, state) {
        return ConditionalBuilder(
          condition:SocialCubit.get(context).users.length>0 ,
          builder: (context) => ListView.separated(
              physics: BouncingScrollPhysics(),
              itemBuilder: (context, index) =>buildChatItem(SocialCubit.get(context).users[index] ,context) ,
              separatorBuilder: (context, index) => myDivider(),
              itemCount: SocialCubit.get(context).users.length,
          ),
          fallback: (context) => Center(child: CircularProgressIndicator()),
        );

      }
    );
  }





  Widget buildChatItem(SocialUserModel model , context )=>InkWell(
    child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 25.0,
            backgroundImage: NetworkImage(
              '${model.image}'
            ),
          ),
          SizedBox(
            width: 20.0,
          ),
          Text(
            '${model.name}',
            style: TextStyle(
              height: 1.4,
            ),
          ),
        ],
      ),
    ),
    onTap: (){
      navigateTo(context, ChatDetailsScreen(
        userModel: model,
      ));
    },
  );
}
