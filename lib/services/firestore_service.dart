import 'package:cloud_firestore/cloud_firestore.dart';

enum Collections { users, messages }

class FirestoreService {
  final _firestore = Firestore();

  Future<void> registerUser({
    String email,
    bool isAdmin = false,
  }) async {
    DocumentReference documentReference = _firestore.collection().document();
    await documentReference.setData({'email': email, 'isAdmin': isAdmin});
  }
}
