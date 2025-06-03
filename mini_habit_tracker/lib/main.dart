import 'dart:convert'; // Untuk jsonDecode
import 'dart:math'; // Untuk 'max' dalam ID generation
import 'package:flutter/material.dart';

// Model untuk kebiasaan
class Habit {
  final int id; // Tetap final karena ID idealnya tidak berubah setelah dibuat
  String name; // Bisa diubah (untuk edit)
  String description; // Bisa diubah (untuk edit)
  bool isDone;

  Habit({
    required this.id,
    required this.name,
    required this.description,
    this.isDone = false,
  });

  // Factory constructor untuk membuat instance Habit dari JSON
  factory Habit.fromJson(Map<String, dynamic> json) {
    return Habit(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String,
      // isDone tidak ada di JSON awal, defaultnya false
    );
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Habit Tracker Mini',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal, brightness: Brightness.light),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal, brightness: Brightness.dark),
      ),
      home: const MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Habit> _habits = [];
  bool _isLoading = true;
  bool _isDarkMode = false;

  // GlobalKey untuk Form di dalam Dialog
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _loadHabits();
  }

  Future<void> _loadHabits() async {
    try {
      final String response =
      await DefaultAssetBundle.of(context).loadString('assets/habits.json');
      final List<dynamic> data = jsonDecode(response) as List<dynamic>;

      if (!mounted) return;

      setState(() {
        _habits = data.map((jsonItem) => Habit.fromJson(jsonItem as Map<String, dynamic>)).toList();
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading habits: $e'); // Untuk debug praktikum
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memuat data kebiasaan: $e')),
      );
    }
  }

  void _toggleHabitStatus(int index, bool? value) {
    if (value != null) {
      setState(() {
        _habits[index].isDone = value;
      });
    }
  }

  String _calculateProgress() {
    if (_habits.isEmpty) {
      return "0/0";
    }
    int doneCount = _habits.where((habit) => habit.isDone).length;
    return "$doneCount/${_habits.length} habits";
  }

  void _resetHabits() {
    setState(() {
      for (var habit in _habits) {
        habit.isDone = false;
      }
    });
  }

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  // Fungsi untuk menghasilkan ID unik baru
  int _getNewHabitId() {
    if (_habits.isEmpty) {
      return 1;
    }
    return _habits.map((h) => h.id).reduce(max) + 1;
  }

  // Fungsi untuk menampilkan dialog Tambah/Edit Habit
  Future<void> _showHabitDialog({Habit? habit, int? index}) async {
    final TextEditingController nameController = TextEditingController(text: habit?.name ?? '');
    final TextEditingController descriptionController = TextEditingController(text: habit?.description ?? '');
    final bool isEditing = habit != null;

    return showDialog<void>(
      context: context,
      barrierDismissible: false, // Pengguna harus menekan tombol
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(isEditing ? 'Edit Habit' : 'Tambah Habit Baru'),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Nama Habit',
                      hintText: 'Contoh: Baca Buku',
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Nama habit tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Deskripsi (Opsional)',
                      hintText: 'Contoh: Baca minimal 1 bab',
                    ),
                    maxLines: 2,
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Batal'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            ElevatedButton(
              child: Text(isEditing ? 'Simpan' : 'Tambah'),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  final String name = nameController.text.trim();
                  final String description = descriptionController.text.trim();

                  setState(() {
                    if (isEditing && index != null) {
                      // Edit Habit
                      _habits[index].name = name;
                      _habits[index].description = description;
                    } else {
                      // Tambah Habit Baru
                      _habits.add(Habit(
                        id: _getNewHabitId(),
                        name: name,
                        description: description,
                      ));
                    }
                  });
                  Navigator.of(dialogContext).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  // Fungsi untuk menghapus habit
  void _deleteHabit(int index) {
    // Konfirmasi sebelum menghapus
    showDialog(
        context: context,
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            title: const Text('Hapus Habit'),
            content: Text('Apakah Anda yakin ingin menghapus habit "${_habits[index].name}"?'),
            actions: <Widget>[
              TextButton(
                child: const Text('Batal'),
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                },
              ),
              TextButton(
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('Hapus'),
                onPressed: () {
                  setState(() {
                    _habits.removeAt(index);
                  });
                  Navigator.of(dialogContext).pop();
                },
              ),
            ],
          );
        });
  }


  @override
  Widget build(BuildContext context) {
    final Color scaffoldBackgroundColor = _isDarkMode ? Colors.grey[850]! : Colors.grey[50]!;
    final Color appBarColor = _isDarkMode ? Colors.grey[900]! : Colors.teal;
    final Color cardColor = _isDarkMode ? Colors.grey[800]! : Colors.white;
    final Color textColor = _isDarkMode ? Colors.white : Colors.black;
    final Color accentColor = _isDarkMode ? Colors.tealAccent[400]! : Colors.teal;
    final Color subtleTextColor = _isDarkMode ? Colors.grey[400]! : Colors.grey[600]!;


    return Scaffold(
      backgroundColor: scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          _isLoading ? 'Memuat Habits...' : 'Progres: ${_calculateProgress()}',
          style: TextStyle(color: _isDarkMode ? Colors.white : Colors.white),
        ),
        backgroundColor: appBarColor,
        iconTheme: IconThemeData(color: _isDarkMode ? Colors.white : Colors.white),
        actions: [
          IconButton(
            icon: Icon(Icons.add, color: _isDarkMode ? Colors.white : Colors.white),
            onPressed: () {
              _showHabitDialog(); // Panggil dialog untuk menambah habit baru
            },
            tooltip: 'Tambah Habit Baru',
          ),
          IconButton(
            icon: Icon(_isDarkMode ? Icons.light_mode : Icons.dark_mode, color: Colors.white),
            onPressed: _toggleTheme,
            tooltip: 'Ganti Tema',
          )
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: accentColor))
          : _habits.isEmpty
          ? Center(
        child: Text(
          'Tidak ada habit.\nYuk, tambahkan habit baru!',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18, color: subtleTextColor),
        ),
      )
          : ListView.builder(
        itemCount: _habits.length,
        itemBuilder: (context, index) {
          final habit = _habits[index];
          print('build ${habit.name}'); // Debug print sesuai permintaan
          return Card(
            color: cardColor,
            margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: accentColor,
                child: Text((index + 1).toString(), style: TextStyle(color: _isDarkMode ? Colors.black : Colors.white)),
              ),
              title: Text(
                habit.name,
                style: TextStyle(
                  color: textColor,
                  // Fitur 1: Coret teks jika habit.isDone true
                  decoration: habit.isDone ? TextDecoration.lineThrough : null,
                  decorationColor: habit.isDone ? textColor.withAlpha((255 * 0.6).round()) : null,
                  decorationThickness: 2.0,
                ),
              ),
              subtitle: Text(
                habit.description.isNotEmpty ? habit.description : 'Tidak ada deskripsi',
                style: TextStyle(
                  color: habit.isDone ? subtleTextColor.withAlpha((255*0.7).round()) : subtleTextColor,
                  // Fitur 1 (opsional): Coret juga deskripsi jika habit.isDone true
                  decoration: habit.isDone ? TextDecoration.lineThrough : null,
                  decorationColor: habit.isDone ? subtleTextColor.withAlpha((255 * 0.6).round()) : null,
                ),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Checkbox(
                    value: habit.isDone,
                    onChanged: (bool? value) {
                      _toggleHabitStatus(index, value);
                    },
                    activeColor: accentColor,
                    checkColor: cardColor,
                    side: BorderSide(color: _isDarkMode ? Colors.white54 : Colors.black54),
                  ),
                  PopupMenuButton<String>(
                    icon: Icon(Icons.more_vert, color: subtleTextColor),
                    onSelected: (String value) {
                      if (value == 'edit') {
                        _showHabitDialog(habit: habit, index: index);
                      } else if (value == 'delete') {
                        _deleteHabit(index);
                      }
                    },
                    itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                      const PopupMenuItem<String>(
                        value: 'edit',
                        child: ListTile(
                          leading: Icon(Icons.edit),
                          title: Text('Edit'),
                        ),
                      ),
                      const PopupMenuItem<String>(
                        value: 'delete',
                        child: ListTile(
                          leading: Icon(Icons.delete, color: Colors.red),
                          title: Text('Hapus', style: TextStyle(color: Colors.red)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              onTap: () {
                _toggleHabitStatus(index, !habit.isDone);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _resetHabits,
        tooltip: 'Reset Semua Centang',
        backgroundColor: accentColor,
        foregroundColor: _isDarkMode ? Colors.black : Colors.white,
        child: const Icon(Icons.refresh),
      ),
    );
  }
}