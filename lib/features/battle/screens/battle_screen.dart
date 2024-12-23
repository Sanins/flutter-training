import 'package:flutter/material.dart';

class BattlePage extends StatefulWidget {
  const BattlePage({super.key});

  @override
  _BattlePageState createState() => _BattlePageState();
}

class _BattlePageState extends State<BattlePage> {
  int _health = 100;

  // Method to handle the attack action
  void _attack() {
    setState(() {
      if (_health > 0) {
        _health -= 25; // Decrease health by 25
        if (_health < 0) {
          _health = 0; // Ensure health doesn't go below 0
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Battle Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Health: $_health HP',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _attack,
              child: const Text('Attack'),
            ),
          ],
        ),
      ),
    );
  }
}
