import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jaga_app/app/pages/home/widgets/custom_home_app_bar.dart';
import '../widgets/home_menu_grid.dart';
import '../widgets/home_search_and_tracking.dart';
import '../../../widgets/status_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.white,
            floating: true,
            snap: true,
            elevation: 0,
            automaticallyImplyLeading: false,
            flexibleSpace: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: CustomHomeAppBar(),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                children: [
                  const HomeMenuGrid(),
                  const SizedBox(height: 20),
                  const HomeSearchAndTracking(),
                  const SizedBox(height: 20),

                  StreamBuilder<QuerySnapshot>(
                    stream:
                        FirebaseFirestore.instance
                            .collection('laporan')
                            .orderBy('createdAt', descending: true)
                            .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      }

                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return const Text('Belum ada laporan');
                      }

                      final laporanDocs = snapshot.data!.docs;

                      return Column(
                        children:
                            laporanDocs.map((doc) {
                              final data = doc.data() as Map<String, dynamic>;

                              final String title =
                                  data['judul'] ?? 'Tidak ada judul';
                              final Timestamp ts =
                                  data['createdAt'] ?? Timestamp.now();
                              final String status =
                                  data['status'] ?? 'Tidak diketahui';

                              final DateTime date = ts.toDate();
                              final statusColor = _getStatusColor(status);

                              return StatusCard(
                                title: title,
                                date:
                                    '${date.day} ${_bulan(date.month)} ${date.year}',
                                status: status,
                                statusColor: statusColor,
                              );
                            }).toList(),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Color _getStatusColor(String status) {
  switch (status.toLowerCase()) {
    case 'diproses':
      return Colors.orange;
    case 'ditolak':
      return Colors.red;
    case 'selesai':
      return Colors.green;
    default:
      return Colors.grey;
  }
}

String _bulan(int bulan) {
  const bulanMap = [
    "Januari",
    "Februari",
    "Maret",
    "April",
    "Mei",
    "Juni",
    "Juli",
    "Agustus",
    "September",
    "Oktober",
    "November",
    "Desember",
  ];
  return bulanMap[bulan - 1];
}
