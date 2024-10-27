import 'package:flutter/material.dart';
import 'package:mapsnap_fe/SignUp.dart';
import 'package:mapsnap_fe/VerifyEmail.dart';
import 'Widget/passwordForm.dart';
import 'Widget/normalForm.dart';
import 'Widget/outline_IconButton.dart';
import 'Finish.dart';



class ForgotPassword extends StatelessWidget {
  const ForgotPassword({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/Login/Background.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton.icon(
                    label: Text(""),
                    icon: Image.asset(
                        "assets/Login/BackButton.png",
                        width: 50,
                        height: 50,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 200),
                child: Text(
                  "Forgot Password",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Text(
                  "No worries! Enter your email address below and we "
                      "will send you a code to reset password.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 15,
                  ),
                ),
              ),
              // Các ô nhập liệu
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: normalForm(label:'Email'),
              ),
              // passwordForm(label:'Password'),
              // SizedBox(height: 20),
              Expanded(child: Container()),

              // Nút Register
              Padding(
                padding: const EdgeInsets.only(bottom: 40),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => VerifyEmail()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 50),
                      backgroundColor: Colors.lightBlueAccent
                  ),
                  child: Text('Next'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
