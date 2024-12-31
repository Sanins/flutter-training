import 'package:amplify_api/amplify_api.dart';
import 'package:flutter/material.dart';
import 'package:test_drive/models/User.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import './login_screen.dart';
import '../../../models/player.dart';
import './character_class_screen.dart';

// MyHomePage class
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title, this.initialUsername});
  final String title;
  final String? initialUsername;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late String username;
  Player player = Player();

  @override
  void initState() {
    super.initState();
    username = widget.initialUsername ?? 'Guest';
  }

  void _showUsernameModal() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String? newUsername;
        return AlertDialog(
          title: const Text('Enter Your Username'),
          content: TextField(
            onChanged: (value) {
              newUsername = value;
            },
            decoration: const InputDecoration(hintText: "Username"),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                if (newUsername != null && newUsername!.isNotEmpty) {
                  await _updateUsername(newUsername!);
                  Navigator.pop(context);
                } else {
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

  Future<void> _updateUsername(String newUsername) async {
    try {
      final user = await Amplify.Auth.getCurrentUser();

      print(user);

      // Update local cache
      final updatedUser = User(
        id: user.userId,
        username: newUsername,
        level: 1,
        currentExp: 0,
        createdAt: TemporalDateTime.now(),
        owner: user.userId,
      );
      try {
        final result = await Amplify.API
            .mutate(request: ModelMutations.update(updatedUser));

        print(result);
      } catch (e, stackTrace) {
        print('Error during mutation: $e');
        print('StackTrace: $stackTrace');
        throw e; // Throw the error to ensure the function completes with an exception
      }
      // Update backend

      try {
        Amplify.API.mutate(
          request: ModelMutations.update(updatedUser),
        );
      } catch (e, stackTrace) {
        print('Error during mutation: $e');
        print('StackTrace: $stackTrace');
        throw e; // Throw the error to ensure the function completes with an exception
      }

      // Update state
      setState(() {
        username = newUsername;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Username updated successfully")),
      );
    } catch (e) {
      print('Error updating username: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to update username: $e")),
      );
    }
  }

  void _navigateToChooseAbilityScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChooseClassScreen(player: player),
      ),
    );
  }

  Future<void> fetchUserById() async {
    try {
      // Ensure the user is authenticated
      final session = await Amplify.Auth.fetchAuthSession();
      if (session.isSignedIn) {
        // Get the current user
        final user = await Amplify.Auth.getCurrentUser();
        // // Make the query request with the current user's ID
        final response = await Amplify.API
            .query(
              request: ModelQueries.get(
                User.classType,
                UserModelIdentifier(id: user.userId),
              ),
            )
            .response;

        print('response: ${response.data}');

        // Handle the response
        if (response.errors.isNotEmpty) {
          print('GraphQL Errors: ${response.errors}');
        } else if (response.data != null) {
          print('User Data: ${response.data}');
        }
      } else {
        print("User is not signed in.");
      }
    } catch (e) {
      print('Error fetching user: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
            Text(
              'Welcome, $username',
              style: const TextStyle(fontSize: 20),
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
              onPressed: fetchUserById,
              child: const Text('testing'),
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
