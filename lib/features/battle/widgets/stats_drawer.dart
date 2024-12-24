import 'package:flutter/material.dart';

class StatsDrawer extends StatelessWidget {
  final int health;

  const StatsDrawer({Key? key, required this.health}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Stats',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text('Health: $health HP'),
            const SizedBox(height: 20),
            // Add other stats as needed
          ],
        ),
      ),
    );
  }
}
