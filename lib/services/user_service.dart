import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserService {
  static Future<void> saveUser({required String loginType}) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final ref =
        FirebaseFirestore.instance.collection('users').doc(user.uid);

    await ref.set({
      'uid': user.uid,
      'email': user.email,
      'loginType': loginType,
      'loggedIn': true,
      'createdAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }
}
