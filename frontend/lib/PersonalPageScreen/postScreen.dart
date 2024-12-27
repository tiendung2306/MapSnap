import 'package:flutter/material.dart';

class postScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: EdgeInsets.symmetric(horizontal: 10),
      color: Colors.white,
      child: Container(
          child: Image.asset(
             "assets/Image/post.png",
              fit: BoxFit.contain,

          )
      ),
    );
  }
}