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
            // Display Health
            Text(
              'Health: $_health HP',
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 40),
            // Buttons Grid
            GridView.count(
              crossAxisCount: 2, // 2 columns
              shrinkWrap:
                  true, // Let GridView take only as much space as it needs
              mainAxisSpacing: 10, // Spacing between rows
              crossAxisSpacing: 10, // Spacing between columns
              padding: const EdgeInsets.all(16),
              children: [
                ElevatedButton(
                  onPressed: _attack,
                  child: const Text('Attack'),
                ),
                ElevatedButton(
                  onPressed: _defend,
                  child: const Text('Defend'),
                ),
                ElevatedButton(
                  onPressed: _magic,
                  child: const Text('Magic'),
                ),
                ElevatedButton(
                  onPressed: _item,
                  child: const Text('Item'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
