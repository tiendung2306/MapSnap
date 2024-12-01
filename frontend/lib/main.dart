import 'package:flutter/material.dart';
import 'package:mapsnap_fe/Authentication/ForgotPassword.dart';
import 'package:mapsnap_fe/Authentication/SignIn.dart';
import 'package:mapsnap_fe/Authentication/SignUp.dart';
import 'package:mapsnap_fe/Authentication/VerifyEmail.dart';
import 'package:mapsnap_fe/Camera/mainScreenCamera.dart';
import 'package:mapsnap_fe/NewFeed/newFeedScreen.dart';
import 'package:mapsnap_fe/PersonalPageScreen/personalPageScreen.dart';
import 'package:mapsnap_fe/SettingScreen/settingScreen.dart';
import 'package:mapsnap_fe/Widget/locator.dart';
import 'package:mapsnap_fe/Widget/accountModel.dart';
import 'package:provider/provider.dart'; // Import file model
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'Authentication/Onboarding.dart';
import 'FavouriteScreen.dart';
import 'PictureScreen/HomeScreen.dart';
import 'MapScreen.dart';
import 'Widget/AutoRefreshToken.dart';
import 'Widget/UpdateUser.dart';



Future<void> main() async {
  // Token token = await Login('linhson7a127@gmail.com', 'a1234567');
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  runApp(
    // Cấp quyền truy cập cao nhất cho AccountModel
    ChangeNotifierProvider(
      create: (context) => AccountModel(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/login',
      routes: {
        '/login': (context) => Onboarding(),
        '/home': (context) => const HomeScreen(),
        '/map': (context) => const MapScreen(),
        '/camera': (context) => const MainScreenCamera(),
        // '/favorites': (context) => const FavoritesScreen(),
        '/favorites': (context) => newFeedScreen(),
        '/account': (context) => const personalPageScreen(),
      },
      home: SafeArea(
        child: Scaffold(
          body: Container(
            // child: HomeScreen(),
             child: Onboarding(),
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}


