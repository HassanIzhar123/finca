import 'dart:developer';
import 'package:finca/models/signup/auth_model.dart';
import 'package:finca/repository/LogIn/LogIn_repository.dart';
import 'package:finca/utils/app_exception.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'login_state.dart';

class LogInCubit extends Cubit<LogInState> {
  LogInCubit() : super(LogInInitial());
  final _fireStoreService = LogInRepository();

  void logInUser(String email, String password) async {
    try {
      emit(LogInLoadingState());
      AppException? isThereException = _signInVerification(email, password);
      if (isThereException == null) {
        AuthModel? authModel = await _fireStoreService.logInUser(email, password);
        emit(LogInSuccessState(authModel));
      } else {
        emit(LogInFailedState(isThereException.message));
      }
    } on AppException catch (e) {
      log("e: $e");
      emit(LogInFailedState(e.toString()));
    }
  }

  AppException? _signInVerification(String email, String password) {
    if (email.isEmpty) {
      return const AppException(message: 'Email cannot be empty', title: 'LogIn Failed');
    }
    if (!_validateEmail(email)) {
      return const AppException(message: 'Invalid email', title: 'LogIn Failed');
    }
    if (password.isEmpty) {
      return const AppException(message: 'Password cannot be empty', title: 'LogIn Failed');
    }
    return null;
  }

  bool _validateEmail(String value) {
    String pattern =
        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
    RegExp regex = RegExp(pattern);
    return regex.hasMatch(value);
  }
}
