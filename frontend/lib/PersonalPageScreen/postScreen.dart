import 'package:flutter/material.dart';

class postScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      color: Colors.white,
      child: Center(
          child: Text('Như kiểu nhật ký của FB',
            style: TextStyle(fontSize: 32.0),
          )
      ),
    );
  }
}