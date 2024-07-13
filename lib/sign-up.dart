import 'package:authentication_google/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:authentication_google/sign-in.dart'; // Import your SignInPage

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final TextEditingController username = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<bool> _register() async {
    final FormState? form = _formKey.currentState;
    if (form!.validate()) {
      try {
        final UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: email.text.trim(), password: password.text.trim());
        print('User registered: ${userCredential.user!.uid}');

        // Show Snackbar message
         
        //  if(userCredential){
        //   Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage(),));
        //  }


        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('User Signup Successfully'),
            duration: Duration(seconds: 2),
          ),
        );

        // Clear text fields
        username.clear();
        email.clear();
        password.clear();

        return true; // Registration successful
      } catch (e) {
        print('Failed to register user: $e');
        // Show error Snackbar message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to register user: $e'),
            duration: Duration(seconds: 2),
          ),
        );
        return false; // Registration failed
      }
    }
    return false; // Validation failed
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
                          onTap: () async {
                            bool success = await _register();
                            if (success) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => HomePage()),
                              );
                            } else {
                              print('Registration failed');
                            }
                          },
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
                            // onTap: _signInWithGoogle,
                            child: Container(
                              alignment: Alignment.center,
                              height: 50,
                              width: 50,
                              child: FaIcon(FontAwesomeIcons.google),
                            ),
                          ),
                          GestureDetector(
                            // onTap: _signInWithGitHub,
                            child: Container(
                              alignment: Alignment.center,
                              height: 50,
                              width: 50,
                              child: FaIcon(FontAwesomeIcons.github),
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
