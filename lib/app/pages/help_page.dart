import 'package:flutter/material.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bantuan'),
      ),
      body: SafeArea( // Memastikan konten tidak terhalang oleh system UI (status bar, notch)
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Kustom
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
              child: Column( // Mengubah Row menjadi Column
                crossAxisAlignment: CrossAxisAlignment.start, // Agar teks Bantuan rata kiri
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left), // Ikon sesuai gambar
                    iconSize: 30.0, // Sesuaikan ukuran ikon jika perlu
                    color: Colors.black87,
                    onPressed: () {
                      // Aksi ketika tombol kembali ditekan
                      if (Navigator.canPop(context)) {
                        Navigator.of(context).pop();
                      }
                    },
                    // Mengurangi padding default IconButton agar lebih rapat
                    padding: const EdgeInsets.all(8.0), // Sedikit padding agar area sentuh tidak terlalu kecil
                    constraints: const BoxConstraints(), // Untuk memungkinkan padding yang lebih kecil
                  ),
                  const Padding( // Menambahkan Padding untuk teks "Bantuan"
                    padding: EdgeInsets.only(left: 16.0, top: 4.0), // Sesuaikan padding sesuai kebutuhan
                    child: Text(
                      'Bantuan',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12.0), // Jarak antara header "Bantuan" dan konten berikutnya

            // Konten yang Dapat Di-scroll
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0), // Padding untuk konten list
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- Bagian FAQ (Pertanyaan Umum) ---
                    _buildCardWithShadow( // Box luar untuk seluruh bagian FAQ
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'FAQ (Pertanyaan Umum)',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 16), // Jarak antara judul FAQ dan item pertama
                            _buildFAQItem(text: 'Bagaimana saya tahu laporan saya diterima?'),
                            const SizedBox(height: 10),
                            _buildFAQItem(text: 'Apakah identitas saya benar-benar aman?'),
                            const SizedBox(height: 10),
                            _buildFAQItem(text: 'Apakah saya harus login untuk melapor?'),
                            const SizedBox(height: 10),
                            _buildFAQItem(text: 'Bagaimana saya tahu laporan saya diterima?'), // Pertanyaan ini duplikat di gambar
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24), // Jarak setelah bagian FAQ

                    // --- Bagian Hubungi Admin/Live Support ---
                    const Text(
                      'Hubungi Admin/Live Support',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildActionItem(
                      icon: Icons.chat_bubble_outline_rounded,
                      iconColor: Colors.redAccent,
                      text: 'Chat',
                    ),
                    const SizedBox(height: 24),

                    // --- Bagian Tutorial Interaktif ---
                    const Text(
                      'Tutorial Interaktif',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildActionItem(
                      icon: Icons.play_circle_outline_rounded,
                      iconColor: Colors.redAccent,
                      text: 'Tutorial',
                    ),
                    const SizedBox(height: 32), // Jarak sebelum tombol

                    // --- Tombol Laporkan Masalah Aplikasi ---
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          // Aksi ketika tombol ditekan
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red.shade700, // Warna tombol merah
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          elevation: 2, // Sedikit shadow untuk tombol
                        ),
                        child: const Text(
                          'Laporkan Masalah Aplikasi',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16), // Jarak di akhir halaman
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Helper widget untuk membuat setiap item FAQ.
  Widget _buildFAQItem({required String text}) {
    return _buildCardWithShadow( // Setiap item FAQ adalah box tersendiri
      child: Material( // Menambahkan Material untuk efek ripple saat diklik
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // Aksi ketika item FAQ diklik
          },
          borderRadius: BorderRadius.circular(10.0), // Sesuaikan dengan card
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded( // Expanded agar teks bisa wrap jika panjang
                  child: Text(
                    text,
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.black87,
                    ),
                  ),
                ),
                const SizedBox(width: 8), // Jarak antara teks dan ikon
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                  color: Colors.grey.shade600,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Helper widget untuk membuat item aksi seperti Chat dan Tutorial.
  Widget _buildActionItem({
    required IconData icon,
    required Color iconColor,
    required String text,
  }) {
    return _buildCardWithShadow(
      child: Material( // Menambahkan Material untuk efek ripple saat diklik
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // Aksi ketika item diklik
          },
          borderRadius: BorderRadius.circular(10.0), // Sesuaikan dengan card
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: iconColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded( // Expanded agar teks bisa wrap jika panjang
                  child: Text(
                    text,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                  color: Colors.grey.shade600,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Helper widget untuk membuat container (card) putih dengan shadow.
  Widget _buildCardWithShadow({required Widget child}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08), // Warna shadow disesuaikan
            blurRadius: 8,
            offset: const Offset(0, 4), // Posisi shadow hanya di bawah
          ),
        ],
      ),
      child: child,
    );
  }
}