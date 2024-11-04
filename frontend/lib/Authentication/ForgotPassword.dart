import 'package:flutter/material.dart';
import 'SignUp.dart';
import 'VerifyEmail.dart';
import 'Finish.dart';
import 'package:mapsnap_fe/Widget/passwordForm.dart';
import 'package:mapsnap_fe/Widget/normalForm.dart';
import 'package:mapsnap_fe/Widget/outline_IconButton.dart';
import 'Service.dart';
import 'package:mapsnap_fe/Model/Token.dart';



class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _authService = AuthService();

  late TextEditingController _emailController;

  bool isEmailInvalid = false;

  String isComplete = 'Missing info';
  String errorMess = '';

  void initState() {
    _emailController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void post_confirm() async {
    final response = await _authService.SendPinCode(_emailController.text);
    final int statusCode = response['statusCode'];
    final data = response['data'];

    if(statusCode == 200){
      final token = data['resetPasswordToken'];
      final expires = data['expires'];
      final accessToken = Token(token: token, expires: expires);
      await _authService.saveAccessTokens(accessToken);
      await _authService.save('confirmEmail', _emailController.text);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => VerifyEmail()),
      );
    }

    else{
      isComplete = 'Invalid info';
      setState(() {
        errorMess = data['message'];
      });
    }
  }

  void confirmEmail(){
    setState((){
      isComplete = 'true';
      isEmailInvalid = false;

      if(_emailController.text == ''){
        isEmailInvalid = true;
        isComplete = 'Missing info';
      }

      if(isComplete != 'true'){
        errorMess = 'Please fill out all infomation';
        return;
      }

      post_confirm();

    });
  }

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

              if(isComplete != 'true')
                Container(
                  height: 40,
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      errorMess,
                      style: TextStyle(
                          color: Colors.red,
                          fontSize: 20
                      ),
                    ),
                  ),
                )
              else
                SizedBox(height : 40),
              // Các ô nhập liệu
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: normalForm(label:'Email', controller: _emailController,),
              ),
              if(isEmailInvalid)
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'Please fill this infomation!',
                    style: TextStyle(
                        color: Colors.red
                    ),
                  ),
                ),

              Expanded(child: Container()),

              // Nút Register
              Padding(
                padding: const EdgeInsets.only(bottom: 40),
                child: ElevatedButton(
                  onPressed: () {
                    confirmEmail();
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
