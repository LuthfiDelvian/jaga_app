import 'package:flutter/material.dart';

class ArticleCard extends StatelessWidget {
  final Map<String, String> article;

  const ArticleCard({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
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
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Image.asset(
              article['image']!,
              width: double.infinity,
              height: 150,
              fit: BoxFit.cover,
            ),
          ),

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
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              article['description']!,
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
          ),

          const SizedBox(height: 12),
        ],
      ),
    );
  }
}