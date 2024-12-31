import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_api/amplify_api.dart';
import 'features/battle/screens/home_screen.dart';
import 'features/battle/screens/login_screen.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_datastore/amplify_datastore.dart';
import 'models/ModelProvider.dart';
import './amplifyconfiguration.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final authPlugin = AmplifyAuthCognito();
  final dataStorePlugin =
      AmplifyDataStore(modelProvider: ModelProvider.instance);
  final apiPlugin = AmplifyAPI(modelProvider: ModelProvider.instance);

  await Amplify.addPlugins([authPlugin, dataStorePlugin, apiPlugin]);
  await Amplify.configure(amplifyconfig);

  bool isSignedIn = await _checkUserSignIn();

  String? username = isSignedIn ? await _getUsername() : null;

  runApp(MyApp(isSignedIn: isSignedIn, username: username));
}

Future<bool> _checkUserSignIn() async {
  try {
    final session = await Amplify.Auth.fetchAuthSession();
    return session.isSignedIn;
  } catch (e) {
    print('Error checking sign-in status: $e');
    return false;
  }
}

Future<String?> _getUsername() async {
  try {
    // Check local storage first
    final users = await Amplify.DataStore.query(User.classType);
    print('Users: $users');
    if (users.isNotEmpty) {
      return users.first.username;
    }

    // If not in local storage, fetch from backend
    final user = await Amplify.Auth.getCurrentUser();
    final response = await Amplify.API
        .query(
          request: ModelQueries.get(
            User.classType,
            UserModelIdentifier(id: user.userId),
          ),
        )
        .response;

    print('Response: $response');
    if (response.data != null) {
      await Amplify.DataStore.save(response.data!); // Cache locally
      return response.data!.username;
    }
  } catch (e) {
    print('Error fetching username: $e');
  }
  return null; // Return null if no username is found
}

class MyApp extends StatelessWidget {
  final bool isSignedIn;
  final String? username;

  const MyApp({super.key, required this.isSignedIn, this.username});

  @override
  Widget build(BuildContext context) {
    print('Defend action selected, $username');

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: isSignedIn
          ? MyHomePage(title: 'Home', initialUsername: username)
          : const LoginScreen(),
    );
  }
}
