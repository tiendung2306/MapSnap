import 'package:flutter/material.dart';
import 'CreateNewPassword.dart';
import 'SignUp.dart';
import 'package:mapsnap_fe/Widget/passwordForm.dart';
import 'package:mapsnap_fe/Widget/normalForm.dart';
import 'package:mapsnap_fe/Widget/outline_IconButton.dart';
import 'Finish.dart';



class VerifyEmail extends StatelessWidget {
  const VerifyEmail({super.key});

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
                  "Verify Account",
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Text(
                  "Code has been send to johndoe@gmail.com."
                      "Enter the code to verify your account.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
              ),
              // Các ô nhập liệu
              Padding(
                padding: const EdgeInsets.only(top: 30),
                // child: normalForm(label:'4 Digit Code'),
              ),
              // passwordForm(label:'Password'),
              // SizedBox(height: 20),
              Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Didn’t Receive Code?"),
                      TextButton(
                          onPressed: (){},
                          child: Text(
                              "Resend Code",
                              style: TextStyle(
                                fontWeight: FontWeight.bold
                              ),
                          )
                      ),
                    ],
                  )
              ),
              // Nút Register
              Padding(
                padding: const EdgeInsets.only(bottom: 40),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CreateNewPassword()),
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
