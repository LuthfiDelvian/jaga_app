import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.red,
        elevation: 1,
        centerTitle: true,
        title: Image.asset(
          'assets/images/jaga-icon.png',
          height: 100,
          color: Colors.white,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ROW KANAN KIRI TETAP
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Kiri: ID + hapus akun
                Expanded(
                  child: Column(
                    children: [
                      // ID Card
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 53),
                        margin: EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'jgA2948K',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                      // Tombol hapus akun
                      _settingButton(context, 'Hapus akun'),
                    ],
                  ),
                ),
                SizedBox(width: 12),
                // Kanan: notifikasi + bahasa + keluar
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        margin: EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Notifikasi'),
                            Switch(
                              value: true,
                              onChanged: (_) {},
                              activeColor: Colors.white,
                              activeTrackColor: Colors.red,
                              inactiveThumbColor: Colors.white,
                              inactiveTrackColor: Colors.grey.shade300,
                            ),
                          ],
                        ),
                      ),
                      _settingButton(context, 'Bahasa  Indonesia'),
                      const SizedBox(height: 12),
                      _settingButton(context, 'Keluar'),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Riwayat laporan
            Text(
              'Riwayat Laporan',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _reportCard(
              title: 'Penyalahgunaan Anggaran',
              subtitle: 'Laporan sedang diverifikasi',
              date: '12 Apr 2024  10:25 AM',
              status: 'Diterima',
              statusColor: Colors.green,
            ),
            _reportCard(
              title: 'Dugaan Penyalahgunaan Dana Kegiatan Sosial',
              subtitle: 'Laporan sedang diproses',
              date: '22 Mei 2024  10:25 AM',
              status: 'Diterima',
              statusColor: Colors.green,
            ),
            _reportCard(
              title: 'Penyalahgunaan Anggaran',
              subtitle: 'Laporan dibatalkan',
              date: '12 Apr 2024  10:25 AM',
              status: 'Dibatalkan',
              statusColor: Colors.red,
            ),
          ],
        ),
      ),
    );
  }

  Widget _settingButton(BuildContext context, String label) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text(label), Icon(Icons.chevron_right)],
      ),
    );
  }

  Widget _reportCard({
    required String title,
    required String subtitle,
    required String date,
    required String status,
    required Color statusColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Icon(Icons.chevron_right),
            ],
          ),
          const SizedBox(height: 4),
          Text(subtitle),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(date, style: TextStyle(fontSize: 13, color: Colors.grey)),
              Row(
                children: [
                  Icon(Icons.check_circle, size: 16, color: statusColor),
                  const SizedBox(width: 4),
                  Text(
                    status,
                    style: TextStyle(
                      fontSize: 13,
                      color: statusColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
