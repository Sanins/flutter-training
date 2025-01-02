import 'package:flutter/material.dart';
import 'package:test_drive/features/battle/screens/home_screen.dart';

class DefeatScreen extends StatelessWidget {
  const DefeatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Defeated"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "You Have Been Defeated!",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const MyHomePage()),
                );
              },
              child: const Text("Return to Home"),
            ),
          ],
        ),
      ),
    );
  }
}
