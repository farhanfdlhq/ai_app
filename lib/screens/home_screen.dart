import 'package:ai_app/screens/history_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ai_app/providers/content_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Generator Konten"),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              // Menavigasi ke halaman riwayat
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const HistoryScreen()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Kolom untuk input topik percakapan
            TextField(
              decoration: const InputDecoration(
                labelText: 'Topik Percakapan',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (topic) {
                // Menghasilkan konten saat topik disubmit
                if (topic.isNotEmpty) {
                  Provider.of<ContentProvider>(context, listen: false)
                      .generateContent(topic);
                }
              },
            ),
            const SizedBox(height: 16),
            // Tampilkan konten yang sudah dihasilkan atau loading indicator
            Consumer<ContentProvider>(
              builder: (context, provider, _) {
                if (provider.isLoading) {
                  return const CircularProgressIndicator();
                }

                return Expanded(
                  child: ListView.builder(
                    itemCount: provider.history.length,
                    itemBuilder: (context, index) {
                      final historyItem = provider.history[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        child: ListTile(
                          title: Text(
                            historyItem['topic'] ?? '',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text(
                            historyItem['content'] ?? '',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          onTap: () {
                            // Menampilkan detail percakapan saat item diklik
                            showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: const Text("Detail Konten"),
                                content: SingleChildScrollView(
                                  child: Text(historyItem['content'] ?? ''),
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
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
