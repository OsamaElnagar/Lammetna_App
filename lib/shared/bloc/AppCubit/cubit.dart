import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_app/models/chatModel.dart';
import 'package:social_app/models/commentModel.dart';
import 'package:social_app/models/commentReplyModel.dart';
import 'package:social_app/models/likePostModel.dart';
import 'package:social_app/models/loginModel.dart';
import 'package:social_app/models/postModel.dart';
import 'package:social_app/modules/chatsScreen.dart';
import 'package:social_app/modules/loginScreen.dart';
import 'package:social_app/modules/visitedProfileScreen.dart';
import 'package:social_app/shared/bloc/AppCubit/states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/network/local/cache_helper.dart';
import '../../../models/boardingModel.dart';
import '../../../models/storyModel.dart';
import '../../../modules/feedsScreen.dart';
import '../../../modules/profileScreen.dart';
import '../../components/constants.dart';
import '../../styles/iconBroken.dart';
import 'dart:io';
import 'package:video_player/video_player.dart';
import 'package:image_picker/image_picker.dart';
class AppCubit extends Cubit<AppStates> {
  AppCubit(AppStates initialState) : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  LoginModel? loginModel;
  PostModel? postModel;
  LikePostModel? likePostModel;
  File? postImageFile;
  File? postVideoFile;
  File? profileImageFile;
  File? storyImageFile;
  File? storyVideoFile;
  File? coverImageFile;
  File? commentImageFile;
  File? commentReplyImageFile;
  File? messageImageFile;
  ImagePicker picker = ImagePicker();
  List postImageFiles = [];
  List<String> myPostId = [];
  List<String> feedPostId = [];
  List<String> commentId = [];
  List<PostModel> feedPosts = [];
  List<PostModel> myPosts = [];
  List<CommentModel> comments = [];
  String? newPostId;
  List<CommentReplyModel> commentsReply = [];
  List<CommentReplyModel> storedReply = [];
  String? newCommentId;
  List<String> replyId = [];
  List<int> commentCounter = [];
  List<LoginModel> allUsers = [];
  List<StoryModel> stories = [];
  List<String> storyId = [];
  List<ChatsModel> messages = [];
  Map<String, dynamic> user = {};
  List<PostModel> visitedUserPosts = [];
  String repeatedId='';
  List<String> usersUIds = [];
  List<PostModel> gg=[];

////////////////////////////////
  void getGalleryPostVideo() async {
    var pickedFile = await picker.pickVideo(source: ImageSource.gallery);
    if (pickedFile != null) {
      postVideoFile = File(pickedFile.path);

      emit(AppGetGalleryImageSuccessState());
    } else {
      pint('No Video selected');
      emit(AppGetGalleryImageErrorState());
    }
  }

  void getCameraPostVideo() async {
    var pickedFile = await picker.pickVideo(source: ImageSource.camera);
    if (pickedFile != null) {
      postVideoFile = File(pickedFile.path);
      emit(AppGetCameraImageSuccessState());
    } else {
      pint('No Video selected');
      emit(AppGetCameraImageErrorState());
    }
  }
////////////////////////////////
  void fillUsersUIds(){
    usersUIds.clear();
    gg.clear();
    emit(AppFillUsersUIdsLoadingState());
    FirebaseFirestore.instance.
    collection('users').get().then((value) {
      for (var element in value.docs){
        usersUIds.add(element.id);
        element.reference.collection('posts').get().then((value) {
          for(var ele in value.docs){
            gg.add(PostModel.fromJson(ele.data()));
            pint(gg.length.toString());
          }
        });
        pint(usersUIds.toString());

        emit(AppFillUsersUIdsSuccessState());
      }
    }).catchError((onError){
      pint(onError.toString());
      emit(AppFillUsersUIdsErrorState(onError.toString()));
    });
  }
  // we created this method to fill a list of PM to display it in the feedsScreen.
  // and like that if ia wanna delete a user i could access his posts bounded together under a unique uId.
////////////////////////////////


  void playPauseVideo(VideoPlayerController controller) {
    if (controller.value.isPlaying) {
      controller.pause();
    } else {
      controller.play();
    }
    emit(AppPlayPauseVideoState());
  }

  void getFeedPosts() {
    feedPosts.clear();
    feedPostId.clear();
    emit(AppGetFeedPostLoadingState());
    FirebaseFirestore.instance
        .collection('posts')
        .orderBy('postDate')
        .get()
        .then((value) {
      for (var element in value.docs) {
        feedPostId.add(element.id);
        feedPosts.add(PostModel.fromJson(element.data()));
        emit(AppGetFeedPostSuccessState());
      }
    }).catchError((onError) {
      pint(onError.toString());
      emit(AppGetFeedPostErrorState(onError.toString()));
    });
  }

  void modifyPost({
    required String feedPostId,
    required String postText,
    required String postImage,
  }) {
    emit(AppModifyPostLoadingState());
    FirebaseFirestore.instance
        .collection('posts')
        .doc(feedPostId)
        .update({'postText': postText, 'postImage': postImage}).then((value) {
      emit(AppModifyPostSuccessState());
    }).catchError((onError) {
      pint(onError.toString());
      emit(AppModifyPostErrorState(onError.toString()));
    });
    /////////////////////////////
    FirebaseFirestore.instance
        .collection('posts')
        .doc(feedPostId)
        .update({'postText': postText, 'postImage': postImage}).then((value) {
      emit(AppModifyPostSuccessState());
    }).catchError((onError) {
      pint(onError.toString());
      emit(AppModifyPostErrorState(onError.toString()));
    });
  }


  void createPostInTwoPlaces({
    required String postText,
    required String postImage,
    required String postDate,
  }) {
    repeatedId = '';
    emit(AppModifyPostLoadingState());
    PostModel postModel = PostModel(
      name: loginModel!.name,
      postUid: loginModel!.uId,
      profileImage: loginModel!.profileImage,
      postDate: postDate,
      postText: postText,
      postImage: postImage,
      videoLink: '',
      postLikes: 0,
      postComments: 0,
      postShares: 0,
    );
    FirebaseFirestore.instance
        .collection('posts')
        .add(postModel.toMap())
        .then((value) {
         repeatedId = value.id;
         pint(repeatedId);
         FirebaseFirestore.instance
             .collection('users').
         doc(uId).collection('posts')
             .doc(repeatedId)
             .set(postModel.toMap());
      emit(AppCreatePostSuccessState());
    }).catchError((onError) {
      pint(onError.toString());
      emit(AppCreatePostErrorState(onError.toString()));
    });
  }

  void getVisitedUserPosts({required String uId, context}) {
    visitedUserPosts.clear();
    emit(AppGetVisitedUserPostsLoadingState());
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .collection('posts')
        .orderBy('postDate')
        .get()
        .then((value) {
      for (var element in value.docs) {
        visitedUserPosts.add(PostModel.fromJson(element.data()));
      }
      emit(AppGetVisitedUserPostsSuccessState());
    }).catchError((onError) {
      pint(onError.toString());
      emit(AppGetVisitedUserPostsErrorState(onError.toString()));
    });
  }

  void searchForUser({required String uId, context}) {
    user.clear();
    FirebaseFirestore.instance.collection('users').doc(uId).get().then((value) {
      user = value.data()!;
      pint(user['name']);
      pint(user['profileImage']);
      pint(user['bio']);
      getVisitedUserPosts(uId: uId);
      navigateTo(context, VisitedProfileScreen(user: user));
      emit(AppSearchForUserSuccessState());
    }).catchError((onError) {
      pint(onError.toString());
      emit(AppSearchForUserErrorState(onError.toString()));
    });
  }

  void getGalleryMessageImage() async {
    var pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      messageImageFile = File(pickedFile.path);

      emit(AppGetGalleryImageSuccessState());
    } else {
      pint('No Image selected');
      emit(AppGetGalleryImageErrorState());
    }
  }

  void getCameraMessageImage() async {
    var pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      messageImageFile = File(pickedFile.path);
      emit(AppGetCameraImageSuccessState());
    } else {
      pint('No Image selected');
      emit(AppGetCameraImageErrorState());
    }
  }

  void undoGetMessageImage() {
    messageImageFile = null;
    emit(AppUndoGetMessageImageSuccessState());
  }

  void senMessage({
    required String receiverId,
    required String textMessage,
    String? imageMessage,
    required String messageDateTime,
  }) {
    emit(AppSendMessageLoadingState());
    ChatsModel chatsModel = ChatsModel(
      chatPersonName: loginModel!.name,
      senderId: loginModel!.uId,
      receiverId: receiverId,
      textMessage: textMessage,
      imageMessage: imageMessage ?? '',
      messageDateTime: messageDateTime,
    );
    FirebaseFirestore.instance
        .collection('users')
        .doc(loginModel!.uId)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .add(chatsModel.toMap())
        .then((value) {
      emit(AppSendMessageSuccessState());
    }).catchError((onError) {
      pint(onError.toString());
      emit(AppSendMessageErrorState(onError.toString()));
    });
    FirebaseFirestore.instance
        .collection('users')
        .doc(receiverId)
        .collection('chats')
        .doc(loginModel!.uId)
        .collection('messages')
        .add(chatsModel.toMap())
        .then((value) {
      emit(AppSendMessageSuccessState());
    }).catchError((onError) {
      pint(onError.toString());
      emit(AppSendMessageErrorState(onError.toString()));
    });
  }

  void sendMessageWithImage({
    required String receiverId,
    required String textMessage,
    required String messageDateTime,
  }) {
    emit(AppSendMessageWithImageLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child(
            'users/${loginModel!.uId}/Chats/$receiverId/Messages/${Uri.file(messageImageFile!.path).pathSegments.last}')
        .putFile(messageImageFile!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        senMessage(
          receiverId: receiverId,
          textMessage: textMessage,
          messageDateTime: messageDateTime,
          imageMessage: value,
        );
        emit(AppSendMessageSuccessState());
      }).catchError((onError) {
        pint(onError.toString());
        emit(AppSendMessageErrorState(onError.toString()));
      });
    }).catchError((onError) {
      pint(onError.toString());
      emit(AppSendMessageWithImageErrorState(onError.toString()));
    });
  }

  void getMessages({required String receiverId}) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(loginModel!.uId)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .orderBy('messageDateTime')
        .snapshots()
        .listen((event) {
      messages.clear();
      for (var element in event.docs) {
        messages.add(ChatsModel.fromJson(element.data()));
      }
      emit(AppGetMessageSuccessState());
    });
  }

  void createStory({
    required String storyDate,
    required String storyText,
    String? storyImage,
  }) {
    emit(AppCreateStoryLoadingState());
    StoryModel storyModel = StoryModel(
      name: loginModel!.name,
      storyUid: loginModel!.uId,
      profileImage: loginModel!.profileImage,
      storyDate: storyDate,
      storyText: storyText,
      storyImage: storyImage ?? '',
    );
    FirebaseFirestore.instance
        .collection('stories')
        .add(storyModel.toMap())
        .then((value) {
      emit(AppCreateStorySuccessState());
    }).catchError((onError) {
      pint(onError.toString());
      emit(AppCreateStoryErrorState(onError.toString()));
    });
  }

  void createStoryWithImage({
    required String storyText,
    required String storyDate,
  }) {
    emit(AppCreateStoryImageLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child(
            'storiesImages/${Uri.file(storyImageFile!.path).pathSegments.last}')
        .putFile(storyImageFile!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        createStory(
            storyDate: storyDate, storyText: storyText, storyImage: value);
        emit(AppCreateStoryImageSuccessState());
      }).catchError((onError) {
        pint(onError.toString());
        emit(AppCreatePostErrorState(onError.toString()));
      });
    }).catchError((onError) {
      pint(onError.toString());
      emit(AppCreateStoryImageErrorState(onError.toString()));
    });
  }

  void getStory() {
    emit(AppGetStoryLoadingState());
    stories.clear();
    storyId.clear();
    FirebaseFirestore.instance.collection('stories').get().then((value) {
      for (var element in value.docs) {
        stories.add(StoryModel.fromJson(element.data()));
        storyId.add(element.id);
      }
      emit(AppGetStorySuccessState());
    }).catchError((onError) {
      pint(onError.toString());
      emit(AppGetStoryErrorState(onError.toString()));
    });
  }

  List<CommentModel> removeDuplicates(List<CommentModel> comments) {
    List<CommentModel> distinct;
    List<CommentModel> dummy = comments;

    for (int i = 0; i < comments.length; i++) {
      for (int j = 1; j < dummy.length; j++) {
        if (dummy[i].name == comments[j].name) {
          if (dummy[i].commentText == comments[j].commentText) {
            // dummy.removeAt(j);
          }
        }
      }
    }
    distinct = dummy;
    pint(distinct.toString());

    return distinct.map((e) => e).toSet().toList();
  }

  List<CommentReplyModel> removeDuplicatedReply(List<CommentReplyModel> reply) {
    List<CommentReplyModel> distinct;
    List<CommentReplyModel> dummy = reply;

    for (int i = 0; i < reply.length; i++) {
      for (int j = 1; j < dummy.length; j++) {
        if (dummy[i].name == reply[j].name) {
          if (dummy[i].replyText == reply[j].replyText) {
            // dummy.removeAt(j);
          }
        }
      }
    }
    distinct = dummy;
    pint(distinct.toString());

    return distinct.map((e) => e).toSet().toList();
  }

  void wannaSearch() {
    wannaSearchForUser = !wannaSearchForUser;
    emit(AppWannaSearchSuccessState());
  }

  void getUserData() {
    emit(AppGetUserDataLoadingState());
    FirebaseFirestore.instance.collection('users').doc(uId).get().then((value) {
      loginModel = LoginModel.fromJson(value.data()!);
      pint(loginModel!.name.toString());
      emit(AppGetUserDataSuccessState());
    }).catchError((onError) {
      pint(onError.toString());
      emit(AppGetUserDataErrorState(onError.toString()));
    });
  }

  getAllUsers() {
    allUsers.clear();
    emit(AppGetAllUsersDataLoadingState());
    FirebaseFirestore.instance.collection('users').get().then((value) {
      for (var element in value.docs) {
        if (element.data()['uId'] != loginModel!.uId) {
          allUsers.add(LoginModel.fromJson(element.data()));
        }
        emit(AppGetAllUsersDataSuccessState());
      }
    }).catchError((onError) {
      pint(onError.toString());
      emit(AppGetAllUsersDataErrorState(onError.toString()));
    });
  }

  void createPost(
      {required String postText,
      required String postDate,
      String? postImage,
      context}) {
    emit(AppCreatePostLoadingState());
    PostModel postModel = PostModel(
      name: loginModel!.name,
      postUid: loginModel!.uId,
      profileImage: loginModel!.profileImage,
      postDate: postDate,
      postText: postText,
      postImage: postImage ?? '',
      videoLink: '',
      postLikes: 0,
      postComments: 0,
      postShares: 0,
    );
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .collection('posts')
        .add(postModel.toMap())
        .then((value) {
      emit(AppCreatePostSuccessState());
    }).catchError((onError) {
      pint(onError.toString());
      emit(AppCreatePostErrorState(onError.toString()));
    });
  }

  createFeedPost({
    required String postText,
    required String postDate,
    String? postImage,
    context,
  }) {
    emit(AppCreatePostLoadingState());
    PostModel postModel = PostModel(
      name: loginModel!.name,
      postUid: loginModel!.uId,
      profileImage: loginModel!.profileImage,
      postDate: postDate,
      postText: postText,
      postImage: postImage ?? '',
      videoLink: '',
      postLikes: 0,
      postComments: 0,
      postShares: 0,
    );
    FirebaseFirestore.instance
        .collection('posts')
        .add(postModel.toMap())
        .then((value) {
          repeatedId = value.id;
          FirebaseFirestore.instance
              .collection('users')
              .doc(uId)
              .collection('posts').doc(repeatedId)
              .set(postModel.toMap());
          emit(AppCreatePostSuccessState());
    }).catchError((onError) {
      pint(onError.toString());
      emit(AppCreatePostErrorState(onError.toString()));
    });
  }

  void uploadPostWithImage({
    required String postText,
    required String postDate,
  }) {
    emit(AppCreatePostLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('postsImages/${Uri.file(postImageFile!.path).pathSegments.last}')
        .putFile(postImageFile!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        // createPost(postText: postText, postDate: postDate, postImage: value);
        createFeedPost(
            postText: postText, postDate: postDate, postImage: value);
        emit(AppUploadPostImageSuccessState());
      }).catchError((onError) {
        pint(onError.toString());
        emit(AppCreatePostErrorState(onError.toString()));
      });
    }).catchError((onError) {
      pint(onError.toString());
      emit(AppUploadPostImageErrorState(onError.toString()));
    });
  }

  void getPosts() {
    myPosts.clear();
    myPostId.clear();
    emit(AppGetPostLoadingState());
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .collection('posts')
        .orderBy('postDate')
        .get()
        .then((value) {
      for (var element in value.docs) {
        myPosts.add(PostModel.fromJson(element.data()));
        myPostId.add(element.id);
      }
    }).catchError((onError) {
      pint(onError.toString());
      emit(AppGetPostErrorState(onError.toString()));
    });
  }



  void getGalleryStoryImage() async {
    var pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      storyImageFile = File(pickedFile.path);

      emit(AppGetGalleryImageSuccessState());
    } else {
      pint('No Image selected');
      emit(AppGetGalleryImageErrorState());
    }
  }

  void getCameraStoryImage() async {
    var pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      storyImageFile = File(pickedFile.path);
      emit(AppGetCameraImageSuccessState());
    } else {
      pint('No Image selected');
      emit(AppGetCameraImageErrorState());
    }
  }

  void undoGetStoryImage() {
    storyImageFile = null;
    emit(AppUndoGetProfileImageSuccessState());
  }

  void getGalleryProfileImage() async {
    var pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      profileImageFile = File(pickedFile.path);

      emit(AppGetGalleryImageSuccessState());
    } else {
      pint('No Image selected');
      emit(AppGetGalleryImageErrorState());
    }
  }

  void getCameraProfileImage() async {
    var pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      profileImageFile = File(pickedFile.path);
      emit(AppGetCameraImageSuccessState());
    } else {
      pint('No Image selected');
      emit(AppGetCameraImageErrorState());
    }
  }

  void getGalleryCoverImage() async {
    var pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      coverImageFile = File(pickedFile.path);

      emit(AppGetGalleryImageSuccessState());
    } else {
      pint('No Image selected');
      emit(AppGetGalleryImageErrorState());
    }
  }

  void getCameraCoverImage() async {
    var pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      coverImageFile = File(pickedFile.path);
      emit(AppGetCameraImageSuccessState());
    } else {
      pint('No Image selected');
      emit(AppGetCameraImageErrorState());
    }
  }

  void getGalleryPostImage() async {
    var pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      postImageFile = File(pickedFile.path);

      emit(AppGetGalleryImageSuccessState());
    } else {
      pint('No Image selected');
      emit(AppGetGalleryImageErrorState());
    }
  }

  void getCameraPostImage() async {
    var pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      postImageFile = File(pickedFile.path);
      emit(AppGetCameraImageSuccessState());
    } else {
      pint('No Image selected');
      emit(AppGetCameraImageErrorState());
    }
  }

  void undoGetPostImage(value) {
    postImageFile = null;
    emit(AppUndoGetPostImageSuccessState());
  }

  void undoGetProfileImage() {
    profileImageFile = null;
    emit(AppUndoGetProfileImageSuccessState());
  }

  void undoGetCoverImage() {
    coverImageFile = null;
    emit(AppUndoGetCoverImageSuccessState());
  }

  void clearPostImagesList() {
    postImageFiles.clear();
    postImageFile = null;
    emit(AppCreatePostImageListSuccessState());
  }

  void getGalleryCommentImage() async {
    var pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      commentImageFile = File(pickedFile.path);

      emit(AppGetGalleryImageSuccessState());
    } else {
      pint('No Image selected');
      emit(AppGetGalleryImageErrorState());
    }
  }

  void getCameraCommentImage() async {
    var pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      commentImageFile = File(pickedFile.path);
      emit(AppGetCameraImageSuccessState());
    } else {
      pint('No Image selected');
      emit(AppGetCameraImageErrorState());
    }
  }

  void undoGetCommentImage(value) {
    commentImageFile = null;
    emit(AppUndoGetCommentImageSuccessState());
  }

  void getGalleryCommentReplyImage() async {
    var pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      commentReplyImageFile = File(pickedFile.path);

      emit(AppGetGalleryImageSuccessState());
    } else {
      pint('No Image selected');
      emit(AppGetGalleryImageErrorState());
    }
  }

  void getCameraCommentReplyImage() async {
    var pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      commentReplyImageFile = File(pickedFile.path);
      emit(AppGetCameraImageSuccessState());
    } else {
      pint('No Image selected');
      emit(AppGetCameraImageErrorState());
    }
  }

  void undoGetCommentReplyImage(value) {
    commentReplyImageFile = null;
    emit(AppUndoGetCommentImageSuccessState());
  }

  void updateProfileImage({
    required String name,
    required String phone,
    required String email,
    required String bio,
  }) {
    emit(AppUpdateProfileImageLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child(
            'profileImages/${Uri.file(profileImageFile!.path).pathSegments.last}')
        .putFile(profileImageFile!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        updateProfile(
          name: name,
          phone: phone,
          email: email,
          bio: bio,
          profileImage: value,
        );
      }).catchError((onError) {});
      emit(AppUpdateProfileImageSuccessState());
    }).catchError((onError) {
      pint(onError.toString());
      emit(AppUpdateProfileImageErrorState(onError.toString()));
    });
  }

  void updateProfileCover({
    required String name,
    required String phone,
    required String email,
    required String bio,
  }) {
    emit(AppUpdateCoverImageLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child(
            'coverImages/${Uri.file(coverImageFile!.path).pathSegments.last}')
        .putFile(coverImageFile!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        updateProfile(
          name: name,
          phone: phone,
          email: email,
          bio: bio,
          profileCover: value,
        );
      }).catchError((onError) {});
      emit(AppUpdateCoverImageSuccessState());
    }).catchError((onError) {
      pint(onError.toString());
      emit(AppUpdateCoverImageErrorState(onError.toString()));
    });
  }

  void updateProfile({
    required String name,
    required String phone,
    required String email,
    required String bio,
    String? profileImage,
    String? profileCover,
  }) {
    emit(AppUpdateProfileLoadingState());
    LoginModel newLoginModel = LoginModel(
        name: name,
        phone: phone,
        email: email,
        bio: bio,
        profileImage: profileImage ?? loginModel!.profileImage,
        profileCover: profileCover ?? loginModel!.profileCover,
        uId: loginModel!.uId);
    FirebaseFirestore.instance
        .collection('users')
        .doc(loginModel!.uId)
        .update(newLoginModel.toMap())
        .then((value) {
      emit(AppUpdateProfileSuccessState());
    }).catchError((onError) {
      pint(onError.toString());
      emit(AppUpdateProfileErrorState(onError.toString()));
    });
  }

  void createComment(
      {required String feedPostId,
      required String commentText,
      String? commentImage,
      required String commentDate,
      context}) {
    emit(AppCreateCommentLoadingState());

    CommentModel commentModel = CommentModel(
      name: loginModel!.name,
      profileImage: loginModel!.profileImage,
      uId: loginModel!.uId,
      commentText: commentText,
      commentImage: commentImage ?? '',
      commentDate: commentDate,
    );
    FirebaseFirestore.instance
        .collection('posts')
        .doc(feedPostId)
        .collection('comments')
        .add(commentModel.toMap())
        .then((value) {
      getComments(feedPostId: feedPostId);
      emit(AppCreateCommentSuccessState());
    }).catchError((onError) {
      pint(onError.toString());
      emit(AppCreateCommentErrorState(onError.toString()));
    });
  }

  void createCommentWithImage({
    required String feedPostId,
    required String commentText,
    required String commentDate,
  }) {
    emit(AppCreateCommentLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child(
            'commentsImages/${Uri.file(commentImageFile!.path).pathSegments.last}')
        .putFile(commentImageFile!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        createComment(
          feedPostId: feedPostId,
          commentText: commentText,
          commentDate: commentDate,
          commentImage: value,
        );
      }).catchError((onError) {
        pint(onError.toString());
        emit(AppCreateCommentErrorState(onError.toString()));
      });
      emit(AppCreateCommentSuccessState());
    }).catchError((onError) {
      pint(onError.toString());
      emit(AppCreateCommentErrorState(onError.toString()));
    });
  }

  void getComments({required String feedPostId}) {
    emit(AppGetCommentLoadingState());
    comments.clear();
    commentId.clear();
    FirebaseFirestore.instance
        .collection('posts')
        .doc(feedPostId)
        .collection('comments')
        .get()
        .then((value) {
      for (var element in value.docs) {
        comments.add(CommentModel.fromJson(element.data()));
        removeDuplicates(comments);
        commentId.add(element.id);
        newPostId = feedPostId;
        emit(AppGetCommentSuccessState());
      }
    }).catchError((onError) {
      pint(onError.toString());
      emit(AppGetCommentErrorState(onError.toString()));
    });
  }

  void createCommentReply({
    required String postId,
    required String commentId,
    replyText,
    replyDate,
    String? replyImage,
    context,
  }) {
    emit(AppCreateCommentReplyLoadingState());
    CommentReplyModel commentReplyModel = CommentReplyModel(
        name: loginModel!.name,
        profileImage: loginModel!.profileImage,
        uId: loginModel!.uId,
        replyText: replyText,
        replyImage: replyImage ?? '',
        replyDate: replyDate);
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .doc(commentId)
        .collection('reply')
        .add(commentReplyModel.toMap())
        .then((value) {
      getCommentsReply(postId: postId, commentId: commentId);
      emit(AppCreateCommentReplySuccessState());
    }).catchError((onError) {
      pint(onError.toString());
      emit(AppCreateCommentReplyErrorState(onError.toString()));
    });
  }

  void createCommentReplyWithImage({
    required String postId,
    required String commentId,
    required String commentReplyText,
    required String commentReplyDate,
  }) {
    emit(AppCreateCommentReplyLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child(
            'replyImages/${Uri.file(commentReplyImageFile!.path).pathSegments.last}')
        .putFile(commentReplyImageFile!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        createCommentReply(
          postId: postId,
          commentId: commentId,
          replyText: commentReplyText,
          replyDate: commentReplyDate,
          replyImage: value,
        );
      }).catchError((onError) {
        pint(onError.toString());
        emit(AppCreateCommentReplyErrorState(onError.toString()));
      });
      emit(AppCreateCommentReplySuccessState());
    }).catchError((onError) {
      pint(onError.toString());
      emit(AppCreateCommentReplyErrorState(onError.toString()));
    });
  }

  void getCommentsReply({
    required String postId,
    required String commentId,
  }) {
    commentsReply.clear();
    replyId.clear();

    emit(AppGetCommentReplyLoadingState());
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .doc(commentId)
        .collection('reply')
        .get()
        .then((value) {
      for (var element in value.docs) {
        commentsReply.add(CommentReplyModel.fromJson(element.data()));
        replyId.add(element.id);
      }
      newCommentId = commentId;
      emit(AppGetCommentReplySuccessState());
    }).catchError((onError) {
      pint(onError.toString());
      emit(AppGetCommentReplyErrorState(onError.toString()));
    });
  }

  ////////////////////////////////////////////
  // do store a replies collection so every body inside the post can see it .

  void storeReply({
    required String postId,
    required replyText,
    required replyDate,
    String? replyImage,
    context,
  }) {
    emit(AppStoreReplyLoadingState());
    CommentReplyModel commentReplyModel = CommentReplyModel(
        name: loginModel!.name,
        profileImage: loginModel!.profileImage,
        uId: loginModel!.uId,
        replyText: replyText,
        replyImage: replyImage ?? '',
        replyDate: replyDate);
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('reply')
        .add(commentReplyModel.toMap())
        .then((value) {
      getStoredReply(
        postId: postId,
      );
      emit(AppStoreReplySuccessState());
    }).catchError((onError) {
      pint(onError.toString());
      emit(AppStoreReplyErrorState(onError.toString()));
    });
  }

  void storeReplyWithImage({
    required String postId,
    required String commentReplyText,
    required String commentReplyDate,
  }) {
    emit(AppStoreReplyLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child(
            'replyImages/${Uri.file(commentReplyImageFile!.path).pathSegments.last}')
        .putFile(commentReplyImageFile!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        storeReply(
          postId: postId,
          replyText: commentReplyText,
          replyDate: commentReplyDate,
          replyImage: value,
        );
      }).catchError((onError) {
        pint(onError.toString());
        emit(AppStoreReplyErrorState(onError.toString()));
      });
      emit(AppStoreReplySuccessState());
    }).catchError((onError) {
      pint(onError.toString());
      emit(AppStoreReplyErrorState(onError.toString()));
    });
  }

  void getStoredReply({
    required String postId,
  }) {
    storedReply.clear();
    replyId.clear();
    emit(AppGetStoredReplyLoadingState());
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('reply')
        .get()
        .then((value) {
      for (var element in value.docs) {
        storedReply.add(CommentReplyModel.fromJson(element.data()));
        replyId.add(element.id);
      }

      emit(AppGetStoredReplySuccessState(newCommentId!));
    }).catchError((onError) {
      pint(onError.toString());
      emit(AppGetStoredReplyErrorState(onError.toString()));
    });
  }

  // void getAllReplies({
  //   required String postId,
  //   required String commentId,
  // }) {
  //   commentsReply.clear();
  //   emit(AppGetCommentReplyLoadingState());
  //   FirebaseFirestore.instance
  //       .collection('posts')
  //       .doc(postId)
  //       .collection('comments')
  //       .doc(commentId)
  //       .collection('reply')
  //       .get()
  //       .then((value) {
  //     for (var element in value.docs) {
  //       commentsReply.add(CommentReplyModel.fromJson(element.data()));
  //     }
  //     newCommentId = commentId;
  //     emit(AppGetCommentReplySuccessState(newCommentId!));
  //   }).catchError((onError) {
  //     pint(onError.toString());
  //     emit(AppGetCommentReplyErrorState(onError.toString()));
  //   });
  // }
  //////////////////////////////////

  Stream<DocumentSnapshot> likePostWithStreamBuilder({required String postId}) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .doc(loginModel!.uId)
        .snapshots();
  }

  void likeFeedPost({required String feedPostId, required bool liked}) {
    liked = !liked;
    if (liked) {
      FirebaseFirestore.instance
          .collection('posts')
          .doc(feedPostId)
          .collection('likes')
          .doc(loginModel!.uId)
          .set({'liked': true}).then((value) {
        emit(AppLikeFeedPostSuccessState());
      }).catchError((onError) {
        pint(onError.toString());
        emit(AppLikeFeedPostErrorState(onError.toString()));
      });
    } else {
      FirebaseFirestore.instance
          .collection('posts')
          .doc(feedPostId)
          .collection('likes')
          .doc(loginModel!.uId)
          .delete()
          .then((value) {
        emit(AppUnlikeFeedPostSuccessState());
      }).catchError((onError) {
        pint(onError.toString());
        emit(AppUnlikeFeedPostErrorState(onError.toString()));
      });
    }
    liked = !liked;
  }

  void likePost({required String postId, required bool liked}) {
    liked = !liked;
    if (liked) {
      likePostModel = LikePostModel(
        name: loginModel!.name,
        uId: loginModel!.uId,
        likeDate: DateTime.now().toString(),
        like: true,
      );

      FirebaseFirestore.instance
          .collection('users')
          .doc(uId)
          .collection('posts')
          .doc(postId)
          .collection('likes')
          .doc(loginModel!.uId)
          .set(likePostModel!.toMap())
          .then((value) {
        emit(AppLikePostSuccessState());
      }).catchError((onError) {
        pint(onError.toString());
        emit(AppLikePostErrorState(onError.toString()));
      });
    } else {
      FirebaseFirestore.instance
          .collection('users')
          .doc(uId)
          .collection('posts')
          .doc(postId)
          .collection('likes')
          .doc(loginModel!.uId)
          .delete()
          .then((value) {
        emit(AppUnlikePostSuccessState());
      }).catchError((onError) {
        pint(onError.toString());
        emit(AppUnlikePostErrorState(onError.toString()));
      });
    }
  }

  Future<void> signOut(context) async {
    await FirebaseAuth.instance.signOut().then((value) {
      CacheHelper.removeData(key: 'uid').then((value) {
        uId = null;
        navigate2(context, const LoginScreen());
      });

      emit(AppSignOutSuccessState());
    }).catchError((error) {
      pint(error.toString());
      emit(AppSignOutErrorState(error.toString()));
    });
  }

  int currentIndex = 0;
  double bottomSheetHeight = 350;

  List<Widget> appTitles = [
    const Text('Feeds'),
    const Text('Chats'),
    const Text('Profile'),
  ];

  void changeBottomSheetHeight() {
    if (bottomSheetHeight == 350) {
      bottomSheetHeight = 700;
    } else {
      bottomSheetHeight = 350;
    }
    emit(AppChangeBSHeightState());
  }

  void changeIndex(index) {
    currentIndex = index;
    if (index == 1) {
      getAllUsers();
    }
    if (index == 2) {
      getPosts();
    }
    emit(AppChangeBNBState());
  }

  List<BottomNavigationBarItem> items = [
    const BottomNavigationBarItem(icon: Icon(IconBroken.Home), label: 'Home'),
    const BottomNavigationBarItem(icon: Icon(IconBroken.Chat), label: 'Chats'),
    const BottomNavigationBarItem(
        icon: Icon(IconBroken.Profile), label: 'Profile')
  ];


  List<Widget> screens = [
    const FeedsScreen(),
    const ChatsScreen(),
    const ProfileScreen(),
  ];

  void endBoarding(context) {
    CacheHelper.putData('lastPage', lastPage!).then((value) {
      if (value) {
        navigate2(context, const LoginScreen());
      }
    }).catchError((onError) {});
  }

  List<BoardingModel> boarding = [
    BoardingModel(
      title: 'communicate with your friends',
      body: 'reach your friends easily and professionally ',
      image: 'assets/images/communicate.png',
    ),
    BoardingModel(
      title: 'Show your self to the world',
      body: 'Keep the world in backup with your latest updates',
      image: 'assets/images/show-yourself-poster.jpg',
    ),
    BoardingModel(
      title: 'See the latest news ',
      body: 'Stay notified with the trending news around the world',
      image: 'assets/images/unnamed.jpg',
    ),
  ];

  void updateStoryIndex({index}) {
    storyIndex = index;
    emit(AppUpdateStoryIndexSuccessState());
  }

  void swipeLeft() {
    storyIndex = storyIndex - 1;
    emit(AppSwipeLeftState());
  }

  void swipeRight() {
    storyIndex = storyIndex + 1;
    emit(AppSwipeRightState());
  }
}
