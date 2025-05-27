import 'package:flutter/material.dart';
import 'package:jaga_app/app/pages/articles/page/articles_page.dart';
import 'package:jaga_app/app/pages/report/form_page.dart';

class HomeMenuGrid extends StatelessWidget {
  const HomeMenuGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      childAspectRatio: 2 / 1.2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _MenuCard(
          color: Colors.red,
          icon: Icons.edit,
          title: 'Laporan',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const FormPage()),
            );
          },
        ),
        _MenuCard(
          color: Colors.green,
          icon: Icons.book,
          title: 'Panduan Laporan',
          onTap: () {
            
          },
        ),
        _MenuCard(
          color: Colors.blue,
          icon: Icons.article,
          title: 'Artikel',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ArticlesPage()),
            );
          },
        ),
        _MenuCard(
          color: Colors.orange,
          icon: Icons.help,
          title: 'Bantuan',
          onTap: () {
            
          },
        ),
      ],
    );
  }
}

class _MenuCard extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _MenuCard({
    required this.color,
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      child: InkWell(
        onTap: onTap,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: Colors.white),
              const SizedBox(height: 10),
              Text(
                title,
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}