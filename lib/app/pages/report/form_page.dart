import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FormPage extends StatefulWidget {
  const FormPage({super.key});

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  bool _isAnonim = false;
  int _selectedIndex = 0;
  final List<String> _kategori = ['PENGADUAN', 'ASPIRASI', 'PENYUAPAN'];

  final _judulController = TextEditingController();
  final _isiController = TextEditingController();
  final _tanggalController = TextEditingController();
  final _lokasiController = TextEditingController();
  final _instansiController = TextEditingController();

  String _generateTrackingId() {
    return "JAGA-${DateTime.now().millisecondsSinceEpoch}";
  }

  void _pickImage() {
    print("Pilih gambar diklik");
  }

  Future<void> _submitLaporan() async {
    final judul = _judulController.text;
    final isi = _isiController.text;
    final tanggal = _tanggalController.text;
    final lokasi = _lokasiController.text;
    final instansi = _instansiController.text;
    final kategori = _kategori[_selectedIndex];
    final trackingId = _generateTrackingId();

    if ([judul, isi, tanggal, lokasi, instansi].any((e) => e.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mohon lengkapi semua data laporan')),
      );
      return;
    }

    final laporan = {
      'judul': judul,
      'isi': isi,
      'tanggal': tanggal,
      'lokasi': lokasi,
      'instansi': instansi,
      'kategori': kategori,
      'isAnonim': _isAnonim,
      'status': 'Menunggu',
      'createdAt': Timestamp.now(),
    };

    try {
      await FirebaseFirestore.instance
          .collection('laporan')
          .doc(trackingId)
          .set(laporan);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Laporan berhasil dikirim\nTracking ID: $trackingId'),
        ),
      );

      _judulController.clear();
      _isiController.clear();
      _tanggalController.clear();
      _lokasiController.clear();
      _instansiController.clear();

      setState(() {
        _isAnonim = false;
        _selectedIndex = 0;
      });
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Gagal mengirim laporan')));
    }
  }

  @override
  Widget build(BuildContext context) {
    // Ubah status bar ke light agar kontras dengan background
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/images/background.jpeg',
              fit: BoxFit.cover,
            ),
          ),
          // Scrollable content including SliverAppBar
          CustomScrollView(
            slivers: [
              SliverAppBar(
                elevation: 0,
                pinned: false,
                floating: false,
                snap: false,
                backgroundColor: Colors.transparent,
                expandedHeight: 56,
                centerTitle: true,
                title: const Text(
                  'FORMULIR LAPORAN',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          color: Colors.red,
                          child: const Text(
                            "Sampaikan Laporan Anda",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          "Klasifikasi Laporan",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: List.generate(_kategori.length, (index) {
                            return Expanded(
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                ),
                                child: TextButton(
                                  onPressed: () {
                                    setState(() {
                                      _selectedIndex = index;
                                    });
                                  },
                                  style: TextButton.styleFrom(
                                    backgroundColor:
                                        _selectedIndex == index
                                            ? Colors.red
                                            : Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4),
                                      side: const BorderSide(color: Colors.red),
                                    ),
                                  ),
                                  child: Text(
                                    _kategori[index],
                                    style: TextStyle(
                                      color:
                                          _selectedIndex == index
                                              ? Colors.white
                                              : Colors.red,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(
                          _judulController,
                          "Ketik judul laporan",
                        ),
                        const SizedBox(height: 12),
                        _buildTextField(
                          _isiController,
                          "Ketik isi laporan",
                          maxLines: 6,
                        ),
                        const SizedBox(height: 12),
                        _buildTextField(
                          _tanggalController,
                          "Pilih tanggal kejadian",
                        ),
                        const SizedBox(height: 12),
                        _buildTextField(
                          _lokasiController,
                          "Ketik lokasi kejadian",
                        ),
                        const SizedBox(height: 12),
                        _buildTextField(
                          _instansiController,
                          "Ketik instansi tujuan",
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: _pickImage,
                              child: Row(
                                children: const [
                                  Icon(
                                    Icons.insert_drive_file_outlined,
                                    color: Colors.lightBlue,
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    'Upload Bukti (opsional)',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                Checkbox(
                                  value: _isAnonim,
                                  activeColor: Colors.red,
                                  onChanged: (val) {
                                    setState(() {
                                      _isAnonim = val!;
                                    });
                                  },
                                ),
                                const Text("Anonim"),
                              ],
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 10,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: _submitLaporan,
                              child: const Text(
                                'KIRIM',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String hintText, {
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hintText,
        border: const OutlineInputBorder(),
        fillColor: Colors.white,
        filled: true,
      ),
    );
  }
}
