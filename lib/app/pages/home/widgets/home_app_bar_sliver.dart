import 'package:flutter/material.dart';
import 'package:jaga_app/app/pages/home/widgets/custom_home_app_bar.dart';

class HomeAppBarSliver extends StatelessWidget {
  const HomeAppBarSliver({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
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
    );
  }
}