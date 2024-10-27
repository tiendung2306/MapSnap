import 'package:flutter/material.dart';
import 'package:mapsnap_fe/Home.dart';
import 'package:mapsnap_fe/dev.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SearchBarApp(),
    );
  }
}