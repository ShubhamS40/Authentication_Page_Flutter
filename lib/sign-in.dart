import 'dart:async';
import 'dart:convert';
import 'package:authentication_google/sign-up.dart';
// import 'package:authentication_google/sign_up.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'home.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;

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
            .signInWithEmailAndPassword(email: email.text, password: password.text);
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

  Future<void> signInWithGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

    if (googleUser != null) {
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential result = await _auth.signInWithCredential(credential);
      User? userDetails = result.user;
      print(userDetails);

      if (userDetails != null) {
        Map<String, dynamic> userInfoMap = {
          "id": userDetails.uid,
          "username": userDetails.displayName,
          "email": userDetails.email,
          "photo": userDetails.photoURL,
        };
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Login Successfully...."),
          duration: Duration(seconds: 2),
        ));
        Navigator.push(context, MaterialPageRoute(
          builder: (context) => HomePage(),
        ));
        final ok = await FirebaseFirestore.instance.collection("users").add(userInfoMap); // Corrected collection name to "users"
        print("Data successfully uploaded to the server: $ok");
      }

      // You can use userDetails here, for example, to update your UI or save user information
    } else {
      print("Something went wrong");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Something Went Wrong Server Down"),
        duration: Duration(seconds: 2),
      ));
      // Handle the case where the user canceled the sign-in
    }
  }

  Future<void> _signInWithGitHub(BuildContext context) async {
    try {
      final clientId = "Ov23liH1FL83YRZhKZA2";
      final clientSecret = "b7327e9835921d14fc304ae6c19868d1d3e4d73c";
      final redirectUrl = 'https://your-app.firebaseapp.com/__/auth/handler'; // Replace with your actual redirect URL
      final url = 'https://github.com/login/oauth/authorize?client_id=$clientId&redirect_uri=$redirectUrl&scope=read:user,user:email';

      final result = await FlutterWebAuth.authenticate(url: url, callbackUrlScheme: "https");

      final code = Uri.parse(result).queryParameters['code'];

      final response = await http.post(
        Uri.parse('https://github.com/login/oauth/access_token'),
        headers: {'Accept': 'application/json'},
        body: {
          'client_id': clientId,
          'client_secret': clientSecret,
          'code': code,
        },
      );

      final accessToken = json.decode(response.body)['access_token'];

      OAuthCredential credential = GithubAuthProvider.credential(accessToken);

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
                  height: 300,
                  width: double.infinity,
                  child: Image.network(
                    "https://img.freepik.com/free-vector/programming-concept-illustration_114360-1325.jpg?t=st=1721061785~exp=1721062385~hmac=36214217bc76e05b0569687c435b4c54c72d8f758c92280c65484f0e94f6e692",
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
                            onTap: signInWithGoogle,
                            child: Container(
                              alignment: Alignment.center,
                              height: 50,
                              width: 50,
                              child: FaIcon(FontAwesomeIcons.google,size: 40, color: Color.fromARGB(255, 8, 75, 129),),
                            ),
                          ),
                          SizedBox(width: 50,height: 100,),
                          GestureDetector(
                            onTap: () => _signInWithGitHub(context), // Add context parameter
                            child: Container(
                              alignment: Alignment.center,
                              height: 50,
                              width: 50,
                              child: FaIcon(FontAwesomeIcons.github,size: 40,color: Color.fromARGB(255, 8, 75, 129),),
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
