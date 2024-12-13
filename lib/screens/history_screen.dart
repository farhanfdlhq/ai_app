import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ai_app/providers/content_provider.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Riwayat Konten"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Consumer<ContentProvider>(
        builder: (context, provider, _) {
          // Cek jika riwayat kosong
          if (provider.history.isEmpty) {
            return const Center(
              child: Text("Belum ada riwayat konten."),
            );
          }

          // Tampilkan list riwayat percakapan
          return ListView.builder(
            itemCount: provider.history.length,
            itemBuilder: (context, index) {
              final historyItem = provider.history[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: ListTile(
                  title: Text(
                    historyItem['topic'] ?? 'Topik tidak ada',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    historyItem['content'] ?? 'Konten tidak ada',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  onTap: () {
                    // Tampilkan detail konten saat item diklik
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text("Detail Konten"),
                        content: SingleChildScrollView(
                          child:
                              Text(historyItem['content'] ?? 'Konten kosong'),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text("Tutup"),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
