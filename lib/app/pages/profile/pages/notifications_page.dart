import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class NotificationsPage extends StatelessWidget {
  final String currentUserId;

  const NotificationsPage({Key? key, required this.currentUserId})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String currentUid = FirebaseAuth.instance.currentUser!.uid;

    final notifStream =
        FirebaseFirestore.instance
            .collection('notifikasi')
            .where('userId', isEqualTo: currentUid)
            .orderBy('createdAt', descending: true)
            .snapshots();

    return StreamBuilder<QuerySnapshot>(
      stream: notifStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasError) {
          print('❌ Stream error: ${snapshot.error}');
        }

        final notifDocs = snapshot.data?.docs ?? [];
        return _buildList(context, notifDocs);
      },
    );
  }

  Widget _buildList(
    BuildContext context,
    List<QueryDocumentSnapshot> notifDocs,
  ) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        elevation: 1,
        centerTitle: true,
        leading: const BackButton(color: Colors.white),
        title: const Text('Notifikasi', style: TextStyle(color: Colors.white)),
      ),
      body:
          notifDocs.isEmpty
              ? const Center(child: Text('Belum ada notifikasi.'))
              : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: notifDocs.length,
                itemBuilder: (context, index) {
                  final doc = notifDocs[index];
                  final data = doc.data() as Map<String, dynamic>;
                  final type = data['type'] ?? '';
                  final text = data['text'] ?? '-';
                  final createdAt = data['createdAt'];
                  final time =
                      (createdAt is Timestamp)
                          ? timeAgo(createdAt.toDate())
                          : '';

                  IconData icon;
                  Color iconColor;
                  if (type == 'artikel') {
                    icon = Icons.article_outlined;
                    iconColor = Colors.red;
                  } else if (type == 'laporan') {
                    icon = Icons.report;
                    iconColor = Colors.amber.shade800;
                  } else {
                    icon = Icons.notifications;
                    iconColor = Colors.blueGrey;
                  }

                  return Dismissible(
                    key: ValueKey(doc.id),
                    direction: DismissDirection.endToStart,
                    onDismissed: (_) => _clearNotif(context, doc.id),
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      color: Colors.red.shade200,
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    child: Container(
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
                          Icon(icon, color: iconColor),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              text,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            time,
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      backgroundColor: Colors.white,
    );
  }

  Future<void> _clearNotif(BuildContext context, String docId) async {
    try {
      await FirebaseFirestore.instance
          .collection('notifikasi')
          .doc(docId)
          .delete();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Notifikasi dihapus')));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal menghapus: $e')));
    }
  }

  static String timeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inMinutes < 1) return 'Baru';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m';
    if (diff.inHours < 24) return '${diff.inHours}j';
    if (diff.inDays < 7) return '${diff.inDays}h';
    return DateFormat('d MMM').format(date);
  }
}
