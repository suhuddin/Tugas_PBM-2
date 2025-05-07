import 'package:flutter/material.dart';

class JadwalPage extends StatelessWidget {
  const JadwalPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> jadwal = [
      {'hari': 'Senin', 'matkul': 'Matematika'},
      {'hari': 'Selasa', 'matkul': 'Pemrograman'},
      {'hari': 'Rabu', 'matkul': 'Basis Data'},
      {'hari': 'Kamis', 'matkul': 'Jaringan Komputer'},
      {'hari': 'Jumat', 'matkul': 'Sistem Operasi'},
    ];

    return ListView(
      padding: const EdgeInsets.all(8),
      children: jadwal
          .map((item) => Card(
                child: ListTile(
                  title: Text(item['hari']!),
                  subtitle: Text(item['matkul']!),
                ),
              ))
          .toList(),
    );
  }
}
