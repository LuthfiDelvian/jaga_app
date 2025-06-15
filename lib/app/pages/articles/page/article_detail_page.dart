import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jaga_app/app/pages/articles/widgets/mini_article_card.dart';

class ArticleDetailPage extends StatefulWidget {
  const ArticleDetailPage({super.key});

  @override
  State<ArticleDetailPage> createState() => _ArticleDetailPageState();
}

class _ArticleDetailPageState extends State<ArticleDetailPage> {
  bool showFull = false;

  @override
  Widget build(BuildContext context) {
    final article =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    final String judul = article['judul'] ?? '';
    final String konten = article['konten'] ?? '';
    final String imageUrl = article['image_url'] ?? '';
    final String tanggal =
        article['tanggal'] is Timestamp
            ? (article['tanggal'] as Timestamp).toDate().toString().split(
              ' ',
            )[0]
            : article['tanggal'] ?? '';

    return Scaffold(
      appBar: AppBar(
        title: Text(judul),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (imageUrl.isNotEmpty)
              Image.network(
                imageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
              ),

            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text(
                judul,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(left: 16),
                child: Text(
                  'Ditayangkan $tanggal',
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    showFull
                        ? konten
                        : (konten.length > 300
                            ? konten.substring(0, 300) + '...'
                            : konten),
                    style: const TextStyle(fontSize: 14),
                    textAlign: TextAlign.justify,
                  ),

                  const SizedBox(height: 8),
                  if (konten.length > 300)
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: () => setState(() => showFull = !showFull),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(showFull ? 'Lebih sedikit' : 'Lihat semua'),
                      ),
                    ),
                ],
              ),
            ),

            const Divider(thickness: 1),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Rekomendasi',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 8),

            FutureBuilder<QuerySnapshot>(
              future:
                  FirebaseFirestore.instance
                      .collection('artikel')
                      .where('status', isEqualTo: 'terbit')
                      .orderBy('tanggal', descending: true)
                      .limit(4)
                      .get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                if (snapshot.hasError) {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text("Terjadi kesalahan: ${snapshot.error}"),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text("Tidak ada rekomendasi tersedia."),
                  );
                }

                final docs =
                    snapshot.data!.docs
                        .where((doc) => doc['id'] != article['id'])
                        .toList();

                return Column(
                  children:
                      docs.map((doc) {
                        final data = doc.data() as Map<String, dynamic>;
                        return MiniArticleCard(
                          article: data,
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const ArticleDetailPage(),
                                settings: RouteSettings(arguments: data),
                              ),
                            );
                          },
                        );
                      }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
