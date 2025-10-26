import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthServiceHelper {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String?> getUserRole() async {
    User? user = _auth.currentUser;
    if (user == null) return null;

    DocumentSnapshot doc =
    await _firestore.collection('users').doc(user.uid).get();

    if (doc.exists) {
      return doc['role'] as String?;
    }
    return null;
  }
}
