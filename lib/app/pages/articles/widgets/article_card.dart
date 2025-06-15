import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ArticleCard extends StatelessWidget {
  final Map<String, dynamic> article;
  final VoidCallback onTap;

  const ArticleCard({super.key, required this.article, required this.onTap});

  String getOptimizedUrl(String url) {
    return url.replaceFirst('/upload/', '/upload/w_600,q_70/');
  }

  String getPreview(String konten, {int max = 100}) {
    if (konten.length <= max) return konten;
    return konten.substring(0, max) + '...';
  }

  @override
  Widget build(BuildContext context) {
    final String konten = (article['konten'] ?? '').toString();
    final String judul = article['judul'] ?? '';
    final String imageUrl = article['image_url'] ?? '';

    return GestureDetector(
      onTap: onTap,
      child: Container(
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
            if (imageUrl.isNotEmpty)
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: CachedNetworkImage(
                  imageUrl: getOptimizedUrl(imageUrl),
                  width: double.infinity,
                  height: 150,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => const SizedBox(
                    height: 150,
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.broken_image),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    judul,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    getPreview(konten),
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}