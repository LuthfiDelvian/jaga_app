import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> saveFcmTokenToFirestore({String? vapidKey}) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return;

  String? token;
  if (vapidKey != null) {
    token = await FirebaseMessaging.instance.getToken(vapidKey: vapidKey); // web
  } else {
    token = await FirebaseMessaging.instance.getToken();
  }

  if (token != null) {
    await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
      'fcm_token': token,
      'notif_enabled': true,
    });
  }
}

Future<void> deleteFcmTokenFromFirestore() async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return;
  await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
    'fcm_token': FieldValue.delete(),
    'notif_enabled': false,
  });
  try {
    await FirebaseMessaging.instance.deleteToken();
  } catch (_) {}
}