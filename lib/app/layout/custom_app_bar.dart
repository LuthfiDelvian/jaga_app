import 'package:flutter/material.dart';
import 'package:jaga_app/app/pages/more/pages/chat_page.dart';
import 'package:jaga_app/app/pages/more/pages/notifications_page.dart';

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
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const NotificationsPage()),
          );
        },
      ),
    ],
  );
}
