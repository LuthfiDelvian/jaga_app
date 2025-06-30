import 'package:flutter/material.dart';
import 'package:jaga_app/app/pages/profile/widgets/profile_id_card.dart';
import 'package:jaga_app/app/pages/profile/widgets/profile_report_card.dart';
import 'package:jaga_app/app/pages/profile/widgets/profile_setting_card.dart';
import 'package:jaga_app/app/pages/report/pages/report_detail_page.dart';
import 'package:jaga_app/app/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'diterima':
        return Colors.green;
      case 'diproses':
        return Colors.orange;
      case 'menunggu':
        return Colors.grey;
      default:
        return Colors.blueGrey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final userId = user?.email?.split('@').first ?? '-';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.red,
        elevation: 1,
        centerTitle: true,
        title: Image.asset(
          'assets/images/jaga-icon.png',
          height: 100,
          color: Colors.white,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bagian atas: ID dan Setting
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      ProfileIDCard(id: userId),
                      const SizedBox(height: 12),
                      ProfileSettingCard(
                        label: 'Hapus akun',
                        onTap: () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder:
                                (context) => AlertDialog(
                                  title: const Text('Konfirmasi'),
                                  content: const Text(
                                    'Yakin ingin menghapus akun?',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed:
                                          () => Navigator.pop(context, false),
                                      child: const Text('Batal'),
                                    ),
                                    TextButton(
                                      onPressed:
                                          () => Navigator.pop(context, true),
                                      child: const Text('Hapus'),
                                    ),
                                  ],
                                ),
                          );

                          if (confirm == true) {
                            try {
                              await UserAuthService().deleteAccount();
                              Navigator.of(context).pushReplacementNamed('/');
                            } on FirebaseAuthException catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Gagal menghapus akun: ${e.message}',
                                  ),
                                ),
                              );
                            }
                          }
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Notifikasi'),
                            Switch(
                              value: true,
                              onChanged: (_) {},
                              activeColor: Colors.white,
                              activeTrackColor: Colors.red,
                              inactiveThumbColor: Colors.white,
                              inactiveTrackColor: Colors.grey.shade300,
                            ),
                          ],
                        ),
                      ),
                      ProfileSettingCard(label: 'Bahasa Indonesia'),
                      const SizedBox(height: 12),
                      ProfileSettingCard(
                        label: 'Keluar',
                        onTap: () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder:
                                (context) => AlertDialog(
                                  title: const Text('Konfirmasi'),
                                  content: const Text('Yakin ingin logout?'),
                                  actions: [
                                    TextButton(
                                      onPressed:
                                          () => Navigator.pop(context, false),
                                      child: const Text('Batal'),
                                    ),
                                    TextButton(
                                      onPressed:
                                          () => Navigator.pop(context, true),
                                      child: const Text('Keluar'),
                                    ),
                                  ],
                                ),
                          );

                          if (confirm == true) {
                            try {
                              await UserAuthService().signOut();
                              await Future.delayed(
                                const Duration(milliseconds: 200),
                              );
                              Navigator.of(context).pushReplacementNamed('/');
                            } catch (e, stackTrace) {
                              print('Logout error: $e');
                              print('Stack trace: $stackTrace');
                            }
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),
            const Text(
              'Riwayat Laporan',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance
                      .collection('laporan')
                      .where('uid', isEqualTo: user?.uid)
                      .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Text('Belum ada laporan.');
                }

                final reports = snapshot.data!.docs;

                return Column(
                  children:
                      reports.map((doc) {
                        final data = doc.data() as Map<String, dynamic>;

                        final title = data['judul'] ?? 'Tanpa Judul';
                        final createdAt =
                            (data['createdAt'] as Timestamp?)?.toDate() ??
                            DateTime.now();
                        final status = data['status'] ?? 'Menunggu';
                        final subtitle =
                            data['subtitle'] ?? 'Laporan sedang $status';

                        final formattedDate = DateFormat(
                          'dd MMM yyyy  hh:mm a',
                        ).format(createdAt);
                        final statusColor = getStatusColor(status);

                        return ProfileReportCard(
                          title: title,
                          subtitle: subtitle,
                          date: formattedDate,
                          status: status,
                          statusColor: statusColor,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (_) => ReportDetailPage(documentId: doc.id),
                              ),
                            );
                          },
                        );
                      }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
