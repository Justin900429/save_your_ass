import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:save_your_ass/components/alert.dart';
import 'package:save_your_ass/components/rounded_button.dart';
import 'package:save_your_ass/constant.dart';
import 'package:save_your_ass/screen/user_screen.dart';

class LoginScreen extends StatefulWidget {
  static const String id = "login_screen";

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  late String email;
  late String password;
  bool showSpinner = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Padding(
            padding: const EdgeInsets.only(right: 20.0, left: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const Center(
                  child: Text(
                    "Login",
                    style: TextStyle(
                      fontSize: 50.0,
                      color: Color(0xff505050),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                TextField(
                  textAlign: TextAlign.start,
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(color: Colors.black),
                  onChanged: (value) {
                    email = value;
                  },
                  decoration: kTextFieldDecoration.copyWith(
                      hintText: "Enter your email."),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                TextField(
                  textAlign: TextAlign.start,
                  obscureText: true,
                  style: const TextStyle(color: Colors.black),
                  onChanged: (value) {
                    password = value;
                  },
                  decoration: kTextFieldDecoration.copyWith(
                      hintText: "Enter your password."),
                ),
                const SizedBox(
                  height: 24.0,
                ),
                RoundedButton(
                  color: const Color(0xffb0d1aa),
                  text: "Log in",
                  onPressed: () async {
                    setState(() {
                      showSpinner = true;
                    });
                    try {
                      await _auth.signInWithEmailAndPassword(
                          email: email, password: password);

                      // Reset email and password
                      setState(() {
                        email = "";
                        password = "";
                      });

                      Navigator.pushNamed(context, UserScreen.id);
                    } on FirebaseAuthException catch (e) {
                      late String error;
                      if (email.isEmpty) {
                        error = "Email is empty";
                      } else if (password.isEmpty) {
                        error = "Password is empty";
                      } else if (e.code == "user-not-found" ||
                          e.code == "wrong-password") {
                        error = "User or password is wrong";
                      } else {
                        error = "Unknown error. Please contact the developer.";
                      }

                      setState(() {
                        email = "";
                        password = "";
                      });

                      showDialog(
                        context: context,
                        builder: (context) => AlertMessage(
                          title: "Login Error",
                          message: error,
                        ),
                      );
                    }
                    setState(() {
                      showSpinner = false;
                    });
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
