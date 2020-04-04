import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:alphagarage/utilities/userData.dart';
import 'package:connectivity/connectivity.dart';

enum MessageType {
  announcement,
  privateMessage,
}

Future<void> checkInternConnection() async {
  final ConnectivityResult connectivityStatus =
      await (Connectivity().checkConnectivity());

  if (connectivityStatus == ConnectivityResult.none)
    throw 'No internet connection';
}

class FirestoreService {
  final _firestore = Firestore();
  final _auth = FirebaseAuth.instance;

  Future<void> registerUser({
    String displayName,
    String email,
    bool isAdmin = false,
  }) async {
    await checkInternConnection();

    DocumentReference documentReference =
        _firestore.collection('users').document();
    await documentReference.setData(
        {'displayName': displayName, 'email': email, 'isAdmin': isAdmin});
  }

  Future<UserData> getUserData(String email) async {
    UserData userData;

    await checkInternConnection();

    final userDocuments = await _firestore
        .collection('users')
        .where('email', isEqualTo: email)
        .getDocuments();

    for (var userDocument in userDocuments.documents) {
      userData = UserData(
        email: userDocument['email'],
        displayName: userDocument['displayName'],
        isAdmin: userDocument['isAdmin'],
      );
    }

    return userData;
  }

  Future<List<UserData>> getAllUsers() async {
    List<UserData> users = [];

    await checkInternConnection();

    // Get current user
    final currentUser = await _auth.currentUser();

    // Fetch all users
    final userDocuments = await _firestore.collection('users').getDocuments();

    // Get each user
    for (var user in userDocuments.documents) {
      if (user['email'] != currentUser.email) {
        UserData userData =
            UserData(displayName: user['displayName'], email: user['email']);
        users.add(userData);
      }
    }
    return users;
  }

  Future<void> postMessage(
      {String messageTitle,
      String messageText,
      String receiverEmail,
      MessageType messageType}) async {
    await checkInternConnection();

    final DocumentReference documentReference =
        _firestore.collection('messages').document();

    await documentReference.setData({
      'messageTitle': messageTitle,
      'messageText': messageText,
      'messageType': messageType == MessageType.announcement
          ? 'announcement'
          : 'privateMessage',
      'receiverEmail': receiverEmail
    }, merge: true);
  }
}
