import 'package:flutter/material.dart';
import 'package:jaga_app/data/notifiers.dart';

class NavbarWidget extends StatelessWidget {
  const NavbarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: selectedPageNotifier,
      builder: (context, selectedPage, child) {
        return NavigationBar(
          labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
          destinations: [
            NavigationDestination(icon: Icon(Icons.home), label: 'home'),
            NavigationDestination(icon: Icon(Icons.ads_click), label: 'articles'),
            NavigationDestination(icon: Icon(Icons.add_circle), label: 'lapor'),
            NavigationDestination(icon: Icon(Icons.more_horiz_rounded), label: 'more'),
          ],
          onDestinationSelected: (int value) {
            selectedPageNotifier.value = value;
          },
          selectedIndex: selectedPage,
        );
      },
    );
  }
}