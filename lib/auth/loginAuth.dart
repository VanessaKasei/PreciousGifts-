// ignore_for_file: use_build_context_synchronously

import 'package:flutter/foundation.dart';
import 'package:precious_gifts/imports/import.dart';

class loginAuth {
  static Future<void> loginUserWithEmailAndPassword(
      String emailAddress, String password, BuildContext context) async {
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: emailAddress, password: password);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Login successful!'),
      ));
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const MyHomePage(),
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        if (kDebugMode) {
          print('No user found for that email.');
        }
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('User not found, please login with valid email'),
          ),
        );
      } else if (e.code == 'wrong-password') {
        if (kDebugMode) {
          print('Wrong password provided for that user.');
        }
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Wrong password provided!'),
          ),
        );
      }
    }
  }
}
