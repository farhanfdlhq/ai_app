import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ai_app/providers/content_provider.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final contentProvider = Provider.of<ContentProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Hasil Konten"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: contentProvider.isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Text(
                  contentProvider.generatedContent.isNotEmpty
                      ? contentProvider.generatedContent
                      : "Konten tidak tersedia.",
                  style: const TextStyle(fontSize: 16),
                ),
              ),
      ),
    );
  }
}
