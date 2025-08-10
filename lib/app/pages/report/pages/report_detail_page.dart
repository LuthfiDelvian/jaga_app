import 'dart:io' as io show File;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:url_launcher/url_launcher.dart';

class ReportDetailPage extends StatelessWidget {
  final String documentId;

  const ReportDetailPage({super.key, required this.documentId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: const Text(
          'Detail Laporan',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future:
            FirebaseFirestore.instance
                .collection('laporan')
                .doc(documentId)
                .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('Laporan tidak ditemukan.'));
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;
          final judul = data['judul'] ?? '-';
          final isi = data['isi'] ?? '-';
          final lokasi = data['lokasi'] ?? '-';
          final tanggal = data['tanggal'] ?? '-';
          final kategori = data['kategori'] ?? '-';
          final status = data['status'] ?? 'Menunggu';
          final createdAt = (data['createdAt'] as Timestamp?)?.toDate();
          final bukti = List<Map<String, dynamic>>.from(data['bukti'] ?? []);
          final formattedCreatedAt =
              createdAt != null
                  ? DateFormat('dd MMM yyyy, HH:mm').format(createdAt)
                  : '-';

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text(
                            'ID Laporan',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const Spacer(),
                          Expanded(child: Text(documentId)),
                          IconButton(
                            icon: const Icon(Icons.copy, size: 18),
                            onPressed: () {
                              Clipboard.setData(
                                ClipboardData(text: documentId),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Tracking ID disalin'),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          Text(
                            'Waktu Laporan',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                          const Spacer(),
                          Text(formattedCreatedAt),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                _buildCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Status laporan',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Text(
                            status,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: _getStatusColor(status),
                              fontSize: 16,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            formattedCreatedAt,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                _buildCard(
                  child: Text(
                    judul,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: _buildCard(
                        child: Row(
                          children: [
                            Expanded(child: Text(kategori)),
                            const SizedBox(width: 8),
                            const Icon(Icons.category),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildCard(
                        child: Row(
                          children: [
                            Expanded(child: Text(tanggal)),
                            const SizedBox(width: 8),
                            const Icon(Icons.calendar_today, size: 18),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                _buildCard(
                  child: Row(
                    children: [
                      Expanded(child: Text(lokasi)),
                      const SizedBox(width: 8),
                      const Icon(Icons.location_on),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                _buildCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Isi Laporan',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(isi),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                if (bukti.isNotEmpty)
                  _buildCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Bukti Unggahan',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: bukti.length,
                          itemBuilder: (context, index) {
                            final file = bukti[index];
                            final url = file['url'] ?? '';
                            final name = file['name'] ?? 'File';
                            final type = (file['type'] ?? '').toLowerCase();
                            final isImage = [
                              'jpg',
                              'jpeg',
                              'png',
                              'webp',
                            ].contains(type);

                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 6),
                              child:
                                  isImage
                                      ? GestureDetector(
                                        onTap:
                                            () => showDialog(
                                              context: context,
                                              builder:
                                                  (_) => Dialog(
                                                    child: InteractiveViewer(
                                                      child: Image.network(url),
                                                    ),
                                                  ),
                                            ),
                                        child: Row(
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                              child: Image.network(
                                                url,
                                                width: 50,
                                                height: 50,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            Expanded(
                                              child: Text(
                                                name,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  decoration:
                                                      TextDecoration.underline,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                      : GestureDetector(
                                        onTap: () async {
                                          if (kIsWeb) {
                                            // Untuk Flutter Web: buka file di tab baru
                                            final uri = Uri.parse(url);
                                            if (await canLaunchUrl(uri)) {
                                              await launchUrl(
                                                uri,
                                                mode:
                                                    LaunchMode
                                                        .externalApplication,
                                              );
                                            } else {
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                    'Gagal membuka file di browser',
                                                  ),
                                                ),
                                              );
                                            }
                                          } else {
                                            try {
                                              final response = await http.get(
                                                Uri.parse(url),
                                              );
                                              final bytes = response.bodyBytes;

                                              final tempDir =
                                                  await getTemporaryDirectory();
                                              final filePath = path.join(
                                                tempDir.path,
                                                name,
                                              );
                                              final fileOut = io.File(filePath);
                                              await fileOut.writeAsBytes(bytes);

                                              final result =
                                                  await OpenFile.open(filePath);
                                              if (result.type !=
                                                  ResultType.done) {
                                                ScaffoldMessenger.of(
                                                  context,
                                                ).showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                      'Gagal membuka file: ${result.message}',
                                                    ),
                                                  ),
                                                );
                                              }
                                            } catch (e) {
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    'Gagal mengunduh file: $e',
                                                  ),
                                                ),
                                              );
                                            }
                                          }
                                        },

                                        child: Row(
                                          children: [
                                            const Icon(
                                              Icons.insert_drive_file,
                                              color: Colors.grey,
                                            ),
                                            const SizedBox(width: 10),
                                            Expanded(
                                              child: Text(
                                                name,
                                                style: const TextStyle(
                                                  decoration:
                                                      TextDecoration.underline,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey[300]!,
          width: 1,
        ),
      ),
      child: child,
    );
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
}
