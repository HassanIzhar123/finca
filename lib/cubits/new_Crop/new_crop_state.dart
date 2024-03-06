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
  final Stream cropStream;

  const NewCropSuccessState(
    this.isAdded,
    this.cropStream,
  );
}

class NewCropFailedState extends NewCropState {
  final String message;

  const NewCropFailedState(this.message);
}

class DeleteCropLoadingState extends NewCropState {}

class DeleteCropSuccessState extends NewCropState {
  final bool isAdded;

  const DeleteCropSuccessState(this.isAdded);
}

class DeleteCropFailedState extends NewCropState {
  final String message;

  const DeleteCropFailedState(this.message);
}
