import 'package:flutter/material.dart';
import '../widgets/article_card.dart';
import '../widgets/article_search_bar.dart';

class ArticlesPage extends StatelessWidget {
  const ArticlesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final articles = [
      {
        'image': 'assets/images/law.jpg',
        'title': 'Proyek Fiktif Ditemukan di Lembaga Pendidikan',
        'description':
            'BPK menemukan proyek pengadaan alat praktik di sekolah menengah atas dilakukan dengan anggaran besar, namun anggarannya tetap dibekukan dahulu.',
      },
      {
        'image': 'assets/images/law.jpg',
        'title': 'Korupsi Pertamina',
        'description':
            'Kasus dugaan korupsi pengadaan minyak di Pertamina dari tahun anggaran 2018–2023 mendapat perhatian luas setelah mantan CEO dilaporkan ke KPK.',
      },
      {
        'image': 'assets/images/law.jpg',
        'title': 'KPK Ajak Mahasiswa Jadi Pengawas Integritas',
        'description':
            'KPK menggagas program integritas kampus dengan melibatkan mahasiswa sebagai agen perubahan pemberantasan korupsi sejak dini.',
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
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 10),
              const ArticleSearchBar(),
              const SizedBox(height: 16),
              ...articles.map((article) => ArticleCard(article: article)).toList(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}