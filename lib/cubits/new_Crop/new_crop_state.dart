import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:finca/modules/farms_screen/models/crop/Crop.dart';
import 'package:finca/modules/farms_screen/models/tag.dart';
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

  const NewCropSuccessState(
    this.isAdded,
  );
}

class NewCropFailedState extends NewCropState {
  final String message;

  const NewCropFailedState(this.message);
}

class AllCropLoadingState extends NewCropState {}

class AllCropSuccessState extends NewCropState {
  final Stream<QuerySnapshot<Map<String, dynamic>>> cropStream;

  const AllCropSuccessState(
    this.cropStream,
  );
}

class AllCropFailedState extends NewCropState {
  final String message;

  const AllCropFailedState(this.message);
}

class InitialCropData extends NewCropState {}

class UpdateCropLoadingState extends NewCropState {}

class UpdateCropSuccessState extends NewCropState {
  final bool isUpdated;

  const UpdateCropSuccessState(this.isUpdated);
}

class UpdateCropFailedState extends NewCropState {
  final String message;

  const UpdateCropFailedState(this.message);
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

class VarietiesLoadingState extends NewCropState {}

class VarietiesSuccessState extends NewCropState {
  final List<String> varieties;

  const VarietiesSuccessState(this.varieties);
}

class VarietiesFailedState extends NewCropState {
  final String message;

  const VarietiesFailedState(this.message);
}

class CropNamesLoadingState extends NewCropState {}

class CropNamesSuccessState extends NewCropState {
  final List<Tag> cropNames;

  const CropNamesSuccessState(this.cropNames);
}

class CropNamesFailedState extends NewCropState {
  final String message;

  const CropNamesFailedState(this.message);
}
