import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../constants.dart';
import '../models/user_model.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitialState());

  static LoginCubit get(context) => BlocProvider.of(context);

  bool isPasswordShown = false;
  bool isLogin = false;
  late UserData user;
  final db = FirebaseFirestore.instance;

  void toggleCase() {
    isLogin = !isLogin;
    emit(ToggleCase());
  }

  void changeVisibility() {
    isPasswordShown = !isPasswordShown;
    emit(ChangeVisibilityState());
  }

  void loginOrRegister({
    String? name,
    required String email,
    String? phone,
    required String password,
    required String type,
  }) async {
    emit(LoginLoadingState());
    try {
      late final UserCredential credential;
      if (type == 'login') {
        credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        final db = FirebaseFirestore.instance;
        await db.collection('users').doc(credential.user!.uid).get().then(
          (DocumentSnapshot doc) {
            final data = doc.data() as Map<String, dynamic>;
            log(data.toString());
            // data = {uid: Ocqm6QIFsNctCrRtD2SMlBoRpOa2, image: null, phone: 12345678901, name: hassan, email: u@gmail.com}
            user = UserData.fromJson(data);
          },
          onError: (e) => log('Error getting document: $e'),
        );
        appToken = credential.user!.uid;
        emit(LoginSuccessState(credential.user!));
      } else {
        credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        user = UserData(
          name: name!,
          email: email,
          phone: phone!,
          uid: credential.user!.uid,
        );
        appToken = credential.user!.uid;
        createUser(name: name, email: email, phone: phone);
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage = '';
      if (e.code == 'weak-password') {
        errorMessage = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        errorMessage = 'The account already exists for that email.';
      } else if (e.code == 'user-not-found') {
        errorMessage = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Wrong password provided for that user.';
      } else {
        errorMessage = e.code;
      }
      emit(LoginFirebaseAuthExceptionState(errorMessage));
    } catch (e) {
      emit(LoginErrorState(e.toString()));
      rethrow;
    }
  }

  void createUser({
    required String name,
    required String email,
    String? phone,
  }) {
    db.collection('users').doc(user.uid).set(user.toJson()).then((value) {
      log('User created');
      emit(CreateUserSuccessState(user));
    }).catchError((e) {
      log('Error adding document: $e');
      emit(CreateUserErrorState(e.toString()));
    });
  }
}
