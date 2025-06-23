import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'laporan_status_card.dart';

class LaporanList extends StatelessWidget {
  const LaporanList({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
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
          children: laporanDocs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;

            return LaporanStatusCard(
              id: doc.id,
              title: data['judul'] ?? 'Tidak ada judul',
              status: data['status'] ?? 'Tidak diketahui',
              date: data['tanggal'],
            );
          }).toList(),
        );
      },
    );
  }
}