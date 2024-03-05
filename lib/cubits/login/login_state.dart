import 'package:equatable/equatable.dart';
import 'package:finca/models/signup/auth_model.dart';
import 'package:flutter/cupertino.dart';

@immutable
abstract class LogInState extends Equatable {
  const LogInState();

  @override
  List<Object> get props => [];
}

class LogInInitial extends LogInState {}

class LogInLoadingState extends LogInState {}

class LogInSuccessState extends LogInState {
  final AuthModel? authModel;

  const LogInSuccessState(this.authModel);
}

class LogInFailedState extends LogInState {
  final String message;

  const LogInFailedState(this.message);
}
