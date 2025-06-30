import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'laporan_status_card.dart';
import '../pages/report_detail_page.dart';

class LaporanList extends StatelessWidget {
  final String uid;
  const LaporanList({super.key, required this.uid});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream:
          FirebaseFirestore.instance
              .collection('laporan')
              .where('uid', isEqualTo: uid)
              .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Text('Belum ada laporan untuk UID: $uid');
        }

        final laporanDocs = snapshot.data!.docs;

        return Column(
          children:
              laporanDocs.map((doc) {
                final data = doc.data() as Map<String, dynamic>;
                final laporanId = doc.id;

                return LaporanStatusCard(
                  id: laporanId,
                  title: data['judul'] ?? 'Tidak ada judul',
                  status: data['status'] ?? 'Tidak diketahui',
                  date: data['tanggal'],
                  onDetailPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (_) => ReportDetailPage(documentId: laporanId),
                      ),
                    );
                  },
                );
              }).toList(),
        );
      },
    );
  }
}
