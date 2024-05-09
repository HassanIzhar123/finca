class AuthModel {
  String email;
  String password;
  String name;
  String? uid;
  bool isGoogleSignedIn;

  AuthModel({
    required this.email,
    required this.password,
    required this.name,
    this.uid,
    this.isGoogleSignedIn = false,
  });

  // String get uid => _uid!;

  set setUid(String value) {
    uid = value;
  }

  Map<String, dynamic> toJson() {
    return {
      "email": email,
      "password": password,
      "name": name,
      "uid": uid,
      "isGoogleSignedIn": isGoogleSignedIn,
    };
  }

  @override
  String toString() {
    return 'AuthModel{email: $email, password: $password, name: $name, _uid: $uid}';
  }

  static fromJson(Map<String, dynamic> userMap) {
    return AuthModel(
      email: userMap['email'],
      password: userMap['password'],
      name: userMap['name'],
      uid: userMap['uid'],
      isGoogleSignedIn: userMap['isGoogleSignedIn'] ?? false,
    );
  }
}
