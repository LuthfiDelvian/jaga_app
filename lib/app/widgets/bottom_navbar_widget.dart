import 'package:flutter/material.dart';
import 'package:jaga_app/core/notifiers/notifiers.dart';

class NavbarWidget extends StatelessWidget {
  const NavbarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: selectedPageNotifier,
      builder: (context, selectedPage, child) {
        return NavigationBarTheme(
          data: NavigationBarThemeData(
            backgroundColor: Colors.white,
            indicatorColor: Colors.transparent,
            labelTextStyle: MaterialStateProperty.all(
              const TextStyle(fontWeight: FontWeight.bold),
            ),
            iconTheme: MaterialStateProperty.resolveWith((states) {
              if (states.contains(MaterialState.selected)) {
                return const IconThemeData(color: Colors.red, size: 30);
              }
              return const IconThemeData(color: Colors.grey, size: 30);
            }),
            height: 65,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Garis abu-abu tipis
              Container(
                height: 2,
                color: Colors.grey[300], // warna garis
              ),
              // NavigationBar dengan tema
              NavigationBarTheme(
                data: NavigationBarThemeData(
                  backgroundColor: Colors.white,
                  indicatorColor: Colors.transparent,
                  height: 56,
                  iconTheme: MaterialStateProperty.resolveWith((states) {
                    if (states.contains(MaterialState.selected)) {
                      return const IconThemeData(color: Colors.red, size: 30);
                    }
                    return const IconThemeData(color: Colors.black87, size: 26);
                  }),
                ),
                child: ValueListenableBuilder(
                  valueListenable: selectedPageNotifier,
                  builder: (context, selectedPage, child) {
                    return NavigationBar(
                      labelBehavior:
                          NavigationDestinationLabelBehavior.alwaysHide,
                      selectedIndex: selectedPage,
                      onDestinationSelected: (int index) {
                        selectedPageNotifier.value = index;
                      },
                      destinations: const [
                        NavigationDestination(
                          icon: Icon(Icons.home),
                          label: 'home',
                        ),
                        NavigationDestination(
                          icon: Icon(Icons.ads_click),
                          label: 'articles',
                        ),
                        NavigationDestination(
                          icon: Icon(Icons.add_circle),
                          label: 'lapor',
                        ),
                        NavigationDestination(
                          icon: Icon(Icons.person),
                          label: 'profile',
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
