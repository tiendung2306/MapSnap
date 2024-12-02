import 'package:flutter/material.dart';
import 'CreateNewPassword.dart';
import 'SignUp.dart';
import 'package:mapsnap_fe/Widget/passwordForm.dart';
import 'package:mapsnap_fe/Widget/normalForm.dart';
import 'package:mapsnap_fe/Widget/outline_IconButton.dart';
import '../Services/AuthService.dart';



class VerifyEmail extends StatefulWidget {
  const VerifyEmail({super.key});

  @override
  State<VerifyEmail> createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {
  final _authService = AuthService();

  late TextEditingController _pincodeController;

  bool isPincodeInvalid = false;

  String email = 'null';
  String title = 'null';

  String isComplete = 'Missing info';
  String errorMess = '';

  void loadData() async {
    String tmp = (await _authService.get('confirmEmail'))?? 'null';
    setState(() {
      email = tmp;
      title = "Code has been send to " + email +
          ".Enter the code to verify your account.";
    });
  }

  void initState() {
    loadData();
    _pincodeController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _pincodeController.dispose();
    super.dispose();
  }

  void post_verify() async {
    final resetPasswordToken = await _authService.getAccessToken();
    final response = await _authService.VerifyEmail(_pincodeController.text, resetPasswordToken.token);
    final mess = response['mess'];

    if(mess == "Verify success"){
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CreateNewPassword()),
      );
    }
    else if(mess == 'Verify failed'){
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

  void verify(){
    setState((){
      isComplete = 'true';
      isPincodeInvalid = false;

      if(_pincodeController.text == ''){
        isPincodeInvalid = true;
        isComplete = 'Missing info';
      }

      if(isComplete != 'true'){
        errorMess = 'Please fill out all infomation';
        return;
      }

      post_verify();

    });
  }

  void resendPincode() async {
    await _authService.SendPinCode(email);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => VerifyEmail()),
    );
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
                  title,
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
                ),
              // Các ô nhập liệu
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: normalForm(label:'4 Digit Code', controller: _pincodeController,),
              ),
              if(isPincodeInvalid)
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'Please fill this infomation!',
                    style: TextStyle(
                        color: Colors.red
                    ),
                  ),
                ),
              Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Didn’t Receive Code?"),
                      TextButton(
                          onPressed: (){
                            resendPincode();
                          },
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
                    verify();
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
