import 'dart:async';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pedometer/pedometer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _steps = 0;
  int? _initialSteps;
  StreamSubscription<StepCount>? _subscription;
  bool _permissionGranted = false;

  @override
  void initState() {
    super.initState();
    _loadOffset();
  }

  Future<void> _loadOffset() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _initialSteps = prefs.getInt('initialSteps');
    });
  }

  Future<void> _saveOffset() async {
    final prefs = await SharedPreferences.getInstance();
    if (_initialSteps != null) {
      await prefs.setInt('initialSteps', _initialSteps!);
    }
  }

  Future<void> _startCounting() async {
    final status = await Permission.activityRecognition.request();
    if (status.isGranted) {
      setState(() {
        _permissionGranted = true;
      });

      _subscription = Pedometer.stepCountStream.listen(
        (StepCount event) {
          if (_initialSteps == null) {
            _initialSteps = event.steps;
            _saveOffset();
          }
          setState(() {
            _steps = event.steps - _initialSteps!;
          });
        },
        onError: (error) {
          debugPrint('Error: $error');
        },
      );
    } else {
      setState(() {
        _permissionGranted = false;
      });
    }
  }

  Future<void> _resetOffset() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('initialSteps');
    setState(() {
      _initialSteps = null;
      _steps = 0;
    });
    _subscription?.cancel();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perhitungan Langkah'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Jumlah Langkah:',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Text(
              '$_steps',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _startCounting,
              child: const Text('Mulai Hitung Langkah'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _resetOffset,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
              ),
              child: const Text('Reset Langkah'),
            ),
            if (!_permissionGranted)
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Izin belum diberikan',
                  style: TextStyle(color: Colors.red),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
