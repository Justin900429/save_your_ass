import 'package:flutter/material.dart';
import "package:animated_text_kit/animated_text_kit.dart";
import 'package:save_your_ass/components/rounded_button.dart';
import 'package:save_your_ass/screen/login_screen.dart';
import 'package:save_your_ass/screen/registration_screen.dart';

class WelcomeScreen extends StatefulWidget {
  static const String id = "welcome_screen";

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffc4cfc0),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 60,
                  child: Image.asset('images/dog.png'),
                ),
                const SizedBox(height: 30),
                AnimatedTextKit(
                  repeatForever: true,
                  animatedTexts: [
                    TyperAnimatedText(
                      "Save Your Ass",
                      textStyle: const TextStyle(
                          fontFamily: "Luckiest",
                          fontSize: 35.0,
                          color: Colors.black),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 30.0,
            ),
            RoundedButton(
              color: const Color(0xff92a68b),
              text: "Log In",
              onPressed: () {
                Navigator.pushNamed(context, LoginScreen.id);
              },
            ),
            RoundedButton(
              color: const Color(0xff77906e),
              text: "Registration",
              onPressed: () {
                Navigator.pushNamed(context, RegistrationScreen.id);
              },
            )
          ],
        ),
      ),
    );
  }
}
