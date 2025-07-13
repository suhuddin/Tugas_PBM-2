import 'package:flutter/material.dart';
import 'first_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Palindrome App',
      theme: ThemeData(
        primarySwatch: Colors.blue, // Bisa disesuaikan jika ingin warna tema berbeda
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white, // Default AppBar background
          foregroundColor: Colors.black, // Default AppBar text color
          elevation: 0, // No shadow for app bars
        ),
        scaffoldBackgroundColor: Colors.white, // Default background for all screens
      ),
      home: const FirstScreen(),
    );
  }
}