import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Map<String, dynamic>> _activities = [
    {'name': 'Belajar Flutter', 'date': '6 Mei 2025', 'done': false},
    {'name': 'Rapat BEM', 'date': '7 Mei 2025', 'done': false},
    {'name': 'Presentasi Proyek', 'date': '8 Mei 2025', 'done': false},
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _activities.length,
      itemBuilder: (context, index) {
        final activity = _activities[index];
        return CheckboxListTile(
          title: Text(activity['name']),
          subtitle: Text(activity['date']),
          value: activity['done'],
          onChanged: (value) {
            setState(() {
              activity['done'] = value!;
            });
          },
        );
      },
    );
  }
}
