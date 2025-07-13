import 'package:flutter/material.dart';
import 'database_helper.dart';
//import 'login_page.dart';

class StudentFormPage extends StatefulWidget {
  final Map<String, dynamic>? student;

  const StudentFormPage({super.key, this.student});

  @override
  StudentFormPageState createState() => StudentFormPageState();
}

class StudentFormPageState extends State<StudentFormPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _majorController = TextEditingController();
  final TextEditingController _originController = TextEditingController();

  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  @override
  void initState() {
    super.initState();
    if (widget.student != null) {
      _nameController.text = widget.student!['name']?.toString() ?? '';
      _emailController.text = widget.student!['email']?.toString() ?? '';
      _majorController.text = widget.student!['major']?.toString() ?? '';
      _originController.text = widget.student!['origin']?.toString() ?? '';
    }
  }

  void _saveStudent() async {
  // Validasi form sebelum menyimpan
  if (_formKey.currentState!.validate()) {
    try {
      final Map<String, dynamic> studentData = {
        'name': _nameController.text,
        'email': _emailController.text,
        'major': _majorController.text,
        'origin': _originController.text,
      };

      if (widget.student == null) {
        // Tambah mahasiswa baru
        await _dbHelper.insertStudent(studentData);
      } else {
        // Update mahasiswa yang ada — buat salinan baru yang menyertakan id dengan tipe int
        final updatedStudent = {
          ...studentData,
          'id': widget.student!['id'] as int,
        };
        await _dbHelper.updateStudent(updatedStudent);
      }

      if (mounted) {
        Navigator.pop(context, true); // Kirim 'true' untuk refresh
      }

    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving student: $e')),
        );
      }
    }
  }
}


  @override
  void dispose() {
    // Bersihkan controller saat widget di-dispose
    _nameController.dispose();
    _emailController.dispose();
    _majorController.dispose();
    _originController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.student == null ? 'Tambah Mahasiswa' : 'Edit Mahasiswa'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form( // Gunakan widget Form
          key: _formKey,
          child: ListView( // Gunakan ListView agar bisa di-scroll
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nama', border: OutlineInputBorder()),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder()),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value != null && value.isNotEmpty && !value.contains('@')) {
                    return 'Masukkan email yang valid';
                  }
                  return null; // Email boleh kosong
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _majorController,
                decoration: const InputDecoration(labelText: 'Jurusan', border: OutlineInputBorder()),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Jurusan tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _originController,
                decoration: const InputDecoration(labelText: 'Asal', border: OutlineInputBorder()),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Asal tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _saveStudent,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(widget.student == null ? 'Tambah' : 'Simpan Perubahan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}