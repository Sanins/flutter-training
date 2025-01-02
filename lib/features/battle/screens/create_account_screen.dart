import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'home_screen.dart'; // Import the home screen
import 'verification_screen.dart'; // Import the verification screen

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  String _errorMessage = '';

  // Method to handle registration
  Future<void> _register() async {
    if (_passwordController.text != _confirmPasswordController.text) {
      setState(() {
        _errorMessage = 'Passwords do not match.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final result = await Amplify.Auth.signUp(
        username: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (result.nextStep.signUpStep == AuthSignUpStep.confirmSignUp) {
        // If confirmation code is required, navigate to the verification screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VerificationScreen(
              email: _emailController.text.trim(),
              password: _passwordController.text
                  .trim(), // Pass password to the next screen
            ),
          ),
        );
      } else if (result.isSignUpComplete) {
        // If sign-up is complete, navigate directly to home
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const MyHomePage(),
          ),
        );
      } else {
        setState(() {
          _errorMessage =
              'Registration not complete. Please check your credentials.';
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
      appBar: AppBar(title: const Text('Create Account')),
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
            TextField(
              controller: _confirmPasswordController,
              decoration: const InputDecoration(labelText: 'Confirm Password'),
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
              onPressed: _isLoading ? null : _register,
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Create Account'),
            ),
          ],
        ),
      ),
    );
  }
}
