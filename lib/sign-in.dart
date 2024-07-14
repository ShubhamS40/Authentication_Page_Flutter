import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'home.dart'; // Import your home.dart file here
import './sign-up.dart'; // Assuming sign-up.dart is renamed to sign_up.dart
import 'package:github_sign_in_plus/github_sign_in_plus.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  Future<void> signIn() async {
    if (_formKey.currentState!.validate()) {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
            email: email.text, password: password.text);
        if (userCredential.user != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Login Successful"),
              duration: Duration(seconds: 2),
            ),
          );
          email.clear();
          password.clear();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Invalid Credentials"),
              duration: Duration(seconds: 2),
            ),
          );
          email.clear();
          password.clear();
        }
      } on FirebaseAuthException catch (e) {
        String message = 'Authentication failed';
        if (e.code == 'user-not-found') {
          message = 'No user found for that email.';
        } else if (e.code == 'wrong-password') {
          message = 'Wrong password provided.';
        } else {
          message = e.message ?? 'An error occurred. Please try again later.';
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            duration: Duration(seconds: 2),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('An error occurred. Please try again later.'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: '1098217591910-13tgsge8ph9ul13cdj2jfv68392dn9ad.apps.googleusercontent.com',
  );

  Future<void> _signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        // User canceled the sign-in
        return;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Sign in successful, ${user.displayName ?? 'User'}!"),
          ),
        );
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => HomePage()), // Replace with your home page widget
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Sign in failed"),
          ),
        );
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Sign in failed: $e"),
        ),
      );
    }
  }

  Future<void> _signInWithGitHub() async {
    try {
      final result = await GitHubSignIn(
        clientId: "Ov23liH1FL83YRZhKZA2",
        clientSecret: "b7327e9835921d14fc304ae6c19868d1d3e4d73c",
        redirectUrl: "http://localhost:53769/",
      ).signIn(context);

      if (result != null && result.token != null) {
        // Successfully signed in
        OAuthCredential credential = GithubAuthProvider.credential(result.token!);

        final UserCredential userCredential = await _auth.signInWithCredential(credential);
        User? user = userCredential.user;

        if (user != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("GitHub sign in successful, ${user.displayName ?? 'User'}!"),
            ),
          );
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => HomePage()), // Replace with your home page widget
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("GitHub sign in failed"),
            ),
          );
        }
      } else {
        // User canceled the sign-in or result token is null
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("GitHub sign in canceled"),
          ),
        );
      }
    } catch (e) {
      print('GitHub sign in error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("GitHub sign in failed: $e"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  color: Colors.blue,
                  height: 200,
                  width: double.infinity,
                  child: Image.network(
                    "https://img.freepik.com/premium-vector/call-center-agent-design-flat-style_23-2147945881.jpg",
                    fit: BoxFit.cover,
                    errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                      return Center(
                        child: Text(
                          'Image not available',
                          style: TextStyle(color: Colors.red),
                        ),
                      );
                    },
                  ),
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 221, 217, 217),
                          borderRadius: BorderRadius.circular(35),
                        ),
                        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 22),
                        child: TextFormField(
                          controller: email,
                          decoration: InputDecoration(
                            hintText: "E-mail",
                            hintStyle: TextStyle(
                              color: Color.fromARGB(255, 128, 124, 124),
                              fontWeight: FontWeight.bold,
                            ),
                            border: InputBorder.none,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter an email';
                            }
                            return null;
                          },
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 221, 217, 217),
                          borderRadius: BorderRadius.circular(35),
                        ),
                        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 22),
                        child: TextFormField(
                          controller: password,
                          decoration: InputDecoration(
                            hintText: "Password",
                            hintStyle: TextStyle(
                              color: Color.fromARGB(255, 128, 124, 124),
                              fontWeight: FontWeight.bold,
                            ),
                            border: InputBorder.none,
                          ),
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a password';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: GestureDetector(
                          onTap: signIn,
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 23, vertical: 20),
                            padding: EdgeInsets.symmetric(vertical: 15),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(35),
                              color: Color.fromARGB(255, 8, 75, 129),
                            ),
                            child: Center(
                              child: Text(
                                "Sign-In",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        child: Text(
                          "Or Login With",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(height: 5),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: _signInWithGoogle,
                            child: Container(
                              alignment: Alignment.center,
                              height: 50,
                              width: 50,
                              child: FaIcon(FontAwesomeIcons.google),
                            ),
                          ),
                          GestureDetector(
                            onTap: _signInWithGitHub,
                            child: Container(
                              alignment: Alignment.center,
                              height: 50,
                              width: 50,
                              child: FaIcon(FontAwesomeIcons.github),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 5),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => AuthPage()),
                          );
                        },
                        child: RichText(
                          text: TextSpan(
                            text: "Don't have an account? ",
                            style: TextStyle(color: Colors.black),
                            children: [
                              TextSpan(
                                text: "Sign-up",
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
