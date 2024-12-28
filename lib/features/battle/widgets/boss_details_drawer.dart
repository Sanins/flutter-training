import 'package:flutter/material.dart';

class BossDetailsDrawer extends StatelessWidget {
  const BossDetailsDrawer(
      {super.key}); // Mark constructor as const and use super.key

  @override
  Widget build(BuildContext context) {
    return const Drawer(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Boss Details',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text('Name: Evil Dragon'),
            SizedBox(height: 10),
            Text('Health: 5000 HP'),
            SizedBox(height: 10),
            Text('Attack: Fire Breath'),
            SizedBox(height: 10),
            Text('Weakness: Ice Magic'),
            // Add more details as needed
          ],
        ),
      ),
    );
  }
}
