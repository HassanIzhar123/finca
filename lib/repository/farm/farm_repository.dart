import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finca/models/farms_screen/farm_model.dart';
import 'package:finca/utils/collection_refs.dart';

class FarmRepository {
  Stream<List<FarmModel>> getAllFarms(String userId) {
    return FirebaseFirestore.instance.collection('users').doc(userId).collection('farms').snapshots().map((event) {
      return event.docs.map((e) {
        final data = FarmModel.fromJson(e.data());
        return data;
      }).toList();
    });
  }

  Future<bool> addNewFarm(String userId, FarmModel farm) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('farms')
        .add(farm.toJson())
        .then((value) {
      return true;
    });
  }
}
