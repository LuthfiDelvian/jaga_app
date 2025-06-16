import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jaga_app/app/pages/articles/widgets/mini_article_card.dart';

class ReportSuccessPage extends StatelessWidget {
  const ReportSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(12),
              ),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error, color: Colors.white, size: 36),
                      Text(
                        'Laporan Terkirim',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ],
                  ),

                  const SizedBox(height: 6),
                  const Text(
                    'Lihat Laporan Saya untuk informasi lebih lanjut',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 13),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.of(
                              context,
                            ).pushNamedAndRemoveUntil('/', (route) => false);
                          },

                          style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.red,
                            side: const BorderSide(color: Colors.white),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 10,
                            ),
                          ),
                          child: const Text(
                            'Beranda',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton(
                          onPressed:
                              () => Navigator.of(
                                context,
                              ).pushNamed('/laporan-saya'),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.white),
                            backgroundColor: Colors.red,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 10,
                            ),
                          ),
                          child: const Text(
                            'Laporan saya',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),
            const Divider(thickness: 1),
            const Padding(
              padding: EdgeInsets.only(top: 12, bottom: 8),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  'Rekomendasi',
                  style: TextStyle(fontSize: 15, color: Colors.black45),
                ),
              ),
            ),
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
                    child: Text("Terjadi kesalahan: \${snapshot.error}"),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text("Tidak ada rekomendasi tersedia."),
                  );
                }

                final docs = snapshot.data!.docs;

                return Column(
                  children:
                      docs.map((doc) {
                        final data = doc.data() as Map<String, dynamic>;
                        return MiniArticleCard(
                          article: data,
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              '/detail',
                              arguments: data,
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
