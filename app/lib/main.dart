import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:save_your_ass/screen/login_screen.dart';
import 'package:save_your_ass/screen/registration_screen.dart';
import 'package:save_your_ass/screen/user_screen.dart';
import 'package:save_your_ass/screen/welcome_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(SaveAss());
}

class SaveAss extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        textTheme: const TextTheme(
          bodyText2: TextStyle(color: Colors.black54),
        ),
      ),
      initialRoute: WelcomeScreen.id,
      routes: {
        WelcomeScreen.id: (context) => WelcomeScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        RegistrationScreen.id: (context) => RegistrationScreen(),
        UserScreen.id: (context) => UserScreen()
      },
    );
  }
}