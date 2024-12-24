import 'package:flutter/material.dart';

class BossDetailsDrawer extends StatelessWidget {
  const BossDetailsDrawer(
      {super.key}); // Mark constructor as const and use super.key

  @override
  Widget build(BuildContext context) {
    return const Drawer(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Boss Details',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text('Name: Evil Dragon'),
            const SizedBox(height: 10),
            const Text('Health: 5000 HP'),
            const SizedBox(height: 10),
            const Text('Attack: Fire Breath'),
            const SizedBox(height: 10),
            const Text('Weakness: Ice Magic'),
            // Add more details as needed
          ],
        ),
      ),
    );
  }
}
