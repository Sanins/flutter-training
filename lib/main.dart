import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'features/battle/screens/home_screen.dart';
import 'features/battle/screens/login_screen.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import './amplifyconfiguration.dart'; // your Amplify config file

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set Amplify Logger level
  AmplifyLogger().logLevel = LogLevel.verbose;

  final authPlugin = AmplifyAuthCognito();
  await Amplify.addPlugins([authPlugin]);
  await Amplify.configure(amplifyconfig);

  // Check if the user is already signed in on app launch
  bool isSignedIn = await _checkUserSignIn();

  runApp(MyApp(isSignedIn: isSignedIn));
}

class MyApp extends StatelessWidget {
  final bool isSignedIn;

  const MyApp({super.key, required this.isSignedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: isSignedIn ? const MyHomePage(title: 'Home') : const LoginScreen(),
    );
  }
}

Future<bool> _checkUserSignIn() async {
  try {
    // Check if the user is already signed in
    final session = await Amplify.Auth.fetchAuthSession();
    return session.isSignedIn;
  } on AuthException catch (e) {
    print('Error checking sign-in status: ${e.message}');
    return false;
  }
}
