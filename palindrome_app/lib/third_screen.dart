import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class User {
  final int id;
  final String email;
  final String firstName;
  final String lastName;
  final String avatar;

  User({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.avatar,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      avatar: json['avatar'],
    );
  }
}

class ThirdScreen extends StatefulWidget {
  final ValueNotifier<String> selectedUserNameNotifier;

  const ThirdScreen({super.key, required this.selectedUserNameNotifier});

  @override
  State<ThirdScreen> createState() => _ThirdScreenState();
}

class _ThirdScreenState extends State<ThirdScreen> {
  List<User> _users = [];
  int _currentPage = 1;
  bool _isLoading = false;
  bool _hasMore = true;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _fetchUsers();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          !_isLoading &&
          _hasMore) {
        _loadNextPage();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _fetchUsers({bool isRefresh = false}) async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
      if (isRefresh) {
        _currentPage = 1;
        _users = [];
        _hasMore = true;
      }
    });

    try {
      final response = await http.get(
        Uri.parse('https://reqres.in/api/users?page=$_currentPage&per_page=10'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<User> newUsers = (data['data'] as List)
            .map((userJson) => User.fromJson(userJson))
            .toList();

        setState(() {
          _users.addAll(newUsers);
          _currentPage++;
          _hasMore = data['page'] < data['total_pages'];
        });
      } else {
        throw Exception('Failed to load users');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load users: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadNextPage() async {
    if (_hasMore) {
      await _fetchUsers();
    }
  }

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
          'Third Screen',
          style: TextStyle(fontWeight: FontWeight.bold),),
        centerTitle: true, // Judul di tengah
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: () => _fetchUsers(isRefresh: true),
        child: _users.isEmpty && !_isLoading
            ? const Center(
                child: Text(
                  'No users found. Pull down to refresh.',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              )
            : ListView.builder(
                controller: _scrollController,
                itemCount: _users.length + (_isLoading ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == _users.length) {
                    return const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  final user = _users[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    elevation: 2, // Bayangan lebih halus
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(user.avatar),
                        radius: 28, // Ukuran avatar
                      ),
                      title: Text(
                        '${user.firstName} ${user.lastName}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(user.email),
                      onTap: () {
                        widget.selectedUserNameNotifier.value = '${user.firstName} ${user.lastName}';
                        Navigator.pop(context); // Go back to Second Screen
                      },
                    ),
                  );
                },
              ),
      ),
    );
  }
}