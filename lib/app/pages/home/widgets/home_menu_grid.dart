import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jaga_app/app/pages/articles/page/articles_page.dart';
import 'package:jaga_app/app/pages/home/page/guide_page.dart';
import 'package:jaga_app/app/pages/home/page/help_page.dart';
import 'package:jaga_app/app/pages/login_register_page.dart';
import 'package:jaga_app/app/pages/report/pages/form_page.dart';

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
            final user = FirebaseAuth.instance.currentUser;
            if (user == null) {
              showDialog(
                context: context,
                builder:
                    (context) => AlertDialog(
                      title: const Text('Login Diperlukan'),
                      content: const Text(
                        'Silakan login terlebih dahulu untuk membuat laporan.',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Batal'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const LoginRegisterPage(),
                              ),
                            );
                          },
                          child: const Text('Login'),
                        ),
                      ],
                    ),
              );
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ReportFormPage()),
              );
            }
          },
        ),
        _MenuCard(
          color: Colors.green,
          icon: Icons.book,
          title: 'Panduan Laporan',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const GuidePage()),
            );
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
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const HelpPage()),
            );
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            // Icon di pojok kanan atas dengan background hitam transparan
            Positioned(
              top: 10,
              right: 10,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(8),
                child: Icon(icon, size: 24, color: Colors.white),
              ),
            ),

            // Title di pojok kiri bawah
            Positioned(
              left: 12,
              bottom: 12,
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
