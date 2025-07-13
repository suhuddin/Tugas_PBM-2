import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const LangkahApp());
}

class LangkahApp extends StatelessWidget {
  const LangkahApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Perhitungan Langkah',
      home: HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
