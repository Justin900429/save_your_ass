import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:save_your_ass/components/alert.dart';
import 'package:save_your_ass/components/rounded_button.dart';
import 'package:save_your_ass/constant.dart';

class RegistrationScreen extends StatefulWidget {
  static const String id = "registration_screen";

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  String email = "";
  String password = "";
  String machineNum = "";
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
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Flexible(
                  child: Container(
                    height: 100,
                    child: const Center(
                      child: Text(
                        "Registration",
                        style: TextStyle(
                          fontSize: 50.0,
                          color: Color(0xff505050),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                TextField(
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(color: Colors.black),
                  textAlign: TextAlign.start,
                  onChanged: (value) {
                    email = value;
                  },
                  decoration: kTextFieldDecoration.copyWith(
                    hintText: "Email",
                  ),
                ),
                const SizedBox(
                  height: 25.0,
                ),
                TextField(
                  obscureText: true,
                  style: const TextStyle(color: Colors.black),
                  textAlign: TextAlign.start,
                  onChanged: (value) {
                    password = value;
                  },
                  decoration:
                  kTextFieldDecoration.copyWith(hintText: "Password"),
                ),
                const SizedBox(
                  height: 25.0,
                ),
                TextField(
                  obscureText: true,
                  style: const TextStyle(color: Colors.black),
                  textAlign: TextAlign.start,
                  onChanged: (value) {
                    machineNum = value;
                  },
                  decoration:
                  kTextFieldDecoration.copyWith(hintText: "Machine number"),
                ),
                const SizedBox(
                  height: 25.0,
                ),
                RoundedButton(
                  color: const Color(0xffb0d1aa),
                  text: "Register",
                  onPressed: () async {
                    setState(() {
                      showSpinner = true;
                    });

                    // Check whether the machine id is correct
                    final res = await _firestore
                        .collection("machines")
                        .doc(machineNum).get();

                    // Create user after machine id is checked
                    try {
                      if (!res.exists) {
                        throw FirebaseAuthException(
                            code: "machine-not-found");
                      }
                      if (res.data()!["user"] != null) {
                        throw FirebaseAuthException(code: "machine-used");
                      }

                      await _auth.createUserWithEmailAndPassword(
                          email: email, password: password);
                      _firestore.collection("machines").doc(machineNum).update({
                        "user": email.split("@")[0]
                      });

                      _firestore.collection("users").doc(email.split("@")[0]).set({
                        "height": 0,
                        "weight": 0,
                        "age": 0,
                        "hour": 0.0,
                        "score": 4,
                        "past_sit": [0, 0, 0, 0, 0, 0]
                      });

                      showDialog(
                        context: context,
                        builder: (context) =>
                            AlertMessage(
                              title: "Registration Success",
                              message:
                              "Please go to login page to login your account",
                            ),
                      );
                    } on FirebaseAuthException catch (e) {
                      late String error;

                      if (email.isEmpty) {
                        error = "Email is empty";
                      } else if (e.code == "machine-not-found") {
                        error = "Machine id not found. Please check it again";
                      } else if (password.isEmpty) {
                        error = "Password is empty";
                      } else if (e.code == "machine-used") {
                        error = "Machine id is already in used";
                      } else if (e.code == "email-already-in-use") {
                        error = "User is already in used";
                      } else {
                        error =
                        "Unknown error. Please contact the developer.";
                      }

                      setState(() {
                        email = "";
                        password = "";
                      });

                      showDialog(
                        context: context,
                        builder: (context) =>
                            AlertMessage(
                              title: "Registration Error",
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
