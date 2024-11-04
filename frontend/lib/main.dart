import 'package:flutter/material.dart';
import 'package:mapsnap_fe/Screen/settingScreen.dart';
import 'package:mapsnap_fe/Widget/locator.dart';
import 'package:mapsnap_fe/Widget/accountModel.dart';
import 'package:provider/provider.dart'; // Import file model
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'Widget/UpdateUser.dart';

// Đăng ký
Future<void> Register(String name,String password,String email) async {
  final response = await http.post(
    Uri.parse('http://10.0.2.2:3000/v1/auth/register'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'username': name,
      'password': password,
      'email': email,
    }),
  );
  if (response.statusCode == 201) {
    print("Đăng ký thành công");
  } else {
    throw Exception(response.statusCode);
  }
}

// Đăng nhập
class Token {
  String token_access;
  String token_access_expires;
  String token_refresh;
  String token_refresh_expires;
  String idUser;

  Token({required this.token_access,required this.token_access_expires,required this.token_refresh,required this.token_refresh_expires,required this.idUser});

  factory Token.fromJson(Map<String, dynamic> json) {
    return Token(
      token_access: json['tokens']['access']['token'] ?? 'NoTokenAccess',
      token_access_expires: json['tokens']['access']['expires'] ?? 'NoTokenAccessExpires',
      token_refresh: json['tokens']['refresh']['token'] ?? 'NoTokenRefresh',
      token_refresh_expires: json['tokens']['refresh']['expires'] ?? 'NoTokenRefreshExpires',
      idUser: json['user']['id'] ?? 'NoID',
    );
  }
}


Future<Token> Login(String email,String password) async {
  final response = await http.post(
    Uri.parse('http://10.0.2.2:3000/v1/auth/login'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'email': email,
      'password': password,
    }),
  );
  if (response.statusCode == 200) {
    print("Đăng nhập thành công");
    var data = jsonDecode(response.body) as Map;
    return Token(
      token_access: data['tokens']['access']['token'] ?? 'NoTokenAccess',
      token_access_expires: data['tokens']['access']['expires'] ?? 'NoTokenAccessExpires',
      token_refresh: data['tokens']['refresh']['token'] ?? 'NoTokenRefresh',
      token_refresh_expires: data['tokens']['refresh']['expires'] ?? 'NoTokenRefreshExpires',
      idUser: data['user']['id'] ?? 'NoID',
    );
  } else {
    throw Exception(response.statusCode);
  }
}

Future<void> main() async {
  await Register('prjnhucac', 'a1234567', 'linhson7a127@gmail.com');
  Token token = await Login('linhson7a127@gmail.com', 'a1234567');
  User? user = await fetchData(token.idUser,token.token_access);
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  runApp(
    // Cấp quyền truy cập cao nhất cho AccountModel
    ChangeNotifierProvider(
      create: (context) => AccountModel()..setUser(user!)..setToken(token), // Đặt `User` vào `AccountModel`
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
          body: Container(
            // child: Onboarding(),
             child: settingScreen(),
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

