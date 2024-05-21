import 'package:ayhaga/layout/social_app/cubit/cubit.dart';
import 'package:ayhaga/layout/social_app/cubit/states.dart';
import 'package:ayhaga/models/social_app/post_model.dart';
import 'package:ayhaga/shared/styles/colors.dart';
import 'package:ayhaga/shared/styles/icon_broken.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FeedsScreen extends StatelessWidget {
  const FeedsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit,SocialStates>(
      listener: (context, state) {

      },
      builder: (context, state) {
        return ConditionalBuilder(
          condition:SocialCubit.get(context).posts.length > 0 ,// && SocialCubit.get(context).userModel!= null  ,
          builder: (context) =>  SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                Card(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  elevation: 5.0,
                  margin: EdgeInsets.all(8.0),
                  child: Stack(alignment: AlignmentDirectional.bottomStart, children: [
                    Image(
                      image: NetworkImage(
                          'https://img.freepik.com/free-photo/thoughtful-young-lady-stand-pink-background-thinking-high-quality-photo_144627-76442.jpg?t=st=1713274031~exp=1713277631~hmac=57384a1dd312a1ebfb83540ab13dffeb72a7f77430238b250fd846ccdb1863e0&w=996'),
                      fit: BoxFit.cover,
                      height: 200.0,
                      width: double.infinity,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'communicate with friends',
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                    ),
                  ]),
                ),
                ListView.separated(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) => bulidPostItem(SocialCubit.get(context).posts[index],context, index),
                    separatorBuilder: (context, index) => SizedBox(
                      height: 8.0,
                    ),
                    itemCount: SocialCubit.get(context).posts.length
                )
              ],
            ),
          ),
          fallback: (context) => Center(child: CircularProgressIndicator()),
        );
      },
    );
  }



  Widget bulidPostItem( PostModel model,context , index)=>Card(
    clipBehavior: Clip.antiAliasWithSaveLayer,
    elevation: 5.0,
    margin: EdgeInsets.symmetric(
      horizontal: 8.0,
    ),
    child: Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 25.0,
                backgroundImage: NetworkImage(
                    '${model.image}'),
              ),
              SizedBox(
                width: 20.0,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          '${model.name}',
                          style: TextStyle(
                            height: 1.4,
                          ),
                        ),
                        SizedBox(
                          width: 5.0,
                        ),
                        Icon(
                          Icons.verified,
                          color: Colors.blueAccent,
                          size: 16.0,
                        ),
                      ],
                    ),
                    Text(
                      '${model.dateTime}',
                      style:
                      Theme.of(context).textTheme.caption!.copyWith(
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 20.0,
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.more_horiz,
                  size: 16.0,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15.0),
            child: Container(
              width: double.infinity,
              height: 1.0,
              color: Colors.grey[350],
            ),
          ),
          Text(
              '${model.text}',
            style: Theme.of(context).textTheme.subtitle1?.copyWith(
              height: 1.3,
            ),
          ),
          // SizedBox(
          //   height: 15.0,
          // ) ,
          // Padding(
          //   padding: const EdgeInsets.only(
          //       bottom: 10.0,
          //       top: 5.0
          //   ),
          //   child: Container(
          //     width: double.infinity,
          //     child: Wrap(
          //       children: [
          //         Padding(
          //           padding: const EdgeInsets.only(
          //               right: 6.0
          //           ),
          //           child: Container(
          //             child: MaterialButton(
          //               onPressed: () {},
          //               minWidth: 1.0,
          //               padding: EdgeInsets.zero,
          //               child: Text(
          //                 '#software',
          //                 style: Theme.of(context).textTheme.caption?.copyWith(
          //                   color: defaultColor,
          //                 ),
          //               ),
          //             ),
          //             height: 25.0,
          //           ),
          //         ),
          //         Padding(
          //           padding: const EdgeInsets.only(
          //               right: 6.0
          //           ),
          //           child: Container(
          //             child: MaterialButton(
          //               onPressed: () {},
          //               minWidth: 1.0,
          //               padding: EdgeInsets.zero,
          //               child: Text(
          //                 '#flutter',
          //                 style: Theme.of(context).textTheme.caption?.copyWith(
          //                   color: defaultColor,
          //                 ),
          //               ),
          //             ),
          //             height: 25.0,
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
          if(model.postImage!='')
            Padding(
            padding: const EdgeInsets.only(
              top: 15.0,
            ),
            child: Container(
              height: 140.0,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  4.0,
                ),
                image: DecorationImage(
                  image: NetworkImage(
                      '${model.postImage}'
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
                vertical: 5.0
            ),
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5.0
                      ),
                      child: Row(
                        children: [
                          Icon(
                            IconBroken.Heart,
                            size: 18.0,
                            color: Colors.red,
                          ),
                          SizedBox(
                            width: 5.0,
                          ),
                          Text(
                            '${SocialCubit.get(context).likes[index]}',
                            style: Theme.of(context).textTheme.caption,
                          ),
                        ],
                      ),
                    ),
                    onTap: (){},
                  ),
                ),
                Expanded(
                  child: InkWell(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5.0
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Icon(
                            IconBroken.Chat,
                            size: 18.0,
                            color: Colors.amber[400],
                          ),
                          SizedBox(
                            width: 5.0,
                          ),
                          Text(
                            '0 comments',
                            style: Theme.of(context).textTheme.caption,
                          ),
                        ],
                      ),
                    ),
                    onTap: (){},
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                bottom: 10.0
            ),
            child: Container(
              width: double.infinity,
              height: 1.0,
              color: Colors.grey[350],
            ),
          ),
          Row(
            children: [
              Expanded(
                child: InkWell(
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 18.0,
                        backgroundImage: NetworkImage(
                            '${SocialCubit.get(context).userModel!.image}'
                        ),
                      ),
                      SizedBox(
                        width: 20.0,
                      ),
                      Text(
                        'write a comment ...',
                        style:
                        Theme.of(context).textTheme.caption!.copyWith(
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                  onTap: (){},
                ),
              ),
              InkWell(
                child: Row(
                  children: [
                    Icon(
                      IconBroken.Heart,
                      size: 18.0,
                      color: Colors.red,
                    ),
                    SizedBox(
                      width: 5.0,
                    ),
                    Text(
                      'like',
                      style: Theme.of(context).textTheme.caption,
                    ),
                  ],
                ),
                onTap: (){
                  SocialCubit.get(context).likePost(SocialCubit.get(context).postsId[index]);
                },
              ),

            ],
          ),
        ],
      ),
    ),
  );
}
