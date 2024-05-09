import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finca/models/farms_screen/farm_model.dart';
import 'package:finca/modules/activity_screen/models/activity_model.dart';
import 'package:finca/modules/farms_screen/models/crop/Crop.dart';
import 'package:finca/modules/farms_screen/models/tag.dart';
import 'package:finca/utils/collection_refs.dart';
import 'package:finca/utils/user_preferences.dart';

class FarmRepository {
  Future<List<FarmModel>> getAllFarms(String userId) async {
    final data = await FirebaseFirestore.instance.collection('users').doc(userId).collection('farms').get();
    return data.docs.map((event) {
      final data = FarmModel.fromJson(event.data());
      return data;
    }).toList();
  }

  Future<List<FarmModel>> getAllFarmsWithOutStream(String userId) async {
    final data = await FirebaseFirestore.instance.collection('users').doc(userId).collection('farms').get();
    var listOfFarms = data.docs.map((e) {
      final farm = FarmModel.fromJson(e.data());
      return farm;
    }).toList();
    for (var farm in listOfFarms) {
      farm.crop = await _getCropWithId(farm.cropId);
    }
    return listOfFarms;
  }

  static Future<Crop?> _getCropWithId(String cropId) async {
    final data = await FirebaseFirestore.instance
        .collection('users')
        .doc(UserPreferences().getUserInfo()?.uid ?? '')
        .collection('crops')
        .doc(cropId)
        .get();
    if (data.exists) {
      return Crop.fromJson(data.data()!);
    }
    return null;
  }

  bool addNewFarm(String userId, FarmModel farm) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('farms')
        .doc(farm.farmId)
        .set(farm.toJson(), SetOptions(merge: true));
    return true;
  }

  Future<List<Tag>> getSoilType() async {
    final data = await CollectionRefs.instance.soilType().get();
    return data.docs.map((e) {
      final tag = Tag.fromJson(e.data());
      return tag;
    }).toList();
  }

  Future<List<Tag>> getAgriculturalCertifications() async {
    final data = await CollectionRefs.instance.agriculturalCertification().get();
    return data.docs.map((e) {
      final tag = Tag.fromJson(e.data());
      return tag;
    }).toList();
  }

  Future<bool> addActivity(String uid, ActivityModel activity) async {
    try {
      CollectionRefs.instance.activities(uid).add(activity.toJson());
      return true;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  Stream<List<FarmModel>> getAllFarmsStream(String uid) {
    return CollectionRefs.instance.farms(uid).snapshots().map((event) {
      return event.docs.map((e) {
        final farm = FarmModel.fromJson(e.data());
        return farm;
      }).toList();
    });
  }
}
