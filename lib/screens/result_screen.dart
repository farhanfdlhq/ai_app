import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:ai_app/providers/content_provider.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  // Fungsi untuk membersihkan dan memformat konten
  String cleanContent(String content) {
    // Hapus simbol tidak perlu seperti #, *, dan spasi berlebih
    String cleaned = content
        .replaceAll(RegExp(r'#+\s?'), '') // Hapus tanda # di awal
        .replaceAll('*', '') // Hapus tanda *
        .replaceAll(RegExp(r'\s{2,}'), ' ') // Hapus spasi berlebih
        .trim();

    // Format teks headline menjadi Uppercase dan tebal
    cleaned = cleaned.replaceAllMapped(
      RegExp(r'^(.*?)(?=\n)', multiLine: true),
      (match) => '**${match[0]!.toUpperCase()}**',
    );

    return cleaned;
  }

  @override
  Widget build(BuildContext context) {
    final contentProvider = Provider.of<ContentProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Hasil Konten"),
        backgroundColor: Colors.blueAccent,
        actions: [
          // Tombol untuk menyalin konten ke clipboard
          IconButton(
            icon: const Icon(Icons.copy),
            onPressed: () {
              final content = cleanContent(contentProvider.generatedContent);
              if (content.isNotEmpty) {
                Clipboard.setData(ClipboardData(text: content));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Konten berhasil disalin!"),
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: contentProvider.isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
                ),
              )
            : contentProvider.generatedContent.isNotEmpty
                ? SingleChildScrollView(
                    child: SelectableText(
                      cleanContent(contentProvider.generatedContent),
                      style: const TextStyle(
                        fontSize: 16,
                        height: 1.6, // Menambah jarak antar baris
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                  )
                : const Center(
                    child: Text(
                      "Konten tidak tersedia.",
                      style: TextStyle(fontSize: 16, color: Colors.black54),
                    ),
                  ),
      ),
    );
  }
}
