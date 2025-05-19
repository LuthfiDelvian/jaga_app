import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            GridView.count(
              crossAxisCount: 2,
              childAspectRatio: 2 / 1.2,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: [
                _buildCard(context, Colors.red, Icons.edit, 'Laporan'),
                _buildCard(context, Colors.green, Icons.book, 'Panduan Laporan'),
                _buildCard(context, Colors.blue, Icons.article, 'Artikel'),
                _buildCard(context, Colors.orange, Icons.help, 'Bantuan'),
              ],
            ),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                hintText: 'Search...',
                suffixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                hintText: 'Masukkan Tracking ID...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            _statusCard('Pengaduan', '21 April 2025', 'Selesai', Colors.green),
            _statusCard('Penyusupan', '21 April 2025', 'Ditolak', Colors.red),
            _statusCard('Aspirasi', '21 April 2025', 'Diproses', Colors.orange),
          ],
        ),
      ),
    );
  }
}

Widget _buildCard(
  BuildContext context,
  Color color,
  IconData icon,
  String title,
) {
  return Card(
    color: color,
    child: InkWell(
      onTap: () {}, // Add your onTap functionality here
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.white),
            SizedBox(height: 10),
            Text(title, style: TextStyle(color: Colors.white, fontSize: 16)),
          ],
        ),
      ),
    ),
  );
}

Widget _statusCard(
  String title,
  String date,
  String status,
  Color statusColor,
) {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 8),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.2),
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Row(
      children: [
        // Status icon
        Container(
          width: 10,
          height: 50,
          decoration: BoxDecoration(
            color: statusColor,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 12),

        // Title and date/status
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(
                    Icons.calendar_today,
                    size: 14,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 4),
                  Text(date, style: const TextStyle(color: Colors.grey)),
                  const SizedBox(width: 16),
                  Icon(Icons.circle, size: 12, color: statusColor),
                  const SizedBox(width: 4),
                  Text(status, style: TextStyle(color: statusColor)),
                ],
              ),
            ],
          ),
        ),

        // Action text
        TextButton(
          onPressed: () {},
          child: const Text('unduh', style: TextStyle(color: Colors.blue)),
        ),
      ],
    ),
  );
}
