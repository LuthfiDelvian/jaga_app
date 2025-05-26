import 'package:flutter/material.dart';
import 'package:jaga_app/core/notifiers/theme_notifier.dart'; // Pastikan ini sudah ada
import '../widgets/settings_arrow_tile.dart';
import '../widgets/settings_switch_tile.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pengaturan',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        centerTitle: true,
        backgroundColor: Colors.grey[300],
        leading: const BackButton(color: Colors.black87),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ValueListenableBuilder<bool>(
          valueListenable: isDarkModeNotifier,
          builder: (context, isDarkMode, _) {
            return Column(
              children: [
                SettingsSwitchTile(
                  title: "Mode Gelap",
                  value: isDarkMode,
                  onChanged: (val) => isDarkModeNotifier.value = val,
                ),
                const SizedBox(height: 10),
                SettingsSwitchTile(
                  title: "Notifikasi",
                  value: true, // Nanti bisa sambung dengan Notifikasi Notifier jika ada
                  onChanged: (val) {},
                ),
                const SizedBox(height: 10),
                SettingsArrowTile(
                  title: "Bahasa",
                  trailingText: "Indonesia",
                  onTap: () {},
                ),
                const SizedBox(height: 10),
                SettingsArrowTile(title: "Hapus akun", onTap: () {}),
                const SizedBox(height: 10),
                SettingsArrowTile(title: "Logout", onTap: () {}),
              ],
            );
          },
        ),
      ),
    );
  }
}