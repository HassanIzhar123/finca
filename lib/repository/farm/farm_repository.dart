import 'dart:developer';

import 'package:finca/models/farms_screen/farm_model.dart';
import 'package:finca/utils/collection_refs.dart';

class FarmRepository {
  Stream<List<FarmModel>> getAllFarms(String userId) {
    log('userId: $userId');
    return CollectionRefs.instance.users
        .doc(userId)
        .collection('farms')
        .snapshots()
        .map((event) {
      return event.docs.map((e) {
        log("event: " + e.toString());
        return FarmModel.fromJson(e.data());
      }).toList();
    });
  }
}
