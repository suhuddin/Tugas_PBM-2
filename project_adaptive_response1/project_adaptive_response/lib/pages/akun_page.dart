import 'package:flutter/material.dart';
import '../main.dart';

class AkunPage extends StatefulWidget {
  const AkunPage({super.key});

  @override
  State<AkunPage> createState() => _AkunPageState();
}

class _AkunPageState extends State<AkunPage> {
  bool _isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    final parentState = context.findAncestorStateOfType<MyAppState>();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Nama: Budi Santoso'),
          const Text('NIM: 123456789'),
          const Text('Email: budi@example.com'),
          const SizedBox(height: 20),
          Row(
            children: [
              const Text('Dark Mode'),
              Switch(
                value: _isDarkMode,
                onChanged: (val) {
                  setState(() {
                    _isDarkMode = val;
                    parentState?.toggleTheme(val);
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
