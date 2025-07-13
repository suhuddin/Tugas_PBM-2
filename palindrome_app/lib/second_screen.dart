import 'package:flutter/material.dart';
import 'third_screen.dart';

class SecondScreen extends StatefulWidget {
  final String name;
  final ValueNotifier<String> selectedUserName;

  SecondScreen({
    super.key,
    required this.name,
    ValueNotifier<String>? selectedUserName,
  }) : selectedUserName = selectedUserName ?? ValueNotifier<String>('Selected User Name');

  @override
  State<SecondScreen> createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios), // Ikon panah ke kiri
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Second Screen', 
          style: TextStyle(fontWeight: FontWeight.bold),),
        centerTitle: true, // Judul di tengah
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween, // Untuk menempatkan tombol di bawah
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Welcome',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
                ),
                const SizedBox(height: 5),
                Text(
                  widget.name.isEmpty ? 'Guest' : widget.name,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 80), // Jarak ke label selanjutnya
                Center( // Pusatkan label "Selected User Name"
                  child: ValueListenableBuilder<String>(
                    valueListenable: widget.selectedUserName,
                    builder: (context, value, child) {
                      return Text(
                        value, // Langsung tampilkan nilai
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      );
                    },
                  ),
                ),
              ],
            ),
            // Tombol "Choose a User" di bagian bawah
            ElevatedButton(
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ThirdScreen(
                      selectedUserNameNotifier: widget.selectedUserName,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: const Color(0xFF23607E), // Warna tombol biru tua
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              child: const Text(
                'Choose a User',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}