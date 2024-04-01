import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ovrsr/db_helpers/firebase/db_user_profile.dart';
import 'package:ovrsr/models/user_profile.dart';

class UserProfileProvider extends ChangeNotifier {
  UserProfile _userProfile = UserProfile.empty();
  bool _dataLoaded = false;

  bool get dataLoaded => _dataLoaded;

  String get userName => _userProfile.userName;
  set userName(String value) {
    _userProfile.userName = value;
    notifyListeners();
  }

  String get email => _userProfile.email;
  set email(String value) {
    _userProfile.email = value;
    notifyListeners();
  }

  String get password => _userProfile.password;
  set password(String value) {
    _userProfile.password = value;
    notifyListeners();
  }

  void wipe() {
    _userProfile = UserProfile.empty();
    _dataLoaded = false;
    notifyListeners();
  }

  void updateUserProfile(UserProfile userProfile) {
    _userProfile = userProfile;
    _dataLoaded = true;
    notifyListeners();
  }

  Future<bool> fetchUserProfileIfNeeded() async {
    if (_userProfile.isMissingKeyData() || !_dataLoaded) {
      bool success = await DBUserProfile.fetchUserProfileAndSyncProvider(this);
      if (success) {
        _dataLoaded = true;
      }
      return success;
    }
    return true;
  }

  Future<bool> writeUserProfileToDb() async {
    return await DBUserProfile.writeUserProfile(_userProfile);
  }
}

final userProfileProvider = ChangeNotifierProvider<UserProfileProvider>((ref) {
  return UserProfileProvider();
});
