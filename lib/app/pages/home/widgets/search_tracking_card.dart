import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../report/widgets/laporan_status_card.dart';

class HomeSearchAndTracking extends StatefulWidget {
  const HomeSearchAndTracking({super.key});

  @override
  State<HomeSearchAndTracking> createState() => _HomeSearchAndTrackingState();
}

class _HomeSearchAndTrackingState extends State<HomeSearchAndTracking> {
  final TextEditingController _trackingController = TextEditingController();
  Map<String, dynamic>? _laporanData;
  bool _loading = false;
  String? _error;

  void _searchTracking() async {
    setState(() {
      _loading = true;
      _laporanData = null;
      _error = null;
    });

    final trackingId = _trackingController.text.trim();

    if (trackingId.isEmpty) {
      setState(() {
        _loading = false;
        _error = 'Tracking ID tidak boleh kosong.';
      });
      return;
    }

    try {
      final doc = await FirebaseFirestore.instance
          .collection('laporan')
          .doc(trackingId)
          .get();

      if (doc.exists) {
        setState(() {
          _laporanData = {
            'id': doc.id,
            ...?doc.data(),
          };
          _loading = false;
        });
      } else {
        setState(() {
          _error = 'Laporan dengan Tracking ID ini tidak ditemukan.';
          _loading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Terjadi kesalahan saat mencari: $e';
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Lacak Laporan',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _trackingController,
                  decoration: const InputDecoration(
                    hintText: 'Masukkan Tracking ID...',
                    border: InputBorder.none,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.search, color: Colors.grey),
                onPressed: _searchTracking,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        if (_loading)
          const Center(child: CircularProgressIndicator())
        else if (_laporanData != null)
          LaporanStatusCard(
            id: _laporanData!['id'],
            title: _laporanData!['judul'] ?? 'Tanpa Judul',
            status: _laporanData!['status'] ?? 'Tidak diketahui',
            date: _laporanData!['tanggal'],
          )
        else if (_error != null)
          Text(
            _error!,
            style: const TextStyle(color: Colors.red),
          ),
      ],
    );
  }
}
