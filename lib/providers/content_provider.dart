import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logger/logger.dart';
import 'dart:convert'; // Import untuk JSON encoding/decoding

class ContentProvider with ChangeNotifier {
  final Logger _logger = Logger();

  String _generatedContent = "";
  List<Map<String, String>> _history =
      []; // Menyimpan topik, kategori, dan konten
  bool _isLoading = false;

  String get generatedContent => _generatedContent;
  List<Map<String, String>> get history => List.unmodifiable(_history);
  bool get isLoading => _isLoading;

  ContentProvider() {
    Gemini.init(
      apiKey: "AIzaSyC78BId2lh074eXd7oJFw5Ch63k2nrLKB4",
      enableDebugging: true,
    );
    loadHistory(); // Load history saat ContentProvider diinisialisasi
  }

  // Fungsi untuk Generate Konten
  Future<void> generateContent(String topicWithCategory) async {
    _isLoading = true;
    notifyListeners();

    // Pisahkan kategori dan topik dari parameter
    final splitIndex = topicWithCategory.indexOf('- Kategori:');
    String topic = splitIndex != -1
        ? topicWithCategory.substring(0, splitIndex).trim()
        : topicWithCategory.trim();
    String category = splitIndex != -1
        ? topicWithCategory.substring(splitIndex + 10).trim()
        : "Tanpa Kategori";

    try {
      // Panggil API Gemini untuk menghasilkan konten
      final response = await Gemini.instance.prompt(
        parts: [
          Part.text(
              "Buatkan konten pendek dengan kategori '$category' tentang: $topic"),
        ],
      );

      _logger.d("Response: ${response?.output}");

      if (response != null &&
          response.output != null &&
          response.output!.isNotEmpty) {
        _generatedContent = response.output!;
      } else {
        _generatedContent = "Konten tidak dapat dihasilkan. Respons kosong.";
      }

      // Simpan ke history dan local storage
      await _addToHistory(topic, category, _generatedContent);

      // Muat ulang history setelah data ditambahkan
      await loadHistory();
    } catch (e) {
      _generatedContent = "Terjadi kesalahan: $e";
      _logger.e("Error saat generate konten: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Fungsi menambah history
  Future<void> _addToHistory(
      String topic, String category, String content) async {
    _history.add({
      'topic': topic,
      'category': category,
      'content': content,
    });

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        'content_history', jsonEncode(_history)); // Encode list sebagai JSON
    _logger.d("History disimpan: $_history");
  }

  // Fungsi memuat history dari local storage
  Future<void> loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final String? historyJson = prefs.getString('content_history');

    if (historyJson != null) {
      final List<dynamic> historyList = jsonDecode(historyJson);
      _history =
          historyList.map((item) => Map<String, String>.from(item)).toList();
      _logger.d("Riwayat dimuat: $_history");
    }

    notifyListeners();
  }
}
