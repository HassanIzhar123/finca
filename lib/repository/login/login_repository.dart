import 'package:finca/models/signup/auth_model.dart';
import 'package:finca/services/base_auth_service.dart';
import 'package:finca/utils/app_exception.dart';
import 'package:finca/utils/collection_refs.dart';
import 'package:finca/utils/user_preferences.dart';
import 'package:get_storage/get_storage.dart';

import 'base_repository.dart';

class LogInRepository extends BaseRepository {
  final _authService = AuthService();

  @override
  Future<AuthModel?> logInUser(String email, String password) async {
    try {
      final userCredential = await _authService.signInWithEmailAndPassword(email.trim(), password);
      String uid = userCredential.uid;
      if (uid != null) {
        final ref = CollectionRefs.instance.users;
        final user = await ref.where('email', isEqualTo: email.trim()).get();
        if (user.docs.isNotEmpty) {
          final userDoc = user.docs.first;
          final userMap = userDoc.data();
          final AuthModel userAuth = AuthModel.fromJson(userMap);
          return userAuth;
        }
      } else {
        return null;
      }
    } on AppException {
      rethrow;
    }
    return null;
  }
}
