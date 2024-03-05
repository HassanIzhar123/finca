import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

@immutable
abstract class SignUpState extends Equatable {
  const SignUpState();

  @override
  List<Object> get props => [];
}

class SignUpInitial extends SignUpState {}

class SignUpLoadingState extends SignUpState {}

class SignUpSuccessState extends SignUpState {
  final bool isSignedIn;

  const SignUpSuccessState(this.isSignedIn);
}

class SignUpFailedState extends SignUpState {
  final String message;

  const SignUpFailedState(this.message);
}
