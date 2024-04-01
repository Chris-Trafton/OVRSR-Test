class UserProfile {
  String id = '';
  String _userName = '';
  String _email = '';
  String _password = '';

  UserProfile(
    this._userName,
    this._email,
    this._password,
  );

  UserProfile.empty() {
    _userName = '';
    _email = '';
    _password = '';
  }

  UserProfile.fromJsonDbObject(
      Map<String, dynamic> data, String fbAuthenticatedEmail) {
    _userName = data['userName'] ?? '';
    _email = fbAuthenticatedEmail;
    _password = data['password'] ?? '';
  }

  set userName(String value) {
    _userName = value;
  }

  set email(String value) {
    _email = value;
  }

  set password(String value) {
    _password = value;
  }

  String get userName => _userName;
  String get email => _email;
  String get password => _password;

  bool isMissingKeyData() {
    return (email.isEmpty || password.isEmpty);
  }

  Map<String, dynamic> toJsonForDb() {
    // Create empty map
    Map<String, dynamic> jsonObject = {};

    // Add all fields to the json map
    jsonObject['userName'] = userName;
    jsonObject['email'] = email;
    jsonObject['password'] = password;

    return jsonObject;
  }
}
