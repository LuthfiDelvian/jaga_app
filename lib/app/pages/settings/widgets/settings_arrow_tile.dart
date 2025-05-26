import 'package:flutter/material.dart';

class SettingsArrowTile extends StatelessWidget {
  final String title;
  final String? trailingText;
  final VoidCallback? onTap;

  const SettingsArrowTile({
    super.key,
    required this.title,
    this.trailingText,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.15),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(child: Text(title)),
            if (trailingText != null) ...[
              Text(trailingText!, style: const TextStyle(color: Colors.grey)),
              const SizedBox(width: 8),
            ],
            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }
}
