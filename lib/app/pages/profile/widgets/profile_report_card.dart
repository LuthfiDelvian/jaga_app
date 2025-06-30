import 'package:flutter/material.dart';

class ProfileReportCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String date;
  final String status;
  final Color statusColor;
  final VoidCallback? onTap;

  const ProfileReportCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.date,
    required this.status,
    required this.statusColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
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
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              GestureDetector(
                onTap: onTap, // 👈 Aksi ke detail page
                child: const Icon(Icons.chevron_right),
              ),
            ],
          ),

          const SizedBox(height: 4),
          Text(subtitle),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                date,
                style: const TextStyle(fontSize: 13, color: Colors.grey),
              ),
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
