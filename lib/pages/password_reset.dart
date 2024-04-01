import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ovrsr/utils/apptheme.dart';

class ResetPasswordPage extends StatelessWidget {
  ResetPasswordPage({super.key});

  final TextEditingController _emailController = TextEditingController();

  void _resetPassword(BuildContext context) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: _emailController.text,
      );
      // Show success message or navigate to a success page
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password reset email sent'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (error) {
      // Show error message if something goes wrong
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to send password reset email'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reset Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 500,
                  child: TextField(
                      controller: _emailController,
                      decoration: const InputDecoration(labelText: 'Email'),
                      style: const TextStyle(
                          color: AppTheme.light,
                          decoration: TextDecoration.underline,
                          decorationColor: AppTheme.light)),
                )
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: TextButton.styleFrom(
                backgroundColor: const Color.fromARGB(0, 128, 109, 0),
                foregroundColor: AppTheme.light,
              ),
              onPressed: () => _resetPassword(context),
              child: const Text('Reset Password'),
            ),
          ],
        ),
      ),
    );
  }
}
