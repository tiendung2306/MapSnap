import 'package:flutter/material.dart';

class albumScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      color: Colors.white,
      child: Center(
        child: Text('Giống Album của fb là tổng hợp các ảnh mình đã đăng',
          style: TextStyle(fontSize: 35.0),
        ),
      ),
    );
  }
}