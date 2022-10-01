import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class TryStates {}

class TryInitState extends TryStates {}
class TryUploadMediaSuccessState extends TryStates {}
class TryUploadMediaErrorState extends TryStates {
  final String error;
  TryUploadMediaErrorState(this.error);
}


///////////////////////////////////// cubit:

class TryCubit extends Cubit<TryStates> {
  TryCubit(TryStates initialState) : super(initialState);

  static TryCubit get(context) => BlocProvider.of(context);

  void uploadMedia() {
    FirebaseFirestore.instance
        .collection('try')
        .add(
      {

      }
    )
        .then((value) {
          emit(TryUploadMediaSuccessState());
    })
        .catchError((e) {
          emit(TryUploadMediaErrorState(e));
    });
  }
}
