import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finca/models/signup/auth_model.dart';
import 'package:finca/repository/LogIn/LogIn_repository.dart';
import 'package:finca/utils/app_exception.dart';
import 'package:finca/utils/collection_refs.dart';
import 'package:finca/utils/firebase_error_code_handler.dart';
import 'package:finca/utils/user_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'login_state.dart';

class LogInCubit extends Cubit<LogInState> {
  LogInCubit() : super(LogInInitial());
  final _fireStoreService = LogInRepository();

  void logInUser(String email, String password) async {
    try {
      emit(LogInLoadingState());
      AppException? isThereException = _signInVerification(email, password);
      if (isThereException == null) {
        AuthModel? authModel =
            await _fireStoreService.logInUser(email, password);
        log("authMoelcheck: ${authModel!.toJson()}");
        UserPreferences().setUserInfo(authModel);
        emit(LogInSuccessState(authModel));
      } else {
        emit(LogInFailedState(isThereException.message));
      }
    } on AppException catch (e) {
      log("e: $e");
      emit(LogInFailedState(e.message.toString()));
    }
  }

  AppException? _signInVerification(String email, String password) {
    if (email.isEmpty) {
      return const AppException(
          message: 'Email cannot be empty', title: 'LogIn Failed');
    }
    if (!_validateEmail(email)) {
      return const AppException(
          message: 'Invalid email', title: 'LogIn Failed');
    }
    if (password.isEmpty) {
      return const AppException(
          message: 'Password cannot be empty', title: 'LogIn Failed');
    }
    return null;
  }

  bool _validateEmail(String value) {
    String pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
    RegExp regex = RegExp(pattern);
    return regex.hasMatch(value);
  }

  Future<dynamic> logInWithGoogle() async {
    emit(GoogleLogInLoadingState());
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      final credentials = await FirebaseAuth.instance.signInWithCredential(credential);
      if (credentials.user == null) {
        emit(const GoogleLogInFailedState('Failed to sign in with google'));
        return;
      } else {
        final uid = credentials.user!.uid;
        final ref = CollectionRefs.instance.users;
        final user = await ref.where('uid', isEqualTo: uid).get();
        log('uid: ${user.docs.isNotEmpty}');
        if (user.docs.isNotEmpty) {
          final userDoc = user.docs.first;
          final userMap = userDoc.data();
          final AuthModel userAuth = AuthModel.fromJson(userMap);
          UserPreferences().setUserInfo(userAuth);
          emit(const GoogleLogInSuccessState(true));
          return;
        } else {
          final AuthModel signUpModel = AuthModel(
              name: credentials.user!.displayName ?? '',
              email: credentials.user!.email ?? '',
              uid: credentials.user!.uid,
              password: '',
              isGoogleSignedIn: true);
          UserPreferences().setUserInfo(signUpModel);
          await ref.doc(uid).set(signUpModel.toJson(), SetOptions(merge: true));
          emit(const GoogleLogInSuccessState(true));
          return;
        }
      }
    } on FirebaseAuthException catch (e) {
      log('Error: ${e.code} - ${e.message}');
      final appException = AppException(
        title: 'sign in Failed',
        message: FirebaseErrorCodeHandler.getMessage(
          FirebaseErrorCodeHandler.mapErrorCode(e.code),
        ),
      );
      emit(GoogleLogInFailedState(appException.message));
    } on Exception catch (e) {
      log('loginError: $e');
      emit(const GoogleLogInFailedState('Failed to sign in with google'));
    }
  }
}
