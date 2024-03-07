import 'dart:developer';

import 'package:finca/cubits/farms/farms_state.dart';
import 'package:finca/repository/farm/farm_repository.dart';
import 'package:finca/utils/user_preferences.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FarmCubit extends Cubit<FarmsState> {
  final FarmRepository _farmRepository = FarmRepository();

  FarmCubit() : super(FarmsInitial());

  void getAllFarms() {
    emit(FarmsLoadingState());
    try {
      if (UserPreferences().getUserInfo()?.uid == null) {
        emit(const FarmsFailedState('User not found'));
        return;
      }
      log("userId: ${UserPreferences().getUserInfo()?.uid}");
      final farmStream = _farmRepository
          .getAllFarms(UserPreferences().getUserInfo()?.uid ?? '');
      emit(FarmsSuccessState(farmStream));
    } catch (e) {
      emit(FarmsFailedState(e.toString()));
    }
  }
}
