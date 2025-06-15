import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:jaga_app/app/layout/widget_tree.dart';
import 'package:jaga_app/app/pages/articles/page/article_detail_page.dart';
import 'package:jaga_app/app/pages/home/page/home_page.dart';
import 'layout/welcome_page.dart';
import 'package:jaga_app/core/notifiers/theme_notifier.dart';
import 'package:jaga_app/core/theme/app_theme.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    initThemeMode();
  }

  void initThemeMode() {
    isDarkModeNotifier.value = false;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isDarkModeNotifier,
      builder: (context, isDarkMode, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
          home: const RootPage(),
          routes: {'/detail': (context) => const ArticleDetailPage()},
        );
      },
    );
  }
}

/// Alur WelcomePage -> HomePage (belum login) -> WidgetTree (sudah login)
class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  bool _showWelcome = true;

  @override
  void initState() {
    super.initState();
    // Tampilkan WelcomePage selama 2 detik
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _showWelcome = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_showWelcome) return const WelcomePage();
    // Setelah WelcomePage, cek login
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        final user = snapshot.data;
        if (user == null) {
          // Belum login: HomePage (tanpa WidgetTree, tanpa AppBar utama)
          return const HomePage();
        }
        // Sudah login: WidgetTree (AppBar utama & bottom navbar), HomePage ada di body WidgetTree
        return const WidgetTree();
      },
    );
  }
}
