import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'features/battle/screens/choose_ability_screen.dart';
import 'models/player.dart';
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

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  String _errorMessage = '';

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final result = await Amplify.Auth.signIn(
        username: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (result.isSignedIn) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const MyHomePage(title: 'Home'),
          ),
        );
      } else {
        setState(() {
          _errorMessage =
              'Sign-in unsuccessful. Please check your credentials.';
        });
      }
    } on AuthException catch (e) {
      setState(() {
        _errorMessage = e.message;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            if (_errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  _errorMessage,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _isLoading ? null : _login,
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}

// MyHomePage class
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Example Player object, you can modify this as per your app's logic
  Player player = Player();

  // Sample ability choices; replace this with your actual ability choices
  // final List<String> abilities = ['Ability 1', 'Ability 2', 'Ability 3'];

  // Function to navigate to the ChooseAbilityScreen
  void _navigateToChooseAbilityScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChooseAbilityScreen(
          abilityChoices: abilities, // Pass your ability choices
          player: player, // Pass player object
        ),
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
          ],
        ),
      ),
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
