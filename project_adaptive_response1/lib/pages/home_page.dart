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

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  void _showAddActivityDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Tambah Kegiatan'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Nama Kegiatan',
                prefixIcon: Icon(Icons.edit),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _dateController,
              readOnly: true,
              decoration: const InputDecoration(
                labelText: 'Tanggal',
                prefixIcon: Icon(Icons.calendar_today),
                border: OutlineInputBorder(),
              ),
              onTap: () async {
                final pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2100),
                );
                if (pickedDate != null) {
                  _dateController.text =
                      "${pickedDate.day} ${_bulan(pickedDate.month)} ${pickedDate.year}";
                }
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _nameController.clear();
              _dateController.clear();
            },
            child: const Text('Batal'),
          ),
          ElevatedButton.icon(
            onPressed: () {
              if (_nameController.text.isNotEmpty &&
                  _dateController.text.isNotEmpty) {
                setState(() {
                  _activities.add({
                    'name': _nameController.text,
                    'date': _dateController.text,
                    'done': false,
                  });
                });
              }
              Navigator.of(context).pop();
              _nameController.clear();
              _dateController.clear();
            },
            icon: const Icon(Icons.save),
            label: const Text('Tambah'),
          ),
        ],
      ),
    );
  }

  String _bulan(int month) {
    const bulan = [
      '',
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember'
    ];
    return bulan[month];
  }

  void _confirmDelete(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Konfirmasi Hapus'),
        content: Text(
          'Hapus kegiatan "${_activities[index]['name']}"?',
          style: const TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _activities.removeAt(index);
              });
              Navigator.of(context).pop();
            },
            child: const Text('Ya, Hapus'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('📋 Daftar Kegiatan'),
        backgroundColor: Colors.teal,
      ),
      body: _activities.isEmpty
          ? const Center(
              child: Text(
                'Belum ada kegiatan',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: _activities.length,
              itemBuilder: (context, index) {
                final activity = _activities[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 3,
                  child: CheckboxListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    title: Text(
                      activity['name'],
                      style: const TextStyle(fontSize: 16),
                    ),
                    subtitle: Text(activity['date']),
                    value: activity['done'],
                    secondary: const Icon(Icons.event_note),
                    onChanged: (value) {
                      if (value == true) _confirmDelete(index);
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddActivityDialog,
        backgroundColor: Colors.teal,
        child: const Icon(Icons.add),
      ),
    );
  }
}
