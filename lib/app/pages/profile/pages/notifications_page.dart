import 'package:flutter/material.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy data notifikasi
    final List<Map<String, String>> notifications = [
      {'text': 'Laporan Anda telah diverifikasi', 'time': '1hr'},
      {'text': 'Status laporan Anda telah diperbarui', 'time': '30m'},
      {'text': 'Laporan Anda telah diproses!', 'time': '10m'},
      {'text': 'Ada berita terbaru!', 'time': '2d'},
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        elevation: 1,
        centerTitle: true,
        leading: BackButton(color: Colors.white),
        title: Text('Notifikasi', style: TextStyle(color: Colors.white)),
      ),
      body: Column(
        children: [
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: ListView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.all(16),
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  final notif = notifications[index];
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
                        Icon(Icons.notifications_active, color: Colors.red),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            notif['text'] ?? '',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        SizedBox(width: 8),
                        Text(
                          notif['time'] ?? '',
                          style: TextStyle(color: Colors.grey, fontSize: 13),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white,
    );
  }
}
