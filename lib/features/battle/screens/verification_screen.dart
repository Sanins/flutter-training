import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'home_screen.dart'; // Import the home screen

class VerificationScreen extends StatefulWidget {
  final String email;
  final String password; // Receive the password

  const VerificationScreen(
      {super.key, required this.email, required this.password});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final _verificationCodeController = TextEditingController();
  bool _isLoading = false;
  String _errorMessage = '';

  // Method to confirm sign-up with the verification code
  Future<void> _confirmSignUp() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      // Confirm the sign-up with the verification code
      final result = await Amplify.Auth.confirmSignUp(
        username: widget.email,
        confirmationCode: _verificationCodeController.text.trim(),
      );

      if (result.isSignUpComplete) {
        // If the sign-up is complete, attempt to log in with the provided password
        final loginResult = await Amplify.Auth.signIn(
          username: widget.email,
          password: widget.password, // Use the passed password directly
        );

        if (loginResult.isSignedIn) {
          // Navigate to home page after successful login
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const MyHomePage(),
            ),
          );
        } else {
          setState(() {
            _errorMessage = 'Login failed. Please check your credentials.';
          });
        }
      } else {
        setState(() {
          _errorMessage = 'Verification failed. Please check the code.';
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
      appBar: AppBar(title: const Text('Enter Verification Code')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _verificationCodeController,
              decoration: const InputDecoration(labelText: 'Verification Code'),
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
              onPressed: _isLoading ? null : _confirmSignUp,
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Confirm Email'),
            ),
          ],
        ),
      ),
    );
  }
}
