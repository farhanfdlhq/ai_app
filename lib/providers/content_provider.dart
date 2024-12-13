import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logger/logger.dart';
import 'dart:convert'; // Import untuk JSON encoding/decoding

class ContentProvider with ChangeNotifier {
  final Logger _logger = Logger();

  String _generatedContent = "";
  List<Map<String, String>> _history =
      []; // Menggunakan Map untuk menyimpan topik dan konten
  bool _isLoading = false;

  String get generatedContent => _generatedContent;
  List<Map<String, String>> get history => List.unmodifiable(_history);
  bool get isLoading => _isLoading;

  ContentProvider() {
    Gemini.init(
      apiKey: "AIzaSyC78BId2lh074eXd7oJFw5Ch63k2nrLKB4",
      enableDebugging: true,
    );
    loadHistory(); // Load history when ContentProvider is initialized
  }

  Future<void> generateContent(String topic) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await Gemini.instance.prompt(
        parts: [
          Part.text("Buatkan sebuah konten pendek tentang: $topic"),
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

      // Save to history and local storage
      await _addToHistory(topic, _generatedContent);

      // Reload history after adding data
      await loadHistory();
    } catch (e) {
      _generatedContent = "Terjadi kesalahan: $e";
      _logger.e("Error saat generate konten: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _addToHistory(String topic, String content) async {
    _history.add({'topic': topic, 'content': content});
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        'content_history', jsonEncode(_history)); // Encode list as JSON
    _logger.d("History disimpan: $_history");
  }

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
