import 'package:flutter/material.dart';
import 'package:mapsnap_fe/ForgotPassword.dart';
import 'package:mapsnap_fe/SignUp.dart';
import 'Widget/passwordForm.dart';
import 'Widget/normalForm.dart';
import 'Widget/outline_IconButton.dart';
import 'Finish.dart';



class SignIn extends StatelessWidget {
  const SignIn({super.key});

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
              ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: Image(
                  image: AssetImage("assets/Login/SignIn.png"),
                  height: 300,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 20),

              // Các ô nhập liệu
              normalForm(label:'Email'),
              SizedBox(height: 12),
              passwordForm(label:'Password'),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ForgotPassword()),
                      );
                    },
                    child: Text(
                      "Forgot password?",
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),

              // Nút Register
              ElevatedButton(
                onPressed: () {
                  // Navigator.pushReplacement(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => Finish()),
                  // );
                },
                style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50),
                    backgroundColor: Colors.lightBlueAccent
                ),
                child: Text('Sign In'),
              ),
              SizedBox(height: 20),

              // Hoặc Login với
              Row(
                children: [
                  Expanded(child: Divider()),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text('Or Login with'),
                  ),
                  Expanded(child: Divider()),
                ],
              ),
              SizedBox(height: 20),

              // Nút đăng ký với Google
              outline_IconButton(label: "Google", color: Colors.red,),
              SizedBox(height: 12),

              // Nút đăng ký với Facebook
              outline_IconButton(label: "Facebook", color: Colors.lightBlueAccent,),
              SizedBox(height: 20),

              // Đăng nhập nếu đã có tài khoản
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Doesnt have an account? "),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => SignUp()),
                      );
                    },
                    child: Text(
                      "Sign Up",
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
