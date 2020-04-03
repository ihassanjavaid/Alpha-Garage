import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  final _auth = FirebaseAuth.instance;

  Future<void> loginUserWithEmailAndPassword(
      {String email, String password}) async {
    final ConnectivityResult connectivityStatus =
        await (Connectivity().checkConnectivity());
    if (connectivityStatus != ConnectivityResult.none) {
      // Use the email and password to sign-in the user
      try {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
      } catch (e) {
        print(e);
        throw 'Invalid username or password';
      }
    } else {
      throw 'No internet connection';
    }
  }

  Future<void> registerUser({String email, String password}) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
    } catch (e) {
      throw 'User already exists';
    }
  }

  Future<void> updateUserInfo({
    String displayName = '',
    String photoURL = '',
  }) async {
    final userUpdateInfo = UserUpdateInfo();
    userUpdateInfo.displayName = displayName;
    userUpdateInfo.photoUrl = photoURL;
    try {
      final currentUser = await _auth.currentUser();
      currentUser.updateProfile(userUpdateInfo);
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<bool> updateUserPassword(String newPassword) async {
    FirebaseUser user = await _auth.currentUser();

    try {
      await user.updatePassword(newPassword);
      return true;
    } catch (e) {
      return false;
    }
  }
}
