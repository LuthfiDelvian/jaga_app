import 'package:flutter/material.dart';

class GuidePage extends StatelessWidget {
  const GuidePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar dengan tombol kembali
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Aksi ketika tombol kembali ditekan
            // Jika halaman ini dibuka melalui Navigator.push,
            // ini akan kembali ke halaman sebelumnya.
            if (Navigator.canPop(context)) {
              Navigator.of(context).pop();
            }
            // Jika tidak, Anda mungkin perlu implementasi lain,
            // misalnya jika ini adalah halaman root.
          },
        ),
        // Tidak ada judul di AppBar sesuai gambar
      ),
      // Body utama dengan SingleChildScrollView agar konten bisa di-scroll
      // jika melebihi tinggi layar
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0), // Padding di sekeliling konten utama
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Ratakan konten ke kiri
          children: [
            // --- Bagian Panduan Laporan ---
            _buildCardWithShadow(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Panduan Laporan',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87, // Warna teks agar tidak terlalu pekat
                      ),
                    ),
                    const SizedBox(height: 8), // Jarak vertikal
                    Text(
                      'Pelajari cara melapor yang aman dan akurat agar laporan kamu diproses dengan cepat.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade700, // Warna teks deskripsi
                        height: 1.4, // Jarak antar baris untuk keterbacaan
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24), // Jarak antar bagian

            // --- Bagian Langkah-Langkah Melapor (Dibungkus Card Luar) ---
            _buildCardWithShadow(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Langkah-Langkah Melapor',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Setiap langkah sekarang memiliki box dan shadow sendiri
                    _buildStepTileWithShadow(
                      context: context, // Pass context
                      icon: Icons.warning_amber_rounded, // Ikon peringatan
                      title: 'Pilih jenis pelanggaran',
                      content: 'Jelaskan secara singkat jenis pelanggaran yang ingin Anda laporkan.', // Contoh konten detail
                      // hasOwnShadow: true, // Defaultnya true, jadi bisa dihilangkan
                    ),
                    const SizedBox(height: 12),
                    _buildStepTileWithShadow(
                      context: context, // Pass context
                      icon: Icons.description_outlined, // Ikon dokumen
                      title: 'Isi kronologi kejadian',
                      content: 'Sertakan detail waktu, tempat, dan urutan kejadian secara jelas.',
                      // hasOwnShadow: true,
                    ),
                    const SizedBox(height: 12),
                    _buildStepTileWithShadow(
                      context: context, // Pass context
                      icon: Icons.upload_file_outlined, // Ikon unggah
                      title: 'Unggah bukti pendukung',
                      content: 'Lampirkan foto, video, atau dokumen lain yang relevan sebagai bukti.',
                      // hasOwnShadow: true,
                    ),
                    const SizedBox(height: 12),
                    _buildStepTileWithShadow(
                      context: context, // Pass context
                      icon: Icons.person_outline, // Ikon pengguna
                      title: 'Pilih anonimitas atau login',
                      content: 'Anda dapat memilih untuk melapor secara anonim atau menggunakan akun Anda.',
                      // hasOwnShadow: true,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24), // Jarak antar bagian

            // --- Bagian Tips Melapor yang Efektif (Dibungkus Card, Konten Kosong dengan Jarak) ---
            _buildCardWithShadow(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Tips Melapor yang Efektif',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 16), // Jarak antara judul dan konten (kosong)
                    // Menambahkan Container dengan tinggi tertentu untuk menciptakan ruang kosong
                    Container(height: 100), // Anda bisa menyesuaikan tinggi ini sesuai kebutuhan
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16), // Jarak di akhir halaman
          ],
        ),
      ),
    );
  }

  /// Helper widget untuk membuat container (card) putih dengan shadow.
  /// Ini akan membungkus elemen-elemen utama.
  Widget _buildCardWithShadow({required Widget child}) {
    return Container(
      width: double.infinity, // Ensure card takes full width available in the column
      decoration: BoxDecoration(
        color: Colors.white, // Latar belakang box putih
        borderRadius: BorderRadius.circular(10.0), // Sudut yang sedikit lebih membulat
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12), // Warna shadow sedikit lebih gelap
            // spreadRadius: 1, // Dihilangkan agar shadow tidak menyebar ke samping
            blurRadius: 8, // Blur radius disesuaikan
            offset: const Offset(0, 6), // Posisi shadow hanya di bawah (x, y)
          ),
        ],
      ),
      child: child, // Konten di dalam box
    );
  }

  /// Helper widget untuk membuat setiap langkah laporan.
  /// Menggunakan ExpansionTile. Bisa dibungkus _buildCardWithShadow atau tidak.
  Widget _buildStepTileWithShadow({
    required BuildContext context, // Added context parameter
    required IconData icon,
    required String title,
    required String content, // Konten untuk ditampilkan saat di-expand
    bool hasOwnShadow = true, // Parameter untuk mengontrol shadow individu
  }) {
    Widget tileContent = Theme( // Wrap ExpansionTile with Theme
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent), // Set dividerColor to transparent
      child: ExpansionTile(
        // Ikon di sebelah kiri
        leading: Container(
          padding: const EdgeInsets.all(10.0), // Padding di sekitar ikon
          decoration: const BoxDecoration(
            color: Colors.redAccent, // Warna latar ikon (sedikit lebih cerah)
            shape: BoxShape.circle, // Bentuk lingkaran
          ),
          child: Icon(
            icon,
            color: Colors.white, // Ikon putih
            size: 22, // Ukuran ikon
          ),
        ),
        // Judul langkah
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500, // Sedikit tebal
            color: Colors.black87,
          ),
        ),
        // Ikon panah di sebelah kanan (default dari ExpansionTile)
        // trailing: const Icon(Icons.keyboard_arrow_down), // Bisa dikustomisasi jika perlu

        // Konten yang muncul saat di-expand
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0), // Padding untuk konten
            child: Text(
              content,
              style: TextStyle(color: Colors.grey.shade600, height: 1.4),
            ),
          ),
        ],
        // Padding untuk tile itu sendiri
        tilePadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        // Padding untuk children saat di-expand
        childrenPadding: EdgeInsets.zero,
        // Agar konten di dalam children rata kiri
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        // Untuk menjaga state (misalnya jika ada input field di dalamnya)
        maintainState: true,
        // Callback saat tile dibuka atau ditutup (opsional)
        onExpansionChanged: (bool expanded) {
          // print('Tile $title ${expanded ? "dibuka" : "ditutup"}');
        },
      ),
    );

    if (hasOwnShadow) {
      // Jika langkah ini harus memiliki box dan shadow sendiri
      return _buildCardWithShadow(child: tileContent);
    } else {
      // Jika langkah ini tidak memiliki shadow sendiri (misalnya, karena sudah
      // dibungkus oleh card yang lebih besar dan tidak ingin ada shadow ganda).
      // Tetap berikan latar belakang putih dan border radius agar konsisten.
      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
           borderRadius: BorderRadius.circular(10.0), // Cocokkan dengan card luar
        ),
        child: tileContent
      );
    }
  }
}