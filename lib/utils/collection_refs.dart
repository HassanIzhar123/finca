import 'package:cloud_firestore/cloud_firestore.dart';

class CollectionRefs {
  CollectionRefs._();

  final _db = FirebaseFirestore.instance;
  static final instance = CollectionRefs._();

  CollectionReference<Map<String, dynamic>> get users => _db.collection('users');

  CollectionReference<Map<String, dynamic>> crops(String userId) => users.doc(userId).collection('crops');

  CollectionReference<Map<String, dynamic>> farms(String userId) => users.doc(userId).collection('farms');

  CollectionReference<Map<String, dynamic>> soilType() => _db.collection('SoilType');

  CollectionReference<Map<String, dynamic>> activity() => _db.collection('Activity');

  CollectionReference<Map<String, dynamic>> agriculturalCertification() => _db.collection('AgriculturalCertification');

  CollectionReference<Map<String, dynamic>> cropVarieties() => _db.collection('Variety');

  CollectionReference<Map<String, dynamic>> cropNames() => _db.collection('CropName');

  CollectionReference<Map<String, dynamic>> activities(String userId) => users.doc(userId).collection('activities');
  CollectionReference<Map<String, dynamic>> notifications(String userId) => users.doc(userId).collection('notifications');
}
