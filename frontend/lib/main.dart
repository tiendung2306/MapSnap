import 'package:flutter/material.dart';
import 'package:mapsnap_fe/ForgotPassword.dart';
import 'package:mapsnap_fe/SignIn.dart';
import 'package:mapsnap_fe/VerifyEmail.dart';
import 'Onboarding.dart';
import 'SignUp.dart';
import 'Finish.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: Onboarding(),
    );
  }
}