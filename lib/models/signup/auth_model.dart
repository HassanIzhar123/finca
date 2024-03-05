class AuthModel {
  String email;
  String password;
  String name;
  String? _uid;

  AuthModel({
    required this.email,
    required this.password,
    required this.name,
  });

  String get uid => _uid!;

  set uid(String value) {
    _uid = value;
  }

  Map<String, dynamic> toJson() {
    return {
      "email": email,
      "password": password,
      "name": name,
      "uid": _uid,
    };
  }

  static fromJson(Map<String, dynamic> userMap) {
    return AuthModel(
      email: userMap['email'],
      password: userMap['password'],
      name: userMap['name'],
    );
  }
}
