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

  Future accountModelSetup(Token token) async {
    var accountModel = Provider.of<AccountModel>(context, listen: false);
    accountModel.setToken(token);
    User? user = await fetchData(token.idUser,token.token_access);
    accountModel.setUser(user!);

    startAutoRefreshToken(context, accountModel.token_refresh_expires,accountModel.token_refresh,accountModel.idUser);
  }

  void _navigateTo() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      bool permission = await locationRequest(context); // Gọi hàm kiểm tra quyền


      if(permission){
        await initializeService();

        Widget nextPage;

        final prefs = await SharedPreferences.getInstance();
        final token_data = await prefs.getString('token') ?? 'null';

        if(token_data == 'null'){
          final isFirstOpen = await prefs.getBool('isFirstOpen') ?? true;
          if(isFirstOpen)
            nextPage = Onboarding();
          else
            nextPage = SignIn();
        }
        else{
          final DateTime now = DateTime.now();
          Token token = Token.fromJson(jsonDecode(token_data));
          final Duration accesstimeLeft = token.token_access_expires.difference(now);

          if (accesstimeLeft.isNegative) {
            final Duration refreshtimeLeft = token.token_refresh_expires.difference(now);
            print(refreshtimeLeft.inMinutes);
            if(refreshtimeLeft.isNegative)
              nextPage = SignIn();
            else{
              Token? newtoken = await refreshToken(token.idUser, token.token_refresh, context);
              if(newtoken != null){
                await accountModelSetup(newtoken);
                nextPage = HomePage();
              }
              else
                nextPage = SignIn();
            }
          } else {
            await accountModelSetup(token);
            nextPage = HomePage();
          }
        }


        Navigator.push(
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



