import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_api/amplify_api.dart';
import 'features/battle/screens/home_screen.dart';
import 'features/battle/screens/login_screen.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './amplifyconfiguration.dart';
import 'models/ModelProvider.dart';
import 'package:provider/provider.dart';
import './providers/item_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final authPlugin = AmplifyAuthCognito();
  final dataStorePlugin =
      AmplifyDataStore(modelProvider: ModelProvider.instance);
  final apiPlugin = AmplifyAPI(modelProvider: ModelProvider.instance);

  await Amplify.addPlugins([authPlugin, dataStorePlugin, apiPlugin]);
  await Amplify.configure(amplifyconfig);

  bool isSignedIn = await _checkUserSignIn();

  // Check if user is signed in, and retrieve their data
  Map<String, dynamic>? userData = isSignedIn ? await _getUserData() : null;

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => ItemProvider()),
  ], child: MyApp(isSignedIn: isSignedIn, userData: userData)));
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

// Retrieve user data from SharedPreferences first, then check the backend if needed
Future<Map<String, dynamic>?> _getUserData() async {
  try {
    final prefs = await SharedPreferences.getInstance();

    // Check if data is stored locally
    String? username = prefs.getString('username');
    int? level = prefs.getInt('level');
    int? currentExp = prefs.getInt('currentExp');

    if (username != null && level != null && currentExp != null) {
      return {'username': username, 'level': level, 'currentExp': currentExp};
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

    if (response.data != null) {
      // Save data to local storage
      await prefs.setString('username', response.data!.username!);
      await prefs.setInt('level', response.data!.level);
      await prefs.setInt('currentExp', response.data!.currentExp);

      return {
        'username': response.data!.username,
        'level': response.data!.level,
        'currentExp': response.data!.currentExp
      };
    }
  } catch (e) {
    print('Error fetching user data: $e');
  }
  return null;
}

class MyApp extends StatelessWidget {
  final bool isSignedIn;
  final Map<String, dynamic>? userData;

  const MyApp({super.key, required this.isSignedIn, this.userData});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: isSignedIn
          ? MyHomePage(
              initialUsername: userData?['username'],
              initialLevel: userData?['level'],
              initialCurrentExp: userData?['currentExp'],
            )
          : const LoginScreen(),
    );
  }
}
