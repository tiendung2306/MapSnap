import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mapsnap_fe/Authentication/Onboarding.dart';
import 'package:mapsnap_fe/Authentication/SignIn.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mapsnap_fe/InApp/HomePage.dart';
import 'package:mapsnap_fe/Services/BackgroundService.dart';

import '../Model/Token_2.dart';
import '../Model/User_2.dart';
import '../Widget/AutoRefreshToken.dart';
import '../Widget/UpdateUser.dart';
import '../Widget/accountModel.dart';


class StartScreen extends StatefulWidget {
  @override
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  @override
  void initState() {
    super.initState();
    _navigateTo(); // Chuyển sang màn hình chính
  }


  void _navigateTo() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      bool permission = await locationRequest(context); // Gọi hàm kiểm tra quyền


      if(permission){
        await initializeService();

        Widget nextPage;

        final prefs = await SharedPreferences.getInstance();
        final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

        if(!isLoggedIn){
          final isFirstOpen = await prefs.getBool('isFirstOpen') ?? true;
          if(isFirstOpen)
            nextPage = Onboarding();
          else
            nextPage = SignIn();
        }
        else{
          var accountModel = Provider.of<AccountModel>(context, listen: false);
          final data = await prefs.getString('userData')!;
          Token token = Token.fromJson(jsonDecode(data));
          accountModel.setToken(token);
          User? user = await fetchData(token.idUser,token.token_access);
          accountModel.setUser(user!);

          startAutoRefreshToken(context, accountModel.token_refresh_expires,accountModel.token_refresh,accountModel.idUser);

          nextPage = HomePage();
        }


        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => nextPage), // Thay bằng màn hình chính
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Màu nền
      body: Center(
        child: Image.asset(
          'assets/Common/start.png', // Đường dẫn tới logo trong thư mục assets
          width: 400, // Độ rộng logo
          height: 400, // Chiều cao logo
          fit: BoxFit.contain, // Điều chỉnh cách hiển thị ảnh
        ),
      ),
    );
  }
}



