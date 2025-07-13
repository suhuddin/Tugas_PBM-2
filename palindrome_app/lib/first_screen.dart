import 'package:flutter/material.dart';
import 'second_screen.dart';

class FirstScreen extends StatefulWidget {
  const FirstScreen({super.key});

  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _sentenceController = TextEditingController();

  bool _isPalindrome(String text) {
    final cleanText = text.toLowerCase().replaceAll(' ', '');
    return cleanText == cleanText.split('').reversed.join('');
  }

  void _checkPalindrome() {
    final sentence = _sentenceController.text;
    final bool palindrome = _isPalindrome(sentence);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Palindrome Check'),
          content: Text(palindrome ? 'isPalindrome' : 'not palindrome'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // Ganti BoxDecoration sebelumnya dengan ini
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/Background.png'), // Path ke gambar Anda
            fit: BoxFit.cover, // Menyesuaikan gambar agar mengisi seluruh area
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Circle Avatar dengan ikon orang
              const CircleAvatar(
                radius: 60,
                backgroundColor: Color(0x66ADD8E6), // Warna biru muda transparan
                child: Icon(
                  Icons.person,
                  size: 60,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 50),
              // Input Nama
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: 'Name', // Placeholder text
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide.none, // No border
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                ),
              ),
              const SizedBox(height: 20),
              // Input Kalimat
              TextField(
                controller: _sentenceController,
                decoration: InputDecoration(
                  hintText: 'Palindrome', // Placeholder text
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide.none, // No border
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                ),
              ),
              const SizedBox(height: 40),
              // Tombol Check
              ElevatedButton(
                onPressed: _checkPalindrome,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: const Color(0xFF2B637B), // Warna tombol putih
                  foregroundColor: Colors.white, // Warna teks teal
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  elevation: 0, // No shadow
                ),
                child: const Text(
                  'CHECK',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 15),
              // Tombol Next
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SecondScreen(
                        name: _nameController.text,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: const Color(0xFF2B637B), // Warna tombol putih
                  foregroundColor: Colors.white, // Warna teks teal
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  elevation: 0, // No shadow
                ),
                child: const Text(
                  'NEXT',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}