import 'package:flutter/material.dart';
import 'package:jaga_app/core/notifiers/theme_notifier.dart';
import 'package:jaga_app/core/theme/app_theme.dart';
import 'layout/widget_tree.dart';

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
    isDarkModeNotifier.value = false; // Bisa diganti dengan baca dari SharedPreferences
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
          home: const WidgetTree(),
        );
      },
    );
  }
}