import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finca/modules/farms_screen/models/crop/Crop.dart';
import 'package:finca/utils/app_exception.dart';
import 'package:finca/utils/collection_refs.dart';

class NewCropRepository {
  Future<void> addNewCrop(Crop crop, String uid) async {
    try {
      final ref = CollectionRefs.instance.users.doc(uid).collection('crops');
      String docId = ref.doc().id;
      crop.cropId = docId;
      ref.doc(docId).set(crop.toJson(), SetOptions(merge: true));
    } catch (e) {
      throw AppException(
          title: 'Failed to add new crop', message: e.toString());
    }
  }
}
