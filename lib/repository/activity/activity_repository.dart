import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finca/modules/activity_screen/models/activity_model.dart';
import 'package:finca/modules/farms_screen/models/tag.dart';
import 'package:finca/utils/collection_refs.dart';
import 'package:finca/utils/user_preferences.dart';

class ActivityRepository {
  Future<List<Tag>> getAllActivities() {
    return CollectionRefs.instance.activity().get().then((value) {
      final List<Tag> activities = [];
      for (final activity in value.docs) {
        activities.add(Tag.fromJson(activity.data()));
      }
      return activities;
    });
  }

  Stream<List<ActivityModel>> getActivities(String farm, DateTime queryDateTime) {
    DateTime startOfMonth = DateTime(queryDateTime.year, queryDateTime.month, 1);
    DateTime endOfMonth = DateTime(queryDateTime.year, queryDateTime.month + 1, 1);
    log('datesCheck: $startOfMonth, $endOfMonth $farm ');
    final data = FirebaseFirestore.instance
        .collection('users')
        .doc(UserPreferences().getUserInfo()?.uid ?? '')
        .collection('activities')
        .where('farmName', isEqualTo: farm)
        .where('startDate', isGreaterThanOrEqualTo: startOfMonth)
        .where('startDate', isLessThanOrEqualTo: endOfMonth)
        .snapshots()
        .map((event) {
      return event.docs.map((element) {
        return ActivityModel.fromMap(element.data());
      }).toList();
    });
    return data;
  }

  Stream<List<ActivityModel>> getAllActivitiesStream() {
    return CollectionRefs.instance.activities(UserPreferences().getUserInfo()?.uid ?? '').snapshots().map((event) {
      final List<ActivityModel> activities = [];
      for (final activity in event.docs) {
        activities.add(ActivityModel.fromMap(activity.data() as Map<String, dynamic>));
      }
      return activities;
    });
  }
}
