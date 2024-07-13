import 'package:authentication_google/sign-up.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// Import your AuthPage

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _signIn() {
    if (_formKey.currentState!.validate()) {
      // Perform sign-in logic here
      print('Sign-In Successful');
    }
  }

  void _signInWithGoogle() {
    // Perform Google sign-in logic here
    print('Sign-In with Google');
  }

  void _signInWithGitHub() {
    // Perform GitHub sign-in logic here
    print('Sign-In with GitHub');
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
                          onTap: _signIn,
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
                      SizedBox(height: 5,),
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
