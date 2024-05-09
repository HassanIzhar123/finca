import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finca/models/signup/auth_model.dart';
import 'package:finca/repository/signup/signup_repository.dart';
import 'package:finca/utils/app_exception.dart';
import 'package:finca/utils/collection_refs.dart';
import 'package:finca/utils/firebase_error_code_handler.dart';
import 'package:finca/utils/global_ui.dart';
import 'package:finca/utils/user_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'signup_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit() : super(SignUpInitial());
  final _fireStoreService = SignUpRepository();

  void signUpUser(String name, String email, String password, String rePassword, bool isRegistered) async {
    try {
      AppException? isThereException = _signUnVerification(name, email, password, rePassword, isRegistered);
      if (isThereException == null) {
        emit(SignUpLoadingState());
        AuthModel signUpModel = AuthModel(name: name, email: email.trim(), password: password);
        String? uid = await _fireStoreService.signUpUser(signUpModel);
        if (uid != null) {
          emit(const SignUpSuccessState(true));
        } else {
          emit(const SignUpFailedState('Failed to sign up'));
        }
      } else {
        emit(SignUpFailedState(isThereException.message));
      }
    } on AppException catch (e) {
      log("e: $e");
      emit(SignUpFailedState(e.message.toString()));
    }
  }

  AppException? _signUnVerification(String name, String email, String password, String rePassword, isRegistered) {
    if (name.isEmpty) {
      GlobalUI.showSnackBar('Name cannot be empty');
      return const AppException(message: 'Name cannot be empty', title: 'Sign Up Failed');
    }
    if (email.isEmpty) {
      return const AppException(message: 'Email cannot be empty', title: 'Sign Up Failed');
    }
    if (!_validateEmail(email)) {
      return const AppException(message: 'Invalid email', title: 'Sign Up Failed');
    }
    if (password.isEmpty) {
      return const AppException(message: 'Password cannot be empty', title: 'Sign Up Failed');
    }
    if (rePassword.isEmpty) {
      return const AppException(message: 'Re-enter password cannot be empty', title: 'Sign Up Failed');
    }
    if (password != rePassword) {
      return const AppException(message: 'Password does not match', title: 'Sign Up Failed');
    }
    if (!isRegistered) {
      return const AppException(message: 'Please accept the terms and conditions', title: 'Sign Up Failed');
    }
    return null;
  }

  bool _validateEmail(String value) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = RegExp(pattern);
    return regex.hasMatch(value);
  }

  Future<dynamic> signUpWithGoogle() async {
    emit(GoogleSignUpLoadingState());
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      final credentials = await FirebaseAuth.instance.signInWithCredential(credential);
      if (credentials.user == null) {
        emit(const GoogleSignUpFailedState('Failed to sign in with google'));
        return;
      } else {
        final uid = credentials.user!.uid;
        final ref = CollectionRefs.instance.users;
        final user = await ref.where('uid', isEqualTo: uid).get();
        if (user.docs.isNotEmpty) {
          final userDoc = user.docs.first;
          final userMap = userDoc.data();
          final AuthModel userAuth = AuthModel.fromJson(userMap);
          UserPreferences().setUserInfo(userAuth);
          emit(const GoogleSignUpSuccessState(true));
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
          emit(const GoogleSignUpSuccessState(true));
          return;
        }
      }
    } on FirebaseAuthException catch (e) {
      log('Error: ${e.code} - ${e.message}');
      final appException = AppException(
        title: 'Sign Up Failed',
        message: FirebaseErrorCodeHandler.getMessage(
          FirebaseErrorCodeHandler.mapErrorCode(e.code),
        ),
      );
      emit(GoogleSignUpFailedState(appException.message));
    } on Exception catch (e) {
      log('Signuperror: $e');
      emit(const GoogleSignUpFailedState('Failed to sign in with google'));
    }
  }
}
