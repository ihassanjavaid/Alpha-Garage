import 'package:firebase_auth/firebase_auth.dart';
import 'package:alphagarage/services/firestore_service.dart';

class Auth {
  final _auth = FirebaseAuth.instance;

  Future<FirebaseUser> get currentUser async => await _auth.currentUser();

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<void> loginUserWithEmailAndPassword(
      {String email, String password}) async {
    await checkInternConnection();
    // Use the email and password to sign-in the user
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      print(e);
      throw 'Invalid username or password';
    }
  }

  Future<void> registerUser({String email, String password}) async {
    await checkInternConnection();
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
    } catch (e) {
      print(e);
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

    await checkInternConnection();

    try {
      final currentUser = await _auth.currentUser();
      currentUser.updateProfile(userUpdateInfo);
    } catch (e) {
      print(e);
      throw e;
    }
  }
}
