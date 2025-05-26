import 'package:flutter/material.dart';

class FormPage extends StatefulWidget {
  const FormPage({super.key});

  @override
  _FormPageState createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  bool _isAnonim = false;
  int _selectedIndex = 0;
  final List<String> _kategori = ['PENGADUAN', 'ASPIRASI', 'PENYUAPAN'];

  void _pickImage() {
    // Simulasi aksi pilih gambar
    print("Pilih gambar diklik");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4)),
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
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                "Klasifikasi Laporan",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              Row(
                children: List.generate(_kategori.length, (index) {
                  return Expanded(
                    child: Container(
                      margin: EdgeInsets.only(
                          left: index == 0 ? 0 : 4,
                          right: index == _kategori.length - 1 ? 0 : 4),
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            _selectedIndex = index;
                          });
                        },
                        style: TextButton.styleFrom(
                          backgroundColor:
                              _selectedIndex == index ? Colors.red : Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                            side: const BorderSide(color: Colors.red),
                          ),
                        ),
                        child: Text(
                          _kategori[index],
                          style: TextStyle(
                            color: _selectedIndex == index ? Colors.white : Colors.red,
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
              TextField(
                decoration: const InputDecoration(
                  hintText: "Ketik judul laporan",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                maxLines: 6,
                decoration: const InputDecoration(
                  hintText: "Ketik isi laporan",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                decoration: const InputDecoration(
                  hintText: "Pilih tanggal kejadian",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                decoration: const InputDecoration(
                  hintText: "Ketik lokasi kejadian",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                decoration: const InputDecoration(
                  hintText: "Ketik instansi tujuan",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: _pickImage,
                    child: Row(
                      children: const [
                        Icon(Icons.insert_drive_file_outlined, color: Colors.lightBlue),
                        SizedBox(width: 4),
                        Text('Upload Bukti (opsional)', style: TextStyle(fontWeight: FontWeight.w500)),
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
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Laporan berhasil dikirim')),
                      );
                    },
                    child: const Text('KIRIM', style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}