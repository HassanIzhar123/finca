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
    await Future.delayed(const Duration(milliseconds: 1));
    emit(FarmsLoadingState());
    try {
      if (UserPreferences().getUserInfo()?.uid == null) {
        emit(const FarmsFailedState('User not found'));
        return;
      }
      final farmStream = await _farmRepository.getAllFarms(UserPreferences().getUserInfo()?.uid ?? '');
      emit(FarmsSuccessState(farmStream));
    } catch (e) {
      log(e.toString());
      emit(FarmsFailedState(e.toString()));
    }
  }

  void getAllActivities() async {
    await Future.delayed(const Duration(milliseconds: 1));
    emit(ActivityLoadingState());
    try {
      final activities = await _activityRepository.getAllActivities();
      emit(ActivitySuccessState(activities));
    } catch (e) {
      log(e.toString());
      emit(ActivityFailedState(e.toString()));
    }
  }

  Future<void> getActivities(String farm, DateTime focusedDay) async {
    emit(ActivityDateLoadingState());
    try {
      final activities = _activityRepository.getActivities(farm, focusedDay);
      emit(ActivityDateSuccessState(activities));
    } catch (e,stacktrace) {
      log(e.toString());
      emit(ActivityDateFailedState(e.toString()));
    }
  }
}
