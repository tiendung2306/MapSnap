import 'package:flutter/material.dart';
import 'dart:async';
import 'package:mapsnap_fe/InApp/HomePage.dart';
import 'package:mapsnap_fe/Services/BackgroundService.dart';
import 'package:geolocator/geolocator.dart';


class StartScreen extends StatefulWidget {
  @override
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome(); // Chuyển sang màn hình chính
  }


  void _navigateToHome() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      bool permission = await locationRequest(context); // Gọi hàm kiểm tra quyền

      if(permission){
        await initializeService();

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()), // Thay bằng màn hình chính
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
          'assets/Common/logo.png', // Đường dẫn tới logo trong thư mục assets
          width: 400, // Độ rộng logo
          height: 400, // Chiều cao logo
          fit: BoxFit.contain, // Điều chỉnh cách hiển thị ảnh
        ),
      ),
    );
  }
}



