import 'package:finca/models/signup/auth_model.dart';

abstract class BaseRepository {
  Future<String?> signUpUser(AuthModel signUpModel);
}
