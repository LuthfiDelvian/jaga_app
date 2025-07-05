import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        elevation: 1,
        centerTitle: true,
        leading: BackButton(color: Colors.white),
        title: Text('Notifikasi', style: TextStyle(color: Colors.white)),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('artikel')
            .orderBy('tanggal', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          final articleDocs = snapshot.data?.docs ?? [];

          if (articleDocs.isEmpty) {
            return Center(child: Text('Belum ada notifikasi.'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: articleDocs.length,
            itemBuilder: (context, index) {
              final data = articleDocs[index].data() as Map<String, dynamic>;
              final judul = data['judul'] ?? 'Artikel baru';
              final createdAt = data['tanggal'] as Timestamp?;
              final time = createdAt != null
                  ? timeAgo(createdAt.toDate())
                  : '';

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.article_outlined, color: Colors.red),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Artikel baru: $judul',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      time,
                      style: TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      backgroundColor: Colors.white,
    );
  }

  // Helper untuk format waktu seperti "2m", "3d", dst
  String timeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inMinutes < 1) return 'Baru saja';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m';
    if (diff.inHours < 24) return '${diff.inHours}h';
    if (diff.inDays < 7) return '${diff.inDays}d';
    return DateFormat('d MMM').format(date);
  }
}