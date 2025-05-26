import 'package:flutter/material.dart';
import '../widgets/home_menu_grid.dart';
import '../widgets/home_search_and_tracking.dart';
import '../../../widgets/status_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: SingleChildScrollView(
        child: Column(
          children: const [
            HomeMenuGrid(),
            SizedBox(height: 20),
            HomeSearchAndTracking(),
            SizedBox(height: 20),
            StatusCard(
              title: 'Pengaduan',
              date: '21 April 2025',
              status: 'Selesai',
              statusColor: Colors.green,
            ),
            StatusCard(
              title: 'Penyusupan',
              date: '21 April 2025',
              status: 'Ditolak',
              statusColor: Colors.red,
            ),
            StatusCard(
              title: 'Aspirasi',
              date: '21 April 2025',
              status: 'Diproses',
              statusColor: Colors.orange,
            ),
          ],
        ),
      ),
    );
  }
}
