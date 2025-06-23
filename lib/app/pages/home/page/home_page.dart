import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jaga_app/app/pages/home/widgets/greeting_text.dart';
import 'package:jaga_app/app/pages/home/widgets/home_app_bar_sliver.dart';
import 'package:jaga_app/app/pages/report/widgets/laporan_list.dart';
import '../widgets/home_menu_grid.dart';
import '../widgets/search_tracking_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        final user = snapshot.data;

        return Scaffold(
          body: CustomScrollView(
            slivers: [
              if (user == null) const HomeAppBarSliver(),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (user != null) const GreetingText(),
                      const HomeMenuGrid(),
                      const SizedBox(height: 20),
                      const HomeSearchAndTracking(),
                      const SizedBox(height: 20),
                      const LaporanList(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}