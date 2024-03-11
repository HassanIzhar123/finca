import 'package:equatable/equatable.dart';
import 'package:finca/models/farms_screen/farm_model.dart';
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
  final Stream<List<FarmModel>> farms;

  const FarmsSuccessState(this.farms);
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
