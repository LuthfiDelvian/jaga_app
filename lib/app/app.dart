import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:jaga_app/app/layout/widget_tree.dart';
import 'package:jaga_app/app/pages/articles/page/article_detail_page.dart';
import 'layout/welcome_page.dart';
import 'package:jaga_app/core/notifiers/theme_notifier.dart';
import 'package:jaga_app/core/theme/app_theme.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    _initFirebaseMessaging();
  }

  Future<void> _initFirebaseMessaging() async {
    // Request permission (iOS & Android 13+)
    await FirebaseMessaging.instance.requestPermission();

    // Local notification init (Android)
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (payload) {
        // Optional: handle tap on notification in foreground
      },
    );

    // Notifikasi masuk saat app foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final notif = message.notification;
      final android = notif?.android;
      if (notif != null && android != null) {
        flutterLocalNotificationsPlugin.show(
          notif.hashCode,
          notif.title,
          notif.body,
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'jaga_channel',
              'JAGA Notifikasi',
              channelDescription: 'Notifikasi JAGA',
              importance: Importance.max,
              priority: Priority.high,
              playSound: true,
            ),
          ),
          payload: message.data.isNotEmpty ? message.data.toString() : null,
        );
      }
    });

    // Notifikasi diklik (background/terminated)
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _handleNotificationClick(context, message.data);
    });

    // Untuk app terminated (cold start)
    _checkInitialMessage();
  }

  Future<void> _checkInitialMessage() async {
    final message = await FirebaseMessaging.instance.getInitialMessage();
    if (message != null) {
      _handleNotificationClick(context, message.data);
    }
  }

  void _handleNotificationClick(
    BuildContext context,
    Map<String, dynamic> data,
  ) {
    // Routing: Artikel
    if (data['artikelId'] != null) {
      Navigator.pushNamed(
        context,
        '/detail',
        arguments: {'id': data['artikelId']},
      );
    }
    // Routing: Laporan
    else if (data['laporanId'] != null) {
      // Tambahkan navigator ke halaman detail laporan kamu di sini.
      // Misal:
      // Navigator.push(context, MaterialPageRoute(builder: (_) => ReportDetailPage(documentId: data['laporanId'])));
    }
    // Tambah else if jika notif lain
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
          routes: {
            '/detail': (context) => const ArticleDetailPage(),
            // '/laporan_detail': (context) => ReportDetailPage(), // tambahkan jika punya
          },
        );
      },
    );
  }
}

/// Alur WelcomePage -> HomePage (belum login) -> WidgetTree (sudah login)
class RootPage extends StatelessWidget {
  const RootPage({super.key});

  @override
  Widget build(BuildContext context) {
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
          // Belum login → arahkan ke WelcomePage dulu
          return const WelcomePage();
        }

        // Sudah login → langsung ke aplikasi
        return const WidgetTree();
      },
    );
  }
}
