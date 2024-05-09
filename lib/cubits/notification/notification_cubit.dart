import 'dart:developer';

import 'package:finca/cubits/notification/notification_state.dart';
import 'package:finca/repository/notification/notification_Repository.dart';
import 'package:finca/utils/user_preferences.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationCubit extends Cubit<NotificationState> {
  final NotificationRepository notificationRepository = NotificationRepository();

  NotificationCubit() : super(NotificationInitial());

  void getAllNotification() async {
    try {
      emit(NotificationLoadingState());
      if (UserPreferences().getUserInfo()?.uid == null) {
        emit(const NotificationFailedState('User not found'));
        return;
      }
      emit(NotificationSuccessState(
          await notificationRepository.getNotifications(UserPreferences().getUserInfo()?.uid ?? '')));
    } catch (e,stack) {
      log(stack.toString());
      emit(NotificationFailedState(e.toString()));
    }
  }
}
