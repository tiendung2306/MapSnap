import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/Common/Background.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Image.asset(
                    "assets/Common/logo.png",
                  width: 40,
                  height: 40,
                ),

              ],
            )
          ],
        )
      ),
    );
  }
}
