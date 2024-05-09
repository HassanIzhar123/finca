import 'package:equatable/equatable.dart';
import 'package:finca/models/notification/notification_model.dart';
import 'package:flutter/material.dart';

@immutable
abstract class NotificationState extends Equatable {
  const NotificationState();

  @override
  List<Object> get props => [];
}

class NotificationInitial extends NotificationState {}

class NotificationLoadingState extends NotificationState {}

class NotificationSuccessState extends NotificationState {
  final List<NotificationModel> notifications;

  const NotificationSuccessState(this.notifications);
}

class NotificationFailedState extends NotificationState {
  final String message;

  const NotificationFailedState(this.message);
}
