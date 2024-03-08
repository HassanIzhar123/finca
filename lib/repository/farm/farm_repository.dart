import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finca/models/farms_screen/farm_model.dart';
import 'package:finca/utils/collection_refs.dart';

class FarmRepository {
  Stream<List<FarmModel>> getAllFarms(String userId) {
    log('userId: $userId');
    return FirebaseFirestore.instance.collection('users').doc(userId).collection('farms').snapshots().map((event) {
      return event.docs.map((e) {
        final data = FarmModel.fromJson(e.data());
        log("event: " + data.toJson().toString());
        return data;
      }).toList();
    });
  }
}
