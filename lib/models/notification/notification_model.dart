import 'dart:developer';

class NotificationModel {
  String notificationTitle;
  String notificationBody;
  DateTime createdAt;

  NotificationModel(this.notificationTitle, this.notificationBody, this.createdAt);

  Map<String, dynamic> toJson() {
    return {
      "notificationTitle": notificationTitle,
      "notificationBody": notificationBody,
      "createdAt": createdAt,
    };
  }

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      json['notificationTitle'],
      json['notificationBody'],
      DateTime.fromMillisecondsSinceEpoch(json['createdAt'].millisecondsSinceEpoch),
    );
  }
}
