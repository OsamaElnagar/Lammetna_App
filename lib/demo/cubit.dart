import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/demo/states.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:social_app/models/postModel.dart';
import 'package:social_app/shared/components/components.dart';

class DemoCubit extends Cubit<DemoStates> {
  DemoCubit(DemoStates initialState) : super(DemoInitStates());

  static DemoCubit get(context) => BlocProvider.of(context);

  String videoLink = '';
  List<PostModel> feedPostsWithVideo = [];
  PostModel? postModel ;
  void getVideo() {
    FirebaseFirestore.instance
        .collection('posts')
        .doc('Yp5UbrTv18CxY64egYrh')
        .get()
        .then((value) {
          videoLink = value.data().toString();
          pint(videoLink);
          emit(DemoGetVideoSuccessStates());
    })
        .catchError((onError) {
          pint(onError.toString());
          emit(DemoGetVideoErrorStates(onError.toString()));
    });
  }

  getPostDemo()
  {
    feedPostsWithVideo.clear();
    FirebaseFirestore.instance.collection('posts')
        .doc('EKD32jswIGnRDyeoEqcr')
        .get()
        .then((value) {
          feedPostsWithVideo.add(PostModel.fromJson(value.data()!));
          emit(DemoGetFeedPostSuccessState());
          postModel = feedPostsWithVideo[0];
          pint(postModel!.name.toString());
          pint(postModel!.videoLink.toString());
    }).catchError((onError){
          pint(onError.toString());
          emit(DemoGetFeedPostErrorState(onError.toString()));
    });
  }

}
