import 'package:flutter/material.dart';

class JadwalPage extends StatelessWidget {
  const JadwalPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> jadwal = [
      {'hari': 'Senin', 'matkul': 'Pemrograman Berbasis Mobile', 'jam': '08:00-10:30'},
      {'hari': 'Senin', 'matkul': 'E-Business', 'jam': '10:30-13:00'},
      {'hari': 'Selasa', 'matkul': 'Metodologi Penelitian', 'jam': '11:21-13:50'},
      {'hari': 'Selasa', 'matkul': 'Prak. Pemrograman Berbasis Mobile', 'jam': '13:50-16:20'},
      {'hari': 'Rabu', 'matkul': 'Manajemen Proyek', 'jam': '09:40-12:10'},
      {'hari': 'Kamis', 'matkul': 'Enterprise Software Engineering', 'jam': '10:30-13:00'},
      {'hari': 'Jumat', 'matkul': 'Data Mining', 'jam': '09:41-11:20'},
    ];

    // Function to determine color for each day
    Color getDayColor(String day) {
      switch (day) {
        case 'Senin':
          return const Color.fromARGB(255, 240, 240, 240);
        case 'Selasa':
          return const Color.fromARGB(255, 251, 252, 252);
        case 'Rabu':
          return const Color.fromARGB(255, 243, 243, 243);
        case 'Kamis':
          return const Color.fromARGB(255, 253, 251, 253);
        case 'Jumat':
          return const Color.fromARGB(255, 255, 255, 255);
        default:
          return Colors.grey;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Jadwal Kuliah'),
        backgroundColor: Colors.teal,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: jadwal.length,
        itemBuilder: (context, index) {
          final item = jadwal[index];
          final day = item['hari']!;
          final subject = item['matkul']!;
          final time = item['jam']!;
          
          return Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 5,
            margin: const EdgeInsets.symmetric(vertical: 6),
            child: ListTile(
              contentPadding: const EdgeInsets.all(12),
              tileColor: getDayColor(day).withOpacity(0.1),
              title: Text(
                '$subject',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              subtitle: Text(
                '$day\n$time',
                style: const TextStyle(fontSize: 14),
              ),
              isThreeLine: true,
            ),
          );
        },
      ),
    );
  }
}
