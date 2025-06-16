import 'dart:convert';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jaga_app/app/pages/report/form_success_page.dart';

class ReportFormPage extends StatefulWidget {
  const ReportFormPage({super.key});

  @override
  State<ReportFormPage> createState() => _ReportFormPageState();
}

class _ReportFormPageState extends State<ReportFormPage> {
  final _judulController = TextEditingController();
  final _isiController = TextEditingController();
  final _lokasiController = TextEditingController();
  final _tanggalController = TextEditingController();

  bool _isAnonim = false;
  String? _selectedKategori;
  // ignore: unused_field
  DateTime? _selectedDate;

  List<PlatformFile> _pickedFiles = [];
  List<String> _uploadedImageUrls = [];

  final kategoriOptions = ['PENGADUAN', 'ASPIRASI', 'PENYUAPAN'];

  Future<void> _pickTanggal() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2015),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _tanggalController.text = picked.toLocal().toString().split(' ')[0];
      });
    }
  }

  Future<void> _pickFiles() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      withData: true,
    );
    if (result != null) {
      setState(() {
        _pickedFiles = result.files;
      });
    }
  }

  Future<String?> _uploadToCloudinary(
    Uint8List fileBytes,
    String fileName,
  ) async {
    const cloudName = 'dp0iysyni';
    const uploadPreset = 'jaga_reports';

    final url = Uri.parse(
      'https://api.cloudinary.com/v1_1/$cloudName/image/upload',
    );
    final request =
        http.MultipartRequest('POST', url)
          ..fields['upload_preset'] = uploadPreset
          ..fields['public_id'] = fileName
          ..files.add(
            http.MultipartFile.fromBytes('file', fileBytes, filename: fileName),
          );

    final response = await request.send();
    if (response.statusCode == 200) {
      final respStr = await response.stream.bytesToString();
      final jsonResp = json.decode(respStr);
      return jsonResp['secure_url'];
    }
    return null;
  }

  Future<void> _submitReport() async {
    final judul = _judulController.text.trim();
    final isi = _isiController.text.trim();
    final lokasi = _lokasiController.text.trim();
    final tanggal = _tanggalController.text.trim();

    if (judul.isEmpty ||
        isi.isEmpty ||
        lokasi.isEmpty ||
        tanggal.isEmpty ||
        _selectedKategori == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mohon lengkapi semua data')),
      );
      return;
    }

    _uploadedImageUrls.clear();
    for (final file in _pickedFiles) {
      final ext = file.extension?.toLowerCase();
      if (file.bytes != null && ['jpg', 'jpeg', 'png', 'webp'].contains(ext)) {
        final uploadedUrl = await _uploadToCloudinary(file.bytes!, file.name);
        if (uploadedUrl != null) _uploadedImageUrls.add(uploadedUrl);
      }
    }

    final reportId = "JAGA-${DateTime.now().millisecondsSinceEpoch}";
    final data = {
      'id': reportId,
      'judul': judul,
      'isi': isi,
      'lokasi': lokasi,
      'tanggal': tanggal,
      'kategori': _selectedKategori,
      'anonim': _isAnonim,
      'status': 'Menunggu',
      'bukti': _uploadedImageUrls,
      'createdAt': Timestamp.now(),
    };

    await FirebaseFirestore.instance
        .collection('laporan')
        .doc(reportId)
        .set(data);
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const ReportSuccessPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          'assets/images/jaga-icon.png',
          height: 100,
          color: Colors.white,
        ),
        backgroundColor: Colors.red,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Format Laporan',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _buildTextField(_judulController, 'Masukkan judul laporan'),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _selectedKategori,
                      items:
                          kategoriOptions
                              .map(
                                (e) =>
                                    DropdownMenuItem(value: e, child: Text(e)),
                              )
                              .toList(),
                      onChanged:
                          (val) => setState(() => _selectedKategori = val),
                      decoration: const InputDecoration(
                        hintText: 'Kategori laporan',
                        prefixIcon: Icon(Icons.group),
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(child: _buildDateField()),
                ],
              ),
              const SizedBox(height: 10),
              _buildTextField(
                _lokasiController,
                'Lokasi kejadian',
                suffixIcon: Icons.person_pin_circle,
              ),
              const SizedBox(height: 10),
              _buildTextField(
                _isiController,
                'Masukkan isi laporan',
                maxLines: 6,
              ),
              const SizedBox(height: 10),
              DottedBorder(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: _pickFiles,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        alignment: Alignment.center,
                        child: const Text(
                          '+ Unggah Dokumentasi',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                    if (_pickedFiles.isNotEmpty)
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _pickedFiles.length,
                        itemBuilder: (context, index) {
                          final file = _pickedFiles[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.insert_drive_file,
                                  color: Colors.grey,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    file.name,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _pickedFiles.removeAt(index);
                                    });
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitReport,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Kirim',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateField() {
    return TextField(
      controller: _tanggalController,
      readOnly: true,
      onTap: _pickTanggal,
      decoration: const InputDecoration(
        hintText: 'Tanggal kejadian',
        suffixIcon: Icon(Icons.calendar_today),
        border: OutlineInputBorder(),
        isDense: true,
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String hint, {
    int maxLines = 1,
    IconData? suffixIcon,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        suffixIcon: suffixIcon != null ? Icon(suffixIcon) : null,
        border: const OutlineInputBorder(),
        isDense: true,
      ),
    );
  }
}
