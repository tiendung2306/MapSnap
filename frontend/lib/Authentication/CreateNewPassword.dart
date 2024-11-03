import 'package:flutter/material.dart';
import 'SignIn.dart';
import 'SignUp.dart';
import 'VerifyEmail.dart';
import 'package:mapsnap_fe/Widget/passwordForm.dart';
import 'package:mapsnap_fe/Widget/normalForm.dart';
import 'package:mapsnap_fe/Widget/outline_IconButton.dart';
import 'Finish.dart';



class CreateNewPassword extends StatelessWidget {
  const CreateNewPassword({super.key});

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
                  "Create New Password",
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Text(
                  "Please enter and confirm your new password."
                      "You will need to login after you reset.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
              ),
              // Các ô nhập liệu
              Padding(
                padding: const EdgeInsets.only(top: 30),
                // child: passwordForm(label:'Password'),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30),
                // child: passwordForm(label:'Confirm Password'),
              ),
              Expanded(child: Container()),

              // Nút Register
              Padding(
                padding: const EdgeInsets.only(bottom: 40),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => SignIn()),
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
