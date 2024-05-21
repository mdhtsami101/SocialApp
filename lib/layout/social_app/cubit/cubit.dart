

import 'dart:io';

import 'package:ayhaga/layout/social_app/cubit/states.dart';
import 'package:ayhaga/models/social_app/message_model.dart';
import 'package:ayhaga/models/social_app/post_model.dart';

import 'package:ayhaga/models/social_app/social_usre_model.dart';



import 'package:ayhaga/modules/social_app/chats/chats_screen.dart';
import 'package:ayhaga/modules/social_app/feeds/feeds_screen.dart';
import 'package:ayhaga/modules/social_app/new_post/new_post_screen.dart';
import 'package:ayhaga/modules/social_app/settings/settings_screen.dart';
import 'package:ayhaga/modules/social_app/users/users_screen.dart';
import 'package:ayhaga/shared/components/constants.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;


class SocialCubit extends Cubit<SocialStates> {
  SocialCubit() : super(SocialInitialState());

  static SocialCubit get(context) => BlocProvider.of(context);


  SocialUserModel? userModel;

  void getUserData() {
    emit(SocialGetUserLoadingState());
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .get()
        .then((value) {
      print(value.data());
      userModel = SocialUserModel.fromJson(value.data()!);
      emit(SocialGetUserSuccessState());
    })
        .catchError((error) {
      print(error.toString());
      emit(SocialGetUserErrorState(error.toString()));
    });
  }

  int currentIndex = 0;

  List<Widget> bottomScreens = [
    FeedsScreen(),
    ChatsScreen(),
    NewPostScreen(),
    UsersScreen(),
    SettingsScreen(),

  ];
  List<String> titles = [
    'Home',
    'Chats',
    'Post',
    'Users',
    'Sittings',
  ];

  void changeBottom(int index) {

    if (index == 1)
      getUsers();
     if (index == 2)
      emit(SocialNewPostState());
    else {
      currentIndex = index;
      emit(SocialChangeBottomNavState());
    }
  }

  File? profileImage;
  var picker = ImagePicker();

  Future<void> getProfileImage() async {
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      profileImage = File(pickedFile.path);
      print(pickedFile.path);
      emit(SocialProfileImagePickedSuccessState());
    } else {
      print('No image selected.');
      emit(SocialProfileImagePickedErrorState());
    }
  }


  File? coverImage;

  Future<void> getCoverImage() async {
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      coverImage = File(pickedFile.path);
      emit(SocialCoverImagePickedSuccessState());
    } else {
      print('No image selected.');
      emit(SocialCoverImagePickedErrorState());
    }
  }


  // void uploadProfileImage(){
  //   firebase_storage.FirebaseStorage.instance
  //       .ref()
  //       .child('users/${Uri.file(profileImage!.path).pathSegments.last}')
  //       .putFile(profileImage!)
  //       .then((value){
  //         value.ref.getDownloadURL().then((value){
  //           print(value);
  //         }).catchError((error){});
  //   })
  //       .catchError((error){});
  //
  // }




  void uploadProfileImage({
    required String name,
    required String phone,
    required String bio,
}) {
    if (profileImage == null) {
      print('Profile image is null');
      return;
    }
    emit(SocialUserUpdateLoadingState());
    final storageRef = firebase_storage.FirebaseStorage.instance.ref();
    final imageFileName = Uri
        .file(profileImage!.path)
        .pathSegments
        .last;
    final imageRef = storageRef.child('users/$imageFileName');

    imageRef.putFile(profileImage!).then((value) {
      // Upload successful, get the download URL
      value.ref.getDownloadURL().then((value) {
        // emit(SocialUploadProfileImageSuccessState());
        // Handle the download URL, for example, save it to the user's profile
        print(value);
        updateUser(name: name, phone: phone, bio: bio,image: value);

      }).catchError((error) {
        emit(SocialUploadProfileImageErrorState());
        // Handle errors while getting the download URL
        print('Error getting download URL: $error');
      });
    }).catchError((error) {
      emit(SocialUploadProfileImageErrorState());
      // Handle errors while uploading the image
      print('Error uploading image: $error');
    });
  }




  void uploadCoverImage({
    required String name,
    required String phone,
    required String bio,
}) {
    if (coverImage == null) {
      print('cover image is null');
      return;
    }
    emit(SocialUserUpdateLoadingState());
    final storageRef = firebase_storage.FirebaseStorage.instance.ref();
    final imageFileName = Uri
        .file(coverImage!.path)
        .pathSegments
        .last;
    final imageRef = storageRef.child('users/$imageFileName');

    imageRef.putFile(coverImage!).then((value) {
      // Upload successful, get the download URL
      value.ref.getDownloadURL().then((value) {
        // emit(SocialUploadCoverImageSuccessState());
        // Handle the download URL, for example, save it to the user's profile
        print(value);
        updateUser(name: name, phone: phone, bio: bio,cover: value);
      }).catchError((error) {
        emit(SocialUploadCoverImageErrorState());
      });
    }).catchError((error) {
      emit(SocialUploadCoverImageErrorState());
    });
  }

  // void updateUserImages({
  //   required String name,
  //   required String phone,
  //   required String bio,
  // }) {
  //
  //   emit(SocialGetUserLoadingState());
  //   if (coverImage != null)
  //   {
  //     uploadCoverImage();
  //   } else if (profileImage != null)
  //   {
  //     uploadProfileImage();
  //   } else if(coverImage != null && profileImage != null)
  //   {} else {
  //       updateUser(
  //           name: name,
  //           phone: phone,
  //           bio: bio);
  //   }
  // }



  void updateUser({
    required String name,
    required String phone,
    required String bio,
    String? image,
    String? cover,
  }){
    SocialUserModel model = SocialUserModel(
      name: name,
      phone: phone,
      bio: bio,
      email:  userModel!.email,
      uId:  userModel!.uId,
      cover: cover?? userModel!.cover,
      image: image?? userModel!.image,
      isEmailVerifide: false,
    );
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel!.uId)
        .update(model.toMap())
        .then((value) {
      getUserData();
    })
        .catchError((error) {
      emit(SocialUserUpdateErrorState());
    });
  }



  File? postImage;

  Future<void> getPostImage() async {
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      postImage = File(pickedFile.path);
      emit(SocialPostImagePickedSuccessState());
    } else {
      print('No image selected.');
      emit(SocialPostImagePickedErrorState());
    }
  }


  void removePostImage(){
    postImage = null;
    emit(SocialRemovePostImageState());
  }

  void uploadPostImage({
    required String dateTime ,
    required String text ,

  }) {
    emit(SocialCreatePostLoadingState());
    final storageRef = firebase_storage.FirebaseStorage.instance.ref();
    final imageFileName = Uri
        .file(postImage!.path)
        .pathSegments
        .last;
    final imageRef = storageRef.child('posts/$imageFileName');

    imageRef.putFile(postImage!).then((value) {
      // Upload successful, get the download URL
      value.ref.getDownloadURL().then((value) {

        // Handle the download URL, for example, save it to the user's profile
        print(value);
        createPost(dateTime: dateTime, text: text , postImage: value);

      }).catchError((error) {
        emit(SocialCreatePostErrorState());
      });
    }).catchError((error) {
      emit(SocialCreatePostErrorState());
    });
  }



  void createPost({
    required String dateTime ,
    required String text ,
    String? postImage,
  }){

    emit(SocialCreatePostLoadingState());
    PostModel model = PostModel(
      name: userModel!.name,
      uId:  userModel!.uId,
      image:userModel!.image,
      dateTime: dateTime,
      text: text,
      postImage: postImage??'',

    );
    FirebaseFirestore.instance
        .collection('posts')
        .add(model.toMap())
        .then((value) {
          emit(SocialCreatePostSuccessState());
    })
        .catchError((error) {
      emit(SocialCreatePostErrorState());
    });
  }

  List<PostModel> posts = [];
  List<String> postsId = [];
  List<int> likes = [];
   var likeCount;

  void getPosts(){
    FirebaseFirestore.instance
        .collection('posts')
        .orderBy('dateTime')    
        .snapshots()
        .listen((event) {
         event.docs.forEach((element) {
            element.reference
              .collection('likes')
              .snapshots()
              .listen((event) {
                likes.add(event.docs.length);
                postsId.add(element.id);
                posts.add(PostModel.fromJson(element.data()));
          });
      });
         emit(SocialGetPostsSuccessState());
      });
    //     .get()
    //     .then((value) {
    //       value.docs.forEach((element) {
    //         element.reference
    //         .collection('likes')
    //         .get()
    //         .then((value) {
    //           likes.add(value.docs.length);
    //           postsId.add(element.id);
    //           posts.add(PostModel.fromJson(element.data()));
    //         })
    //         .catchError((error){});
    //
    //       });
    //       emit(SocialGetPostsSuccessState());
    // })
    //     .catchError((error){
    //       emit(SocialGetPostsErrorState(error.toString()));
    // });
        
  }


  void likePost(postId){
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .doc(userModel!.uId)
        .set({
         'like':true ,
    })
        .then((value) {
          emit(SocialLikePostSuccessState());
    })
        .catchError((error){
          emit(SocialLikePostErrorState(error.toString()));
    });
  }

  void listenToLikes(postId) {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .snapshots()
        .listen((event) {
          likeCount = event.docs.length;

    });
  }


  List<SocialUserModel> users = [];

  void getUsers(){
    if(users.length==0)
      FirebaseFirestore.instance
          .collection('users')
          .get()
          .then((value) {
        value.docs.forEach((element) {
          if(element.data()['uId']!=userModel!.uId)
            users.add(SocialUserModel.fromJson(element.data()));
        });
        emit(SocialGetAllUserSuccessState());
      })
          .catchError((error){
        emit(SocialGetAllUserErrorState(error.toString()));
      });

  }

  void sendMessage({
    required String receiverId,
    required String dateTime,
    required String text,
}){
    MessageModel model = MessageModel(
      text: text,
      dateTime: dateTime,
      receiverId: receiverId,
      senderId: userModel!.uId
    );
    FirebaseFirestore.instance
    .collection('users')
    .doc(userModel!.uId)
    .collection('chats')
    .doc(receiverId)
    .collection('messages')
    .add(model.toMap())
    .then((value){
      emit(SocialSendMessageSuccessState());
    })
    .catchError((error){
      emit(SocialSendMessageErrorState());
    });

    FirebaseFirestore.instance
        .collection('users')
        .doc(receiverId)
        .collection('chats')
        .doc(userModel!.uId)
        .collection('messages')
        .add(model.toMap())
        .then((value){
      emit(SocialSendMessageSuccessState());
    })
        .catchError((error){
      emit(SocialSendMessageErrorState());
    });

  }

  List<MessageModel> messages=[];


    void getMessages({
      required String receiverId,
    }) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(userModel!.uId)
          .collection('chats')
          .doc(receiverId)
          .collection('messages')
          .orderBy('dateTime')
          .snapshots()
          .listen((event){
             messages=[];
            event.docs.forEach((element) {
              messages.add(MessageModel.fromJson(element.data()));
            });
        emit(SocialGetMessagesSuccessState());
      });
  }


}