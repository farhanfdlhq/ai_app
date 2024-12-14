import 'package:flutter/material.dart';

class DetailScreen extends StatelessWidget {
  final String topic; // Judul artikel
  final String category; // Kategori artikel
  final String content; // Konten artikel

  const DetailScreen({
    super.key,
    required this.topic,
    required this.category,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          topic, // Menampilkan judul di AppBar
          style: const TextStyle(fontSize: 20),
        ),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Menampilkan Judul Artikel
            Text(
              topic,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),

            // Menampilkan Kategori Artikel
            Text(
              "Kategori: $category",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.blueGrey,
              ),
            ),
            const SizedBox(height: 16),

            // Menampilkan Isi Artikel
            Text(
              content,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
