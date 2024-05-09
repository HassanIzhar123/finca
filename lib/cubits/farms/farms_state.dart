import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:finca/models/farms_screen/farm_model.dart';
import 'package:finca/modules/farms_screen/models/tag.dart';
import 'package:flutter/cupertino.dart';

@immutable
abstract class FarmsState extends Equatable {
  const FarmsState();

  @override
  List<Object> get props => [];
}

class FarmsInitial extends FarmsState {}

class FarmsLoadingState extends FarmsState {}

class FarmsSuccessState extends FarmsState {
  final Stream<List<FarmModel>> farmsStream;
  final Future<List<FarmModel>> farms;

  const FarmsSuccessState(this.farmsStream, this.farms);
}

class FarmsFutureSuccessState extends FarmsState {
  final List<FarmModel> farms;

  const FarmsFutureSuccessState(this.farms);
}

class FarmsFailedState extends FarmsState {
  final String message;

  const FarmsFailedState(this.message);
}

class AddFarmsLoadingState extends FarmsState {}

class AddFarmsSuccessState extends FarmsState {
  final bool isAdded;

  const AddFarmsSuccessState(this.isAdded);
}

class AddFarmsFailedState extends FarmsState {
  final String message;

  const AddFarmsFailedState(this.message);
}

class UpdateFarmsLoadingState extends FarmsState {}

class UpdateFarmsSuccessState extends FarmsState {
  final bool isUpdated;

  const UpdateFarmsSuccessState(this.isUpdated);
}

class UpdateFarmsFailedState extends FarmsState {
  final String message;

  const UpdateFarmsFailedState(this.message);
}

class SoilLoadingState extends FarmsState {}

class SoilSuccessState extends FarmsState {
  final List<Tag> soilTypes;

  const SoilSuccessState(this.soilTypes);
}

class SoilFailedState extends FarmsState {
  final String message;

  const SoilFailedState(this.message);
}

class AgriculturalCertificationLoadingState extends FarmsState {}

class AgriculturalCertificationSuccessState extends FarmsState {
  final List<Tag> soilTypes;

  const AgriculturalCertificationSuccessState(this.soilTypes);
}

class AgriculturalCertificationFailedState extends FarmsState {
  final String message;

  const AgriculturalCertificationFailedState(this.message);
}

class AddActivityLoadingState extends FarmsState {}

class AddActivitySuccessState extends FarmsState {
  final bool isAdded;

  const AddActivitySuccessState(this.isAdded);
}

class AddActivityFailedState extends FarmsState {
  final String message;

  const AddActivityFailedState(this.message);
}
