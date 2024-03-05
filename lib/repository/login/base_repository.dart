import 'package:finca/models/signup/auth_model.dart';

abstract class BaseRepository {
  Future<AuthModel?> logInUser(String email, String password);
}
