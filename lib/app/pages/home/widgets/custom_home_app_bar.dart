import 'package:flutter/material.dart';
import 'package:jaga_app/app/pages/login_register_page.dart';

class CustomHomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomHomeAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      automaticallyImplyLeading: false,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset('assets/images/jaga-icon.png', height: 100),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const LoginRegisterPage()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            child: const Text('MASUK', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
