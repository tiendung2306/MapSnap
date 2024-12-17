import 'package:flutter/material.dart';
import 'package:mapsnap_fe/Camera/mainScreenCamera.dart';
import 'package:mapsnap_fe/InApp/Map.dart';
import 'package:mapsnap_fe/InApp/CreateJourney.dart';
import 'package:mapsnap_fe/InApp/Start.dart';
import 'package:mapsnap_fe/NewFeed/newFeedScreen.dart';
import 'package:mapsnap_fe/PersonalPageScreen/personalPageScreen.dart';
import 'package:mapsnap_fe/Widget/locator.dart';
import 'package:mapsnap_fe/Widget/accountModel.dart';
import 'package:provider/provider.dart'; // Import file model
import 'Authentication/SignIn.dart';
import 'InApp/HomePage.dart';
import 'dev.dart';

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
      initialRoute: '/start',
      routes: {
        '/start': (context) => StartScreen(),
        '/map': (context) => MapScreen(journeyID: "67619347c26ede008ef7b79a",),
        '/home': (context) => HomePage(),
        '/camera': (context) => const MainScreenCamera(),
        '/feed': (context) => newFeedScreen(),
        '/account': (context) => const personalPageScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}


