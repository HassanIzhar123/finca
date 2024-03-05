import 'dart:developer';
import 'package:finca/models/signup/auth_model.dart';
import 'package:finca/repository/signup/signup_repository.dart';
import 'package:finca/utils/app_exception.dart';
import 'package:finca/utils/global_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
      emit(SignUpFailedState(e.toString()));
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
}
