import 'dart:developer';

import 'package:finca/cubits/activity/activity_state.dart';
import 'package:finca/repository/activity/activity_repository.dart';
import 'package:finca/repository/farm/farm_repository.dart';
import 'package:finca/utils/user_preferences.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ActivityCubit extends Cubit<ActivityState> {
  final FarmRepository _farmRepository = FarmRepository();
  final ActivityRepository _activityRepository = ActivityRepository();

  ActivityCubit() : super(ActivityInitial());

  void getAllFarms() async {
    await Future.delayed(const Duration(seconds: 1));
    emit(FarmsLoadingState());
    try {
      if (UserPreferences().getUserInfo()?.uid == null) {
        emit(const FarmsFailedState('User not found'));
        return;
      }
      // log("userId: ${UserPreferences().getUserInfo()?.uid}");
      final farmStream = _farmRepository.getAllFarms(UserPreferences().getUserInfo()?.uid ?? '');
      emit(FarmsSuccessState(farmStream));
    } catch (e) {
      log(e.toString());
      emit(FarmsFailedState(e.toString()));
    }
  }
}
