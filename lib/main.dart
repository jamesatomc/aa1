import 'package:ch09_flutter/page2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:ch09_flutter/login.dart';
import 'package:ch09_flutter/register.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ).then((value) => {
        FirebaseAuth.instance.authStateChanges().listen(
          (event) {
            if (event == null) {
              runApp(
                MaterialApp(
                  home: LoginPage(),
                  debugShowCheckedModeBanner: false,
                ),
              );
            } else {
              runApp(
                MaterialApp(
                  home: Page2(),
                  debugShowCheckedModeBanner: false,
                ),
              );
            }
          },
        ),
      } 
      );
}
