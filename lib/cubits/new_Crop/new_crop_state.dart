import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

@immutable
abstract class NewCropState extends Equatable {
  const NewCropState();

  @override
  List<Object> get props => [];
}

class NewCropInitial extends NewCropState {}

class NewCropLoadingState extends NewCropState {}

class NewCropSuccessState extends NewCropState {
  final bool isAdded;

  const NewCropSuccessState(this.isAdded);
}

class NewCropFailedState extends NewCropState {
  final String message;

  const NewCropFailedState(this.message);
}
