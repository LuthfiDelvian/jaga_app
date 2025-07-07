import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:jaga_app/app/pages/profile/pages/chat_page.dart';
import 'package:jaga_app/app/pages/profile/pages/notifications_page.dart';

PreferredSizeWidget? buildCustomAppBar(BuildContext context, int selectedPage) {
  if (selectedPage != 0) return null;

  return AppBar(
    elevation: 1,
    shadowColor: Colors.grey.withOpacity(0.2),
    backgroundColor: Colors.white,
    leading: IconButton(
      icon: Transform(
        alignment: Alignment.center,
        transform: Matrix4.rotationY(3.1416),
        child: const Icon(Icons.comment, color: Colors.amber),
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ChatPage()),
        );
      },
    ),
    title: Image.asset('assets/images/jaga-icon.png', height: 100),
    centerTitle: true,
    actions: [
      IconButton(
        icon: const Icon(Icons.notifications, color: Colors.red),
        onPressed: () async {
          final user = FirebaseAuth.instance.currentUser;
          if (user == null) {
            // Bisa tampilkan dialog/login
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('Anda belum login')));
            return;
          }

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => NotificationsPage(currentUserId: user.uid),
            ),
          );
        },
      ),
    ],
  );
}
