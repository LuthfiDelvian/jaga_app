import 'package:flutter/material.dart';

class HomeMenuGrid extends StatelessWidget {
  const HomeMenuGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      childAspectRatio: 2 / 1.2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: const [
        _MenuCard(color: Colors.red, icon: Icons.edit, title: 'Laporan'),
        _MenuCard(color: Colors.green, icon: Icons.book, title: 'Panduan Laporan'),
        _MenuCard(color: Colors.blue, icon: Icons.article, title: 'Artikel'),
        _MenuCard(color: Colors.orange, icon: Icons.help, title: 'Bantuan'),
      ],
    );
  }
}

class _MenuCard extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String title;

  const _MenuCard({
    required this.color,
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      child: InkWell(
        onTap: () {},
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: Colors.white),
              const SizedBox(height: 10),
              Text(title, style: const TextStyle(color: Colors.white, fontSize: 16)),
            ],
          ),
        ),
      ),
    );
  }
}
