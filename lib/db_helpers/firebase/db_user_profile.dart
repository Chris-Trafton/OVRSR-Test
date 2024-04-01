import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ovrsr/db_helpers/firebase/firestore_keys.dart';
import 'package:ovrsr/models/user_profile.dart';
import 'package:ovrsr/provider/userProfileProvider.dart';

class DBUserProfile {
  static Future<bool> fetchUserProfileAndSyncProvider(
      UserProfileProvider userProfileProvider) async {
    bool success = false;

    var db = FirebaseFirestore.instance;
    if (FirebaseAuth.instance.currentUser != null) {
      final FirebaseAuth auth = FirebaseAuth.instance;
      final User? user = auth.currentUser;

      if (user == null) {
        return false;
      }
      String uid = user.uid;

      // Try to get the user's data from firestore
      try {
        db
            .collection(FS_COL_SA_USER_PROFILES)
            .doc(uid)
            .snapshots()
            .listen((docRef) {
          if (docRef.exists) {
            Map<String, dynamic>? data = docRef.data()!;
            UserProfile userProfile =
                populateUserProfileFromFirestoreObject(data!);
            userProfileProvider.updateUserProfile(userProfile);
            success = true;
          }
        });
      } catch (e) {
        print(
            "Encountered problem loading user profile from firestore: ${e.toString()}");
        userProfileProvider.wipe();
      }
    }

    // Return status
    return await Future.value(success);
  }

  static UserProfile populateUserProfileFromFirestoreObject(
      Map<String, dynamic> data) {
    String userEmail = FirebaseAuth.instance.currentUser!.email ?? "";
    UserProfile userProfile = UserProfile.fromJsonDbObject(data, userEmail);
    return userProfile;
  }

  static Future<bool> writeUserProfile(UserProfile userProfile) async {
    bool success = false;

    var db = FirebaseFirestore.instance;
    if (FirebaseAuth.instance.currentUser != null) {
      final FirebaseAuth auth = FirebaseAuth.instance;
      final User? user = auth.currentUser;

      if (user == null) {
        return false;
      }
      String uid = user.uid;
      try {
        await db
            .collection(FS_COL_SA_USER_PROFILES)
            .doc(uid)
            .set(userProfile.toJsonForDb(), SetOptions(merge: true));
        success = true;
      } catch (e) {
        print(
            "Encountered problem writing user profile to firestore: ${e.toString()}");
        success = false;
      }
    }

    // Return status
    return success;
  }
}
