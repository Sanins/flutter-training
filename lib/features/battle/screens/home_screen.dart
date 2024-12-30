import 'package:amplify_api/amplify_api.dart';
import 'package:flutter/material.dart';
import 'package:test_drive/models/User.dart';
import 'package:amplify_datastore/amplify_datastore.dart';
import '../../../models/player.dart';
import './character_class_screen.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import './login_screen.dart';

// MyHomePage class
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Player player = Player();
  String? username;

  void _showUsernameModal() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enter Your Username'),
          content: TextField(
            onChanged: (value) {
              setState(() {
                username = value;
              });
            },
            decoration: const InputDecoration(hintText: "Username"),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                if (username != null && username!.isNotEmpty) {
                  // Update the Player object with the entered username
                  player.username = username!;

                  // Update DynamoDB with the new username
                  await _updateUsernameInDb(player.username);

                  Navigator.pop(context); // Close the modal
                } else {
                  // Handle case when username is empty (optional)
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Username cannot be empty")),
                  );
                }
              },
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _updateUsernameInDb(String username) async {
    try {
      final user = await Amplify.Auth.getCurrentUser();
      final userId = user.userId; // Unique ID of the logged-in user

      // Prepare the User model for mutation
      final updatedUser = User(
        id: userId, // Set the ID to the current user ID
        username: username,
        level: 1, // Set initial level as per your app's requirements
        currentExp: 0, // Set initial experience
        createdAt: TemporalDateTime.now(),
        owner: userId, // Set the owner field to the current user's ID
      );

      // Call the mutation to update the user in the database
      final mutationResponse = await Amplify.API.mutate(
        request: ModelMutations.create(updatedUser),
      );

      mutationResponse.response.onError((Object error, StackTrace stackTrace) {
        throw Exception('Failed to update username: ${error.toString()}');
      });

      // Optionally, you can display a success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Username saved successfully")),
      );
    } catch (e) {
      print('Error updating username in DB: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to save username: $e")),
      );
    }
  }

  // Function to navigate to the ChooseClassScreen
  void _navigateToChooseAbilityScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChooseClassScreen(player: player),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: <Widget>[Container()],
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: _navigateToChooseAbilityScreen,
              child: const Text('Go to Battle'),
            ),
            ElevatedButton(
              onPressed: () async {
                await Amplify.Auth.signOut();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ),
                );
              },
              child: const Text('Logout'),
            ),
            ElevatedButton(
              onPressed: _showUsernameModal,
              child: const Text('Set Username'),
            ),
          ],
        ),
      ),
    );
  }
}
