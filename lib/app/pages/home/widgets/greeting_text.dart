import 'package:flutter/material.dart';

class GreetingText extends StatelessWidget {
  const GreetingText({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(top: 12, bottom: 14, left: 8),
      child: Text(
        'Halo, Pejuang Integritas! Siap melaporkan hari ini?',
        style: TextStyle(
          color: Colors.black,
          fontSize: 20,
        ),
      ),
    );
  }
}