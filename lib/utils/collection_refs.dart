import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

part 'collection_constants.dart';

class CollectionRefs {
  CollectionRefs._();

  final _db = FirebaseFirestore.instance;
  static final instance = CollectionRefs._();

  CollectionReference<Map<String, dynamic>> get users => _db.collection(_users);
}
