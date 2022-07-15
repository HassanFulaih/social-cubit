import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../components/custom_snackbar.dart';
import '../constants.dart';
import '../helpers/cache.dart';
import '../models/message_model.dart';
import '../models/post_model.dart';
import '../models/user_model.dart';
import '../tabs/chats.dart';
import '../tabs/feeds.dart';
import '../tabs/settings.dart' as settings;
import 'social_state.dart';

class SocialCubit extends Cubit<SocialStates> {
  SocialCubit() : super(SocialInitialStates());

  static SocialCubit get(context) => BlocProvider.of(context);

  List<Widget> screens = [
    const Feeds(),
    const Chats(),
    const settings.Settings(),
  ];
  int currentIndex = 0;
  final db = FirebaseFirestore.instance;
  List<UserData> users = [];
  List<MessageModel> messages = [];
  UserData? userData;
  List<PostModel> posts = [];

  final ImagePicker picker = ImagePicker();
  File? profileImage;
  File? coverImage;
  File? postImage;

  String? profileImageUrl;
  String? coverImageUrl;
  String? postImageUrl;

  void changeTab(int index) {
    if (index == 1) getAllUser();
    currentIndex = index;
    emit(SocialBottomNavStatus());
  }

  void getUserData() {
    if (appToken.isEmpty) return;
    //print('App token from getUserData: $appToken');
    emit(SocialUserDataLoadingStatus());
    db.collection('users').doc(appToken).get().then(
      (DocumentSnapshot doc) {
        final data = doc.data() as Map<String, dynamic>;
        log(data.toString());
        // data = {uid: Ocqm6QIFsNctCrRtD2SMlBoRpOa2, image: null, phone: 12345678901, name: hassan, email: u@gmail.com}
        userData = UserData.fromJson(data);
        emit(SocialUserDataSuccessStatus());
      },
      onError: (e) {
        log('Error getting document: $e');
        emit(SocialUserDataErrorStatus(e.toString()));
      },
    );
  }

  getInteraction() {
    emit(GetInteractionLoadingStatus());
    for (int i = 0; i < posts.length; i++) {
      db
          .collection('posts')
          .doc(posts[i].postId)
          .collection('interaction')
          .get()
          .then(
        (QuerySnapshot<Map<String, dynamic>> doc) {
          int numOfLikes = 0;
          int numOfComments = 0;
          List<InteractionModel> interaction = [];

          for (var innerElement in doc.docs) {
            if (innerElement.data()['like'] == true) {
              numOfLikes += 1;
            }
            if (innerElement.data()['comment'] != null) {
              numOfComments += 1;
            }
            interaction.add(
              InteractionModel.fromJson(innerElement.data(), innerElement.id),
            );
          }
          posts[i].numOfLikes = numOfLikes;
          posts[i].numOfComments = numOfComments;
          posts[i].interaction = interaction;

          emit(GetInteractionSuccessStatus());
        },
        onError: (e) {
          log('Error getting document: $e');
          emit(GetInteractionErrorStatus(e.toString()));
        },
      );
    }
  }

  void getPosts() {
    if (appToken.isEmpty) return;
    posts.clear();
    emit(SocialGetPostsLoadingStatus());

    db.collection('posts').get().then(
      (QuerySnapshot<Map<String, dynamic>> doc) {
        for (var element in doc.docs) {
          posts.add(
            PostModel.fromJson(element.data(), element.id),
          );
        }
        emit(SocialGetPostsSuccessStatus());

        getInteraction();
      },
      onError: (e) {
        log('Error getting document: $e');
        emit(SocialGetPostsErrorStatus(e.toString()));
      },
    );
  }

  Future<File?> pickImage(ImageSource source, String type) async {
    final XFile? pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      if (type == 'profile') {
        profileImage = File(pickedFile.path);
        emit(SocialProfileImgSuccessStatus());
        return profileImage;
      } else if (type == 'cover') {
        coverImage = File(pickedFile.path);
        emit(SocialCoverImgSuccessStatus());
        return coverImage;
      } else {
        postImage = File(pickedFile.path);
        emit(SocialPostImgSuccessStatus());
        return postImage;
      }
    }
    return null;
  }

  removeImage(String type) {
    if (type == 'profile') {
      profileImage = null;
      emit(RemoveProfileImgStatus());
    } else if (type == 'cover') {
      coverImage = null;
      emit(RemoveCoverImgStatus());
    } else {
      postImage = null;
      emit(RemovePostImgStatus());
    }
  }

  uploadImage(BuildContext ctx, String type, File image) {
    emit(type == 'profile'
        ? UploadProfileImgLoadingStatus()
        : UploadCoverImgLoadingStatus());
    FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(image.path).pathSegments.last}')
        .putFile(type == 'profile' ? profileImage! : coverImage!)
        .then((p0) {
      p0.ref.getDownloadURL().then((value) =>
          type == 'profile' ? profileImageUrl = value : coverImageUrl = value);
      emit(type == 'profile'
          ? UploadProfileImgSuccessStatus()
          : UploadCoverImgSuccessStatus());
      showSnakBar(ctx, 'Upload completed', defaultColor);
    }).catchError((e) {
      log('Error uploading image: $e');
      emit(type == 'profile'
          ? UploadProfileImgErrorStatus(e.toString())
          : UploadCoverImgErrorStatus(e.toString()));
      showSnakBar(ctx, 'Error updating document: $e', defaultColor);
    });
  }

  update(BuildContext ctx,
      {required String name, required String phone, required String bio}) {
    emit(UpdateLoadingStatus());

    //  'name': name,
    //   'phone': phone,
    //   'bio': bio,
    //   'image': profileImageUrl ?? userData!.image,
    //   'cover': coverImageUrl ?? userData!.cover,
    UserData user = UserData(
      name: name,
      phone: phone,
      bio: bio,
      image: profileImageUrl ?? userData!.image,
      cover: coverImageUrl ?? userData!.cover,
      uid: userData!.uid,
      email: userData!.email,
    );
    db
        .collection('users')
        .doc(userData!.uid)
        .update(user.toJson())
        .then((value) {
      showSnakBar(ctx, 'Profile Updated Successfully', defaultColor);
      emit(UpdateSuccessStatus());
      getUserData();
    }).catchError((e) {
      showSnakBar(ctx, 'Error updating profile: $e', defaultColor);
      emit(UpdateErrorStatus(e.toString()));
    });
  }

  createPost(
    BuildContext ctx, {
    required String dateTime,
    required String text,
  }) {
    emit(CreatePostLoadingStatus());

    if (postImage != null) {
      FirebaseStorage.instance
          .ref()
          .child('posts/${Uri.file(postImage!.path).pathSegments.last}')
          .putFile(postImage!)
          .then((p0) {
        p0.ref.getDownloadURL().then((value) {
          postImageUrl = value;
          sendPostFirebase(ctx, dateTime, text);
          postImage = null;
        });
      }).catchError((e) {
        log('Error uploading post image: $e');
        showSnakBar(ctx, 'Error updating document: $e', defaultColor);
      });
    } else {
      sendPostFirebase(ctx, dateTime, text);
    }
  }

  sendPostFirebase(BuildContext ctx, String dateTime, String text) {
    // PostModel post = PostModel(
    //   uId: userData!.uid,
    //   name: userData!.name,
    //   image: userData!.image,
    //   dateTime: dateTime,
    //   text: text,
    //   postImage: postImageUrl,
    // );

    db.collection('posts').add({
      'uId': userData!.uid,
      'name': userData!.name,
      'image': userData!.image,
      'dateTime': dateTime,
      'text': text,
      'postImage': postImageUrl,
    }).then((value) {
      showSnakBar(ctx, 'Post Created', defaultColor);
      emit(CreatePostSuccessStatus());
      getPosts();
    }).catchError((e) {
      showSnakBar(ctx, 'Error updating document: $e', defaultColor);
      emit(CreatePostErrorStatus(e.toString()));
    });
  }

  void likePost(InteractionModel interaction, String postId) {
    interaction.isLiked = !interaction.isLiked;
    emit(SocialLikePostLoadingStatus());

    db
        .collection('posts')
        .doc(postId)
        .collection('interaction')
        .doc(userData!.uid)
        .update({
      'like': interaction.isLiked,
      'name': interaction.name,
      'image': interaction.image,
      'comment': interaction.comment,
    }).then((value) {
      emit(SocialLikePostSuccessStatus());
      getPosts();
    }).catchError((e) {
      log('Error liking post: $e');
      interaction.isLiked = !interaction.isLiked;
      emit(SocialLikePostErrorStatus(e.toString()));
    });
  }

  void addComment(String postId, String comment, InteractionModel interaction) {
    emit(SocialAddCommentLoadingStatus());

    db
        .collection('posts')
        .doc(postId)
        .collection('interaction')
        .doc(userData!.uid)
        .update({
      'comment': comment,
      'name': userData!.name,
      'image': userData!.image,
      'like': interaction.isLiked,
    }).then((value) {
      emit(SocialAddCommentSuccessStatus());
      getPosts();
    }).catchError((e) {
      log('Error adding a comment: $e');
      emit(SocialAddCommentErrorStatus(e.toString()));
    });
  }

  void getAllUser() {
    if (users.isNotEmpty) return;
    emit(GetAllUserLoadingStatus());
    db.collection('users').get().then(
      (QuerySnapshot<Map<String, dynamic>> doc) {
        for (var e in doc.docs) {
          if (e.data()['uid'] != userData!.uid)
            users.add(UserData.fromJson(e.data()));
          //users.add(UserData.fromJson(e.data()));
        }
        emit(GetAllUserSuccessStatus());
      },
      onError: (e) {
        log('Error getting document: $e');
        emit(GetAllUserErrorStatus(e.toString()));
      },
    );
  }

  void sendMessage({
    required String receiverId,
    required String text,
    required String dateTime,
  }) {
    emit(SendMessageLoadingStatus());
    MessageModel messageModel = MessageModel(
      senderId: userData!.uid,
      receiverId: receiverId,
      text: text,
      time: dateTime,
    );
    db
        .collection('users')
        .doc(userData!.uid)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .add(messageModel.toJson())
        .then((value) {
      emit(SendMessageSuccessStatus());
    }).catchError((e) {
      log('Error sending message: $e');
      emit(SendMessageErrorStatus(e.toString()));
    });
    db
        .collection('users')
        .doc(receiverId)
        .collection('chats')
        .doc(userData!.uid)
        .collection('messages')
        .add(messageModel.toJson())
        .then((value) {
      emit(SendMessageSuccessStatus());
    }).catchError((e) {
      log('Error sending message: $e');
      emit(SendMessageErrorStatus(e.toString()));
    });
  }

  // void getMessages(String receiverId) {
  //   emit(GetMessagesLoadingStatus());
  //   db
  //       .collection('users')
  //       .doc(userData!.uid)
  //       .collection('chats')
  //       .doc(receiverId)
  //       .collection('messages')
  //       .orderBy('time')
  //       .snapshots()
  //       .listen((QuerySnapshot<Map<String, dynamic>> event) {
  //     for (var e in event.docs) {
  //       messages = [];
  //       messages.add(MessageModel.fromJson(e.data()));
  //     }
  //     emit(GetMessagesSuccessStatus());
  //   });
  // }

  ThemeMode tm = ThemeMode.light;

  void changeThemeMode() {
    if (tm == ThemeMode.light) {
      tm = ThemeMode.dark;
    } else {
      tm = ThemeMode.light;
    }

    CacheHelper.setBool('isLightMode', tm == ThemeMode.light).then(
      (value) => emit(ThemeChangedState()),
    );
  }

  takeCachedThemeMode() {
    if (!CacheHelper.checkForKey('isLightMode')) return;
    bool? lightMode = CacheHelper.getBool('isLightMode');
    if (lightMode != null) {
      tm = lightMode ? ThemeMode.light : ThemeMode.dark;
    }
  }

  void takeCachedData() {
    String? token_ = CacheHelper.getData('token');

    if (token_ != null) {
      log('token: $token_');
      appToken = token_;
      log('token: $appToken');
    }
  }

  // void sendEmailVerification(BuildContext ctx) {
  //   FirebaseAuth.instance.currentUser!.sendEmailVerification().then((value) {
  //     db
  //         .collection('users')
  //         .doc(appToken)
  //         .update({'is_verified': true}).then((value) {
  //       userData!.isVerified = true;
  //       emit(EmailVerificationCompleteStatus());
  //       showSnakBar(ctx, 'Email Verified', defaultColor);
  //     }).catchError((e) {
  //       log('Error updating document: $e');
  //     });
  //   }, onError: (e) {
  //     log('Error sending email: $e');
  //   });
  // }
}
