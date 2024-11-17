import 'package:flutter/material.dart';
import 'SignIn.dart';
import 'SignUp.dart';
import 'VerifyEmail.dart';
import 'package:mapsnap_fe/Widget/passwordForm.dart';
import 'package:mapsnap_fe/Widget/normalForm.dart';
import 'package:mapsnap_fe/Widget/outline_IconButton.dart';
import 'Finish.dart';
import '../Services/AuthService.dart';


class CreateNewPassword extends StatefulWidget {
  const CreateNewPassword({super.key});

  @override
  State<CreateNewPassword> createState() => _CreateNewPasswordState();
}

class _CreateNewPasswordState extends State<CreateNewPassword> {
  final _authService = AuthService();

  late TextEditingController _passwordController;
  late TextEditingController _confirmController;

  bool isPasswordInvalid = false;
  bool isConfirmInvalid = false;

  String isComplete = 'Missing info';
  String errorMess = '';

  void initState() {
    _passwordController = TextEditingController();
    _confirmController = TextEditingController();
    super.initState();
  }
  void post_createPassword() async {
    final resetPasswordToken = await _authService.getAccessToken();
    final response = await _authService.ResetPassword(_passwordController.text, resetPasswordToken.token);
    final mess = response['mess'];

    if(mess == 'Reset password success'){
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SignIn()),
      );
    }

    else if(mess == 'Reset password failed'){
      final data = response['data'];
      isComplete = 'Invalid info';
      setState(() {
        errorMess = data == null ? 'Unknown information error!' : data['message'];
      });
    }
    else{
      isComplete = 'Connection error';
      setState(() {
        errorMess = 'Connection error!';
      });
    }
  }



  void createPassword(){
    setState((){
      isComplete = 'true';
      isPasswordInvalid = false;
      isConfirmInvalid = false;

      if(_passwordController.text == ''){
        isPasswordInvalid = true;
        isComplete = 'Missing info';
      }
      if(_confirmController.text == '' || _confirmController.text != _passwordController.text){
        isConfirmInvalid = true;
        isComplete = 'Missing info';
      }

      if(isComplete != 'true'){
        errorMess = 'Please fill out all infomation';
        return;
      }

      post_createPassword();

    });
  }
  @override
  void dispose() {
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
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
                SizedBox(height: 40),
              // Các ô nhập liệu
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: passwordForm(label:'Password', controller: _passwordController,),
              ),
              if(isPasswordInvalid)
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'Please fill this infomation!',
                    style: TextStyle(
                        color: Colors.red
                    ),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: passwordForm(label:'Confirm Password', controller: _confirmController,),
              ),
              if(isConfirmInvalid)
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    _passwordController.text == _confirmController.text ? 'Please fill this infomation!' : 'Unmatch password',
                    style: TextStyle(
                        color: Colors.red
                    ),
                  ),
                ),

              Expanded(child: Container()),

              // Nút xác nhận
              Padding(
                padding: const EdgeInsets.only(bottom: 40),
                child: ElevatedButton(
                  onPressed: () {
                    createPassword();
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
