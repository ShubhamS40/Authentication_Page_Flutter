import 'package:authentication_google/sign-in.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import './sign-in.dart'; // Import your sign-in page here

class HomePage extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<void> _signOut(BuildContext context) async {
    try {
      // Sign out from FirebaseAuth
      await _auth.signOut();

      // Sign out from Google
      if (await _googleSignIn.isSignedIn()) {
        await _googleSignIn.signOut();
      }

      // Sign out from GitHub (if applicable)
      // Note: GitHub sign out process is usually not required as the token is just removed.

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Sign out successful"),
          duration: Duration(seconds: 2),
        ),
      );

      // Navigate back to the sign-in page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SignInPage()), // Replace with your sign-in page widget
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Sign out failed: $e"),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => _signOut(context), // Pass context to the _signOut function
          ),
        ],
      ),
      body: Center(
        child: Text('Welcome to Home Page!',style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),),
      ),
    );
  }
}
