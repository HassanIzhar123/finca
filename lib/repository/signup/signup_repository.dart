import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finca/models/signup/auth_model.dart';
import 'package:finca/services/base_auth_service.dart';
import 'package:finca/utils/app_exception.dart';
import 'package:finca/utils/collection_refs.dart';
import 'package:finca/utils/user_preferences.dart';
import 'package:get_storage/get_storage.dart';

import 'base_repository.dart';

class SignUpRepository extends BaseRepository {
  final _authService = AuthService();

  @override
  Future<String?> signUpUser(AuthModel signUpModel) async {
    try {
      final userCredential = await _authService.createUserWithEmailAndPassword(signUpModel.email, signUpModel.password);
      String uid = userCredential.uid;
      final ref = CollectionRefs.instance.users;
      signUpModel.uid = uid;
      UserPreferences().setUserInfo(signUpModel);
      ref.doc(uid).set(signUpModel.toJson(), SetOptions(merge: true));
      return uid;
    } on AppException catch (e) {
      rethrow;
    }
  }
}
