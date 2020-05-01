import 'package:alphagarage/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:alphagarage/models/message_model.dart';

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
  final Firestore _firestore = Firestore();
  final _auth = FirebaseAuth.instance;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  Firestore get firestore => _firestore;

  getDeviceToken() async {
    final deviceToken = await _firebaseMessaging.getToken();
    return deviceToken;
  }

  postToken() async {
    final deviceToken = await getDeviceToken();
    final currentUser = await _auth.currentUser();

    // Tap into the user's device tokens
    // Get current user document ID
    final currentUserDocuments = await _firestore
        .collection('users')
        .where('email', isEqualTo: currentUser.email)
        .getDocuments();

    String currentUserDocumentID;
    for (var document in currentUserDocuments.documents) {
      currentUserDocumentID = document.documentID;
    }

    // Get the device token collection
    QuerySnapshot userDeviceTokens = await _firestore
        .collection('users')
        .document(currentUserDocumentID)
        .collection('deviceTokens')
        .getDocuments();

    // Add device token if not already added
    for (var token in userDeviceTokens.documents) {
      if (deviceToken == token['deviceToken']) return;
    }

    DocumentReference documentReference = _firestore
        .collection('users')
        .document(currentUserDocumentID)
        .collection('deviceTokens')
        .document();

    await documentReference.setData({'deviceToken': deviceToken});
  }

  Future<void> registerUser({
    String displayName,
    String email,
    bool isAdmin = false,
  }) async {
    await checkInternConnection();

    DocumentReference documentReference =
        _firestore.collection('users').document();
    await documentReference.setData({
      'displayName': displayName,
      'email': email,
      'isAdmin': isAdmin,
    });
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
        UserData userData = UserData(
            displayName: user['displayName'],
            email: user['email'],
            isAdmin: user['isAdmin']);
        users.add(userData);
      }
    }
    return users;
  }

  getAllAdmins() async {
    await checkInternConnection();

    List<UserData> admins = [];
    List<UserData> users = await getAllUsers();
    for (var user in users) {
      if (user.isAdmin) {
        admins.add(user);
      }
    }

    return admins;
  }

  getNonAdminUsers() async {
    await checkInternConnection();

    List<UserData> nonAdminUsers = [];
    List<UserData> users = await getAllUsers();
    for (var user in users) {
      if (!user.isAdmin) {
        nonAdminUsers.add(user);
      }
    }

    return nonAdminUsers;
  }

  Future<void> postMessage(
      {String messageTitle,
      String messageText,
      String receiverEmail,
      String imageReference,
      MessageType messageType}) async {
    await checkInternConnection();

    final FirebaseUser currentUser = await _auth.currentUser();

    final DocumentReference documentReference =
        _firestore.collection('messages').document();

    await documentReference.setData({
      'imageReference': imageReference,
      'messageTitle': messageTitle,
      'messageText': messageText,
      'messageType': messageType == MessageType.announcement
          ? 'announcement'
          : 'privateMessage',
      'senderEmail': currentUser.email,
      'receiverEmail': receiverEmail,
      'timestamp': DateTime.now().millisecondsSinceEpoch
    }, merge: true);
  }

  Future<void> sendMessage(Message message) async {
    await checkInternConnection();

    final DocumentReference documentReference =
        _firestore.collection('chats').document();

    await documentReference.setData({
      'messageSender': message.messageSender,
      'messageReceiver': message.messageReceiver,
      'messageText': message.messageText,
      'timestamp': message.timestamp,
    }, merge: true);
  }
}
