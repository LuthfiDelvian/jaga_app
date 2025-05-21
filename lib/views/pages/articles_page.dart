import 'package:flutter/material.dart';

class ArticlesPage extends StatelessWidget {
  const ArticlesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final articles = [
      {
        'image': 'assets/images/law.jpg',
        'title': 'Proyek Fiktif Ditemukan di Lembaga Pendidikan',
        'description':
            'Badan Pemeriksa Keuangan (BPK) menemukan proyek pengadaan alat praktik di sekolah menengah atas dilakukan dengan anggaran besar, namun anggarannya tetap dibekukan dahulu.'
      },
      {
        'image': 'assets/images/law.jpg',
        'title': 'Korupsi Pertamina',
        'description':
            'Kasus dugaan korupsi pengadaan minyak di Pertamina dari tahun anggaran 2018–2023 mendapat perhatian luas setelah mantan CEO, dengan inisial RJ, dilaporkan ke lembaga antirasuah.'
      },
      {
        'image': 'assets/images/law.jpg',
        'title': 'KPK Ajak Mahasiswa Jadi Pengawas Integritas',
        'description':
            'Komisi Pemberantasan Korupsi menggagas program integritas kampus dengan melibatkan mahasiswa sebagai agen perubahan dalam pemberantasan korupsi sejak dini.'
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Artikel'),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 10),
              _buildSearchBar(),
              const SizedBox(height: 16),
              ...articles.map((article) => _buildArticleCard(article)).toList(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 2),
          )
        ],
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search...',
          suffixIcon: const Icon(Icons.search),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }

  Widget _buildArticleCard(Map<String, String> article) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Image.asset(
              article['image']!,
              width: double.infinity,
              height: 150,
              fit: BoxFit.cover,
            ),
          ),

          // Title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            child: Text(
              article['title']!,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // Description
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0),
            child: Text(
              article['description']!,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}