import 'package:flutter/material.dart';

class HomeSearchAndTracking extends StatelessWidget {
  const HomeSearchAndTracking({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        _InputCard(
          hintText: 'Search...',
          suffixIcon: Icon(Icons.search),
        ),
        SizedBox(height: 10),
        _InputCard(
          hintText: 'Masukkan Tracking ID...',
        ),
      ],
    );
  }
}

class _InputCard extends StatelessWidget {
  final String hintText;
  final Widget? suffixIcon;

  const _InputCard({
    required this.hintText,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: hintText,
          suffixIcon: suffixIcon,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
      ),
    );
  }
}