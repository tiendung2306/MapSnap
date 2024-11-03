import 'package:flutter/material.dart';
import 'SignIn.dart';
import 'package:mapsnap_fe/Widget/passwordForm.dart';
import 'package:mapsnap_fe/Widget/normalForm.dart';
import 'package:mapsnap_fe/Widget/outline_IconButton.dart';
import 'Finish.dart';
import 'Service.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});
  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _authService = AuthService();

  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmController;
  bool isNameInvalid = false;
  bool isEmailInvalid = false;
  bool isPasswordInvalid = false;
  bool isConfirmInvalid = false;
  String isComplete = 'Missing info';
  String errorMess = '';


  void initState() {
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void post_register() async {
    final response = await _authService.Register(_nameController.text, _emailController.text, _passwordController.text);
    final int statusCode = response['statusCode'];
    final data = response['data'];

    if(statusCode == 201){
      final String accessToken = data['tokens']['access']['token'];
      final String refreshToken = data['tokens']['refresh']['token'];
      await _authService.saveTokens(accessToken, refreshToken);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Finish()),
      );
    }

    else{
      isComplete = 'Invalid info';
      setState(() {
        errorMess = data['message'];
      });
    }
  }



  void register(){
    setState((){
      isComplete = 'true';
      isNameInvalid = false;
      isEmailInvalid = false;
      isPasswordInvalid = false;
      isConfirmInvalid = false;

      if(_nameController.text == ''){
        isNameInvalid = true;
        isComplete = 'Missing info';
      }
      if(_emailController.text == ''){
        isEmailInvalid = true;
        isComplete = 'Missing info';
      }
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

      post_register();

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
        child: SingleChildScrollView(

          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: Image(
                    image: AssetImage("assets/Login/SignUp.png"),
                    height: 300,
                    fit: BoxFit.cover,
                  ),
                ),
                if(isComplete != 'true')
                  Container(
                    margin: const EdgeInsets.all(10.0),
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
                SizedBox(height: 20),

                // Các ô nhập liệu
                normalForm(label:'Name', controller: _nameController,),
                if(isNameInvalid)
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'Please fill this infomation!',
                      style: TextStyle(
                        color: Colors.red
                      ),
                    ),
                  )
                else
                  SizedBox(height: 12),
                normalForm(label:'Email', controller: _emailController,),
                if(isEmailInvalid)
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'Please fill this infomation!',
                      style: TextStyle(
                          color: Colors.red
                      ),
                    ),
                  )
                else
                  SizedBox(height: 12),
                passwordForm(label:'Password', controller: _passwordController,),
                if(isPasswordInvalid)
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'Please fill this infomation!',
                      style: TextStyle(
                          color: Colors.red
                      ),
                    ),
                  )
                else
                  SizedBox(height: 12),
                passwordForm(label:'Confirm Password', controller: _confirmController,),
                if(isConfirmInvalid)
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      _passwordController.text == _confirmController.text ? 'Please fill this infomation!' : 'Unmatch password',
                      style: TextStyle(
                          color: Colors.red
                      ),
                    ),
                  )
                else
                SizedBox(height: 20),

                // Nút Register
                ElevatedButton(
                  onPressed: () {
                    register();
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50),
                    backgroundColor: Colors.lightBlueAccent
                  ),
                  child: Text('Register'),
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
                    Text("Already have an account? "),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => SignIn()),
                        );
                      },
                      child: Text(
                        "Login",
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
