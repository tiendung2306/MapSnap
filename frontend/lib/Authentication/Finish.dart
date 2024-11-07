import 'package:flutter/material.dart';
import 'package:mapsnap_fe/Screen/AccountScreen.dart';
import 'package:mapsnap_fe/Screen/settingScreen.dart';
import 'package:provider/provider.dart';
import '../Widget/accountModel.dart';
import 'package:mapsnap_fe/Widget/UpdateUser.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../main.dart';
import 'Service.dart';

class Finish extends StatefulWidget {
  const Finish({super.key});

  @override
  State<Finish> createState() => _FinishState();
}
// class Token {
//   String token_access;
//   String token_access_expires;
//   String token_refresh;
//   String token_refresh_expires;
//   String idUser;
//
//   Token({required this.token_access,required this.token_access_expires,required this.token_refresh,required this.token_refresh_expires,required this.idUser});
//
//   factory Token.fromJson(Map<String, dynamic> json) {
//     return Token(
//       token_access: json['tokens']['access']['token'] ?? 'NoTokenAccess',
//       token_access_expires: json['tokens']['access']['expires'] ?? 'NoTokenAccessExpires',
//       token_refresh: json['tokens']['refresh']['token'] ?? 'NoTokenRefresh',
//       token_refresh_expires: json['tokens']['refresh']['expires'] ?? 'NoTokenRefreshExpires',
//       idUser: json['user']['id'] ?? 'NoID',
//     );
//   }
// }
//
//
// Future<Token> Login(String email,String password) async {
//   final response = await http.post(
//     Uri.parse('http://10.0.2.2:3000/v1/auth/login'),
//     headers: <String, String>{
//       'Content-Type': 'application/json; charset=UTF-8',
//     },
//     body: jsonEncode(<String, String>{
//       'email': email,
//       'password': password,
//     }),
//   );
//   if (response.statusCode == 200) {
//     print("Đăng nhập thành công");
//     var data = jsonDecode(response.body) as Map;
//     return Token(
//       token_access: data['tokens']['access']['token'] ?? 'NoTokenAccess',
//       token_access_expires: data['tokens']['access']['expires'] ?? 'NoTokenAccessExpires',
//       token_refresh: data['tokens']['refresh']['token'] ?? 'NoTokenRefresh',
//       token_refresh_expires: data['tokens']['refresh']['expires'] ?? 'NoTokenRefreshExpires',
//       idUser: data['user']['id'] ?? 'NoID',
//     );
//   } else {
//     throw Exception(response.statusCode);
//   }
// }

class _FinishState extends State<Finish> {
  final _authService = AuthService();

  void to_InApp() async {
    final user = await _authService.getUser();
    Token token = await Login(user.id, 'a1234567');
    // User? user = await fetchData(token.idUser,token.token_access);
    // Provider.of<AccountModel>(context, listen: false).setUser(user!);
    Provider.of<AccountModel>(context, listen: false).setToken(token);
    print('--------------------------------------asdasdasdada');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => settingScreen()),
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
          padding: const EdgeInsets.all(40),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Image(
                  image: AssetImage("assets/Login/Finish.png"),
                  height: 300,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 20),

              Text(
                "Account setup complete!",
                style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Enjoy",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                ),
              ),
              Expanded(
                  child: Container(
                        //null
                  )
              ),
              ElevatedButton(
                onPressed: () {
                  to_InApp();
                },
                style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50),
                    backgroundColor: Colors.lightBlueAccent
                ),
                child: Text('Start'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

