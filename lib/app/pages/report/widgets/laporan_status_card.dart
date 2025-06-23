import 'package:flutter/material.dart';
import 'package:jaga_app/app/widgets/status_card.dart';
import 'package:intl/intl.dart';

class LaporanStatusCard extends StatelessWidget {
  final String id;
  final String title;
  final String date;
  final String status;

  const LaporanStatusCard({
    super.key,
    required this.id,
    required this.title,
    required this.date,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final parsedDate = _parseTanggal(date);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        StatusCard(
          title: title,
          date: parsedDate != null
              ? '${parsedDate.day} ${_bulan(parsedDate.month)} ${parsedDate.year}'
              : 'Tanggal tidak valid',
          status: status,
          statusColor: _getStatusColor(status),
        ),
      ],
    );
  }

  DateTime? _parseTanggal(String input) {
    try {
      return DateFormat('yyyy-MM-dd').parseStrict(input);
    } catch (_) {
      return null;
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'diproses':
        return Colors.orange;
      case 'ditolak':
        return Colors.red;
      case 'selesai':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  String _bulan(int bulan) {
    const bulanMap = [
      "Januari", "Februari", "Maret", "April", "Mei", "Juni",
      "Juli", "Agustus", "September", "Oktober", "November", "Desember",
    ];
    return bulanMap[bulan - 1];
  }
}