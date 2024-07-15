import 'package:authentication_google/home.dart';
import 'package:authentication_google/sign-in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController username = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();

  Future<void> _register() async {
    final FormState? form = _formKey.currentState;
    if (form!.validate()) {
      try {
        final UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
            email: email.text.trim(), password: password.text.trim());
        print('User registered: ${userCredential.user!.uid}');

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('User signed up successfully'),
            duration: Duration(seconds: 2),
          ),
        );

        // Clear text fields
        username.clear();
        email.clear();
        password.clear();

        // Navigate to home page after successful registration
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      } catch (e) {
        print('Failed to register user: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to register user: $e'),
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
                  height: 250,
                  width: double.infinity,
                  child: Image.network(
                    "https://img.freepik.com/premium-vector/get-business-identification-number-abstract-concept-vector-illustration_107173-40787.jpg",
                    fit: BoxFit.cover,
                    errorBuilder: (BuildContext context, Object exception,
                        StackTrace? stackTrace) {
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
                        margin: EdgeInsets.only(
                            left: 20, right: 20, top: 20, bottom: 10),
                        padding: EdgeInsets.symmetric(
                            vertical: 5, horizontal: 22),
                        child: TextFormField(
                          controller: username,
                          decoration: InputDecoration(
                            hintText: "Username",
                            hintStyle: TextStyle(
                              color: Color.fromARGB(255, 128, 124, 124),
                              fontWeight: FontWeight.bold,
                            ),
                            border: InputBorder.none,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a username';
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
                        margin: EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        padding: EdgeInsets.symmetric(
                            vertical: 5, horizontal: 22),
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
                        margin: EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        padding: EdgeInsets.symmetric(
                            vertical: 5, horizontal: 22),
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
                          onTap: _register,
                          child: Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 23, vertical: 10),
                            padding: EdgeInsets.symmetric(vertical: 15),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(35),
                              color: Color.fromARGB(255, 8, 75, 129),
                            ),
                            child: Center(
                              child: Text(
                                "Sign-Up",
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
                              child: FaIcon(FontAwesomeIcons.google,size: 40,color: Color.fromARGB(255, 8, 75, 129),),
                            ),
                          ),
                          SizedBox(width: 40,height: 100,),
                          GestureDetector(
                            // onTap: _signInWithGitHub,
                            child: Container(
                              alignment: Alignment.center,
                              height: 50,
                              width: 50,
                              child: FaIcon(FontAwesomeIcons.github,size: 40,color: Color.fromARGB(255, 8, 75, 129),),
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => SignInPage()),
                          );
                        },
                        child: RichText(
                          text: TextSpan(
                            text: "Already have an account? ",
                            style: TextStyle(color: Colors.black),
                            children: [
                              TextSpan(
                                text: "Sign-in",
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



