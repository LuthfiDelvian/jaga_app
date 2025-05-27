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
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: CustomHomeAppBar(),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
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
          )
        ],
      ),
    );
  }
}