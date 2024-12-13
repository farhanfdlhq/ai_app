import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ai_app/screens/home_screen.dart';
import 'package:ai_app/providers/content_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ContentProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AI Penulisan Konten Cepat',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(),
    );
  }
}
