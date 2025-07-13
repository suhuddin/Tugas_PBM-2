import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

void main() => runApp(const XylophoneApp());

class XylophoneApp extends StatelessWidget {
  const XylophoneApp({super.key});

  void playSound(int soundNumber) {
    final player = AudioPlayer();
    player.play(AssetSource('note$soundNumber.wav'));
  }

  Expanded buildKey({required int soundNumber, required Color buttonColor}) {
    return Expanded(
        child: TextButton(
          style: TextButton.styleFrom(
            backgroundColor: buttonColor,
          ),
          onPressed: () {
            playSound(soundNumber);
          },
          child: Text('soundNumber: $soundNumber'),
        )
    );
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              buildKey(soundNumber: 1, buttonColor: Colors.red),
              buildKey(soundNumber: 2, buttonColor: Colors.orange),
              buildKey(soundNumber: 3, buttonColor: Colors.yellow),
              buildKey(soundNumber: 4, buttonColor: Colors.green),
              buildKey(soundNumber: 5, buttonColor: Colors.teal),
              buildKey(soundNumber: 6, buttonColor: Colors.blue),
              buildKey(soundNumber: 7, buttonColor: Colors.purple),
            ],
          ),
        ),
      ),
    );
  }
}
