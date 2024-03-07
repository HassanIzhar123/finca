import 'package:cloud_firestore/cloud_firestore.dart';

class CollectionRefs {
  CollectionRefs._();

  final _db = FirebaseFirestore.instance;
  static final instance = CollectionRefs._();

  CollectionReference<Map<String, dynamic>> get users =>
      _db.collection('users');

  CollectionReference<Map<String, dynamic>> crops(String userId) =>
      users.doc(userId).collection('crops');

  CollectionReference<Map<String, dynamic>> farms(String userId) =>
      users.doc(userId).collection('farms');
}
