import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const TanyaDakuApp());
}

class TanyaDakuApp extends StatelessWidget {
  const TanyaDakuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tanya Daku',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: const HalamanBola(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HalamanBola extends StatelessWidget {
  const HalamanBola({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade900,
        title: const Text(
          "Tanya Daku Apa Saja",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: const Bola(),
      backgroundColor: Colors.blue,
    );
  }
}

class Bola extends StatefulWidget {
  const Bola({super.key});

  @override
  State<Bola> createState() => _BolaState();
}

class _BolaState extends State<Bola> {
  int nomorBola = 1;

  void _acakGambar() {
    setState(() {
      nomorBola = Random().nextInt(5) + 1; // angka 1 sampai 5
    });
  }

  @override
  Widget build(BuildContext context) {
    final double ukuranGambar = MediaQuery.of(context).size.width * 0.6;

    return Center(
      child: TextButton(
        onPressed: _acakGambar,
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
        ),
        child: Image.asset(
          'images/ball$nomorBola.png',
          width: ukuranGambar,
          height: ukuranGambar,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return const Text(
              'Gambar tidak ditemukan!',
              style: TextStyle(color: Colors.white),
            );
          },
        ),
      ),
    );
  }
}
