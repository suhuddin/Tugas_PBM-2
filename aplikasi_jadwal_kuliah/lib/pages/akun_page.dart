import 'package:flutter/material.dart';

class AkunPage extends StatefulWidget {
  final void Function(bool isDark)? onThemeChanged;

  const AkunPage({super.key, this.onThemeChanged});

  @override
  State<AkunPage> createState() => _AkunPageState();
}

class _AkunPageState extends State<AkunPage> {
  bool _isDarkMode = false;

  String _nama = 'Muhamad Suhuddin Jaballul karim';
  String _npm = '4522210119';
  String _email = '4522210119@univpancasila.ac.id';

  void _editData(String label, String initialValue, Function(String) onSave) {
    String tempValue = initialValue;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit $label'),
        content: TextField(
          autofocus: true,
          decoration: InputDecoration(
            labelText: label,
            border: const OutlineInputBorder(),
          ),
          controller: TextEditingController(text: initialValue),
          onChanged: (value) => tempValue = value,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
          ElevatedButton(
            onPressed: () {
              onSave(tempValue);
              Navigator.pop(context);
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = _isDarkMode ? Colors.black : Colors.white;
    final cardColor = _isDarkMode ? Colors.grey[900] : Colors.grey[100];
    final textColor = _isDarkMode ? Colors.white : Colors.black;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text('Profil Mahasiswa'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.black,
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Foto Profil
                  const CircleAvatar(
                    radius: 60,
                    backgroundImage: AssetImage('assets/images/foto_profil.jpg'),
                  ),
                  const SizedBox(height: 16),

                  // Nama Tengah
                  Text(
                    _nama,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Data Mahasiswa
                  Card(
                    elevation: 3,
                    color: cardColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        _buildInfoTile('NPM', _npm, (val) => setState(() => _npm = val)),
                        const Divider(height: 0),
                        _buildInfoTile('Email', _email, (val) => setState(() => _email = val)),
                        const Divider(height: 0),
                        _buildInfoTile('Nama', _nama, (val) => setState(() => _nama = val)),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Toggle Mode Gelap
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Mode Gelap', style: TextStyle(fontSize: 16, color: textColor)),
                        Switch(
                          activeColor: Colors.teal,
                          value: _isDarkMode,
                          onChanged: (value) {
                            setState(() => _isDarkMode = value);
                            widget.onThemeChanged?.call(value);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoTile(String label, String value, Function(String) onSave) {
    return ListTile(
      title: Text('$label:', style: const TextStyle(fontWeight: FontWeight.w500)),
      subtitle: Text(value),
      trailing: IconButton(
        icon: const Icon(Icons.edit, color: Colors.teal),
        onPressed: () => _editData(label, value, onSave),
      ),
    );
  }
}
