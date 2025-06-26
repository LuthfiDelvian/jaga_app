import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class UserAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _uuid = Uuid();

  String generateRandomId() {
    return _uuid.v4().split('-').first;
  }

  String generateRandomEmail(String id) {
    return '$id@anon.jaga.com';
  }

  String generateRandomPassword([int length = 10]) {
    const chars =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#\$%^&*()_+-=';
    final rand = Random.secure();
    return List.generate(
      length,
      (index) => chars[rand.nextInt(chars.length)],
    ).join();
  }

  Future<Map<String, String>> registerAnonymousAccount() async {
    final id = generateRandomId();
    final email = generateRandomEmail(id);
    final password = generateRandomPassword();

    final userCred = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    await FirebaseFirestore.instance
        .collection('users')
        .doc(userCred.user!.uid)
        .set({
          'id': id,
          'username': id,
          'email': email,
          'role': 'user',
          'created_at': FieldValue.serverTimestamp(),
          'last_login': FieldValue.serverTimestamp(),
        });

    return {'id': id, 'email': email, 'password': password};
  }

  Future<UserCredential> signInWithIdAndPassword({
    required String id,
    required String password,
  }) async {
    final email = generateRandomEmail(id);
    final result = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    await FirebaseFirestore.instance
        .collection('users')
        .doc(result.user!.uid)
        .set({
          'last_login': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));

    return result;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<void> deleteAccount() async {
    final user = _auth.currentUser;

    if (user != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .delete();

      await user.delete();
      await _auth.signOut();
    }
  }
}
