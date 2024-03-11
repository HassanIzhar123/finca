import 'package:equatable/equatable.dart';
import 'package:finca/models/farms_screen/farm_model.dart';
import 'package:finca/modules/activity_screen/models/activity_model.dart';
import 'package:flutter/cupertino.dart';

@immutable
abstract class ActivityState extends Equatable {
  const ActivityState();

  @override
  List<Object> get props => [];
}

class ActivityInitial extends ActivityState {}

class ActivityLoadingState extends ActivityState {}

class ActivitySuccessState extends ActivityState {
  final Stream<List<ActivityModel>> activity;

  const ActivitySuccessState(this.activity);
}

class ActivityFailedState extends ActivityState {
  final String message;

  const ActivityFailedState(this.message);
}

class AddActivityLoadingState extends ActivityState {}

class AddActivitySuccessState extends ActivityState {
  final bool isAdded;

  const AddActivitySuccessState(this.isAdded);
}

class AddActivityFailedState extends ActivityState {
  final String message;

  const AddActivityFailedState(this.message);
}

class FarmsLoadingState extends ActivityState {}

class FarmsSuccessState extends ActivityState {
  final Stream<List<FarmModel>> farms;

  const FarmsSuccessState(this.farms);
}

class FarmsFailedState extends ActivityState {
  final String message;

  const FarmsFailedState(this.message);
}
