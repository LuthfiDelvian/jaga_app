import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomeSearchAndTracking extends StatefulWidget {
  const HomeSearchAndTracking({super.key});

  @override
  State<HomeSearchAndTracking> createState() => _HomeSearchAndTrackingState();
}

class _HomeSearchAndTrackingState extends State<HomeSearchAndTracking> {
  final TextEditingController _trackingController = TextEditingController();
  String? _statusResult;
  bool _loading = false;
  String? _error;

  void _searchTracking() async {
    setState(() {
      _loading = true;
      _statusResult = null;
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
        final data = doc.data();
        setState(() {
          _statusResult = data?['status'] ?? 'Status tidak ditemukan';
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
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const _InputCard(
            hintText: 'Search...',
            suffixIcon: Icon(Icons.search),
          ),
          const SizedBox(height: 10),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
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
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_forward, color: Colors.red),
                  onPressed: _searchTracking,
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          if (_loading) const CircularProgressIndicator(),
          if (_statusResult != null)
            Text("Status Laporan: $_statusResult",
                style: const TextStyle(fontSize: 16)),
          if (_error != null)
            Text(_error!, style: const TextStyle(color: Colors.red)),
        ],
      ),
    );
  }
}

class _InputCard extends StatelessWidget {
  final String hintText;
  final Widget? suffixIcon;

  const _InputCard({
    required this.hintText,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: hintText,
          suffixIcon: suffixIcon,
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }
}
