import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class MiniArticleCard extends StatelessWidget {
  final Map<String, dynamic> article;
  final VoidCallback onTap;

  const MiniArticleCard({super.key, required this.article, required this.onTap});

  String getOptimizedUrl(String url) {
    return url.replaceFirst('/upload/', '/upload/w_300,q_70/');
  }

  String getPreview(String konten, {int max = 80}) {
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
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                imageUrl: getOptimizedUrl(imageUrl),
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                placeholder: (context, url) => const SizedBox(
                  width: 80,
                  height: 80,
                  child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
                ),
                errorWidget: (context, url, error) =>
                    const Icon(Icons.broken_image, size: 40),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    judul,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    getPreview(konten),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 12, color: Colors.black87),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}