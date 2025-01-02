import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_api/amplify_api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_drive/features/battle/screens/home_screen.dart';
import '../../../models/User.dart';

class UsernameSetupScreen extends StatefulWidget {
  const UsernameSetupScreen({Key? key}) : super(key: key);

  @override
  _UsernameSetupScreenState createState() => _UsernameSetupScreenState();
}

class _UsernameSetupScreenState extends State<UsernameSetupScreen> {
  String? newUsername;
  bool isLoading = false;

  Future<void> _submitUsername() async {
    if (newUsername == null || newUsername!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Username cannot be empty")),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      // Save to local storage
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('username', newUsername!);
      await prefs.setInt('level', 1); // Default starting level
      await prefs.setInt('currentExp', 0); // Default starting EXP

      // Sync to the backend (AWS Amplify)
      final user = await Amplify.Auth.getCurrentUser();
      final updatedUser = User(
        id: user.userId,
        username: newUsername!,
        level: 1,
        currentExp: 0,
        updatedAt: TemporalDateTime.now(),
        owner: user.userId,
      );

      final result = await Amplify.API.mutate(
        request: ModelMutations.update(updatedUser),
      );
      print('User data updated: $result');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Username set successfully")),
      );

      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const MyHomePage(),
          ),
        );
      });
    } catch (e) {
      print('Error updating username: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to set username: $e")),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Set Username"),
      ),
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Enter a Username to Begin"),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextField(
                      onChanged: (value) {
                        newUsername = value;
                      },
                      decoration: const InputDecoration(hintText: "Username"),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _submitUsername,
                    child: const Text("Submit"),
                  ),
                ],
              ),
      ),
    );
  }
}
