import 'package:flutter/material.dart';
import 'package:mapsnap_fe/Widget//text_field_input.dart';
import 'package:provider/provider.dart';
import '../Widget/accountModel.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class securityScreen extends StatefulWidget {
  const securityScreen({Key? key}) : super(key: key);

  @override
  State<securityScreen> createState() => _securityScreenState();
}

class _securityScreenState extends State<securityScreen> {


  String Notification = "";
  late Color colorNotification;

  int checkPassword = -1;
  late TextEditingController passwordController = TextEditingController();
  final TextEditingController newPasswordController1 = TextEditingController();
  final TextEditingController newPasswordController2 = TextEditingController();


  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;


    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: GestureDetector(
        onTap: () {
          // Bỏ chọn tất cả các TextField khi bấm ra ngoài
          FocusScope.of(context).unfocus();
        },
        child: SafeArea(
          // Màn hình di chuyển khi hiện bàn phím ảo che phần nhập
          child: SingleChildScrollView(
            child: Stack(
                children: [
                  Container(
                    width: screenWidth,
                    color: Colors.white,
                    height: screenHeight,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: screenWidth / 15),
                    width: double.infinity,
                    color: Colors.white,
                    child: Column(
                      children: [
                        SizedBox(height: screenHeight / 70),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () async {
                                FocusScope.of(context).unfocus();
                                // Khoảng trễ cho dòng code tiếp theo
                                await Future.delayed(Duration(milliseconds: 500));
                                Navigator.pop(context);
                              },
                              child: Container(
                                width: screenWidth / 8,
                                height: screenWidth / 8,
                                child: Icon(
                                  Icons.keyboard_arrow_left,
                                  size: screenWidth / 8,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            Container(
                              child: Text(
                                "Bảo mật",
                                style: TextStyle(fontSize: 30),
                              ),
                            ),
                            Container(
                              width: screenWidth / 8,
                              height: screenWidth / 8,
                              child: GestureDetector(
                                onTap: () {
                                  print("Tìm kiếm");
                                },
                                child: Icon(
                                  Icons.search,
                                  size: screenWidth / 8,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: screenHeight / 50),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Container(
                            padding:
                            EdgeInsets.symmetric(horizontal: screenWidth / 10),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                buildTextField("Nhập mật khẩu", passwordController, "Mật khẩu hiện tại", TextInputType.text,false),
                                const SizedBox(height: 15),
                                buildTextField("Nhập mật khẩu mới", newPasswordController1, "Mật khẩu mới", TextInputType.text,true),
                                const SizedBox(height: 15),
                                buildTextField("Nhập lại mật khẩu mới", newPasswordController2, "Nhập lại mật khẩu mới", TextInputType.text,true),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: screenHeight/30,),
                        Material(
                          color: Colors.blueAccent,
                          borderRadius: BorderRadius.circular(15),
                          child: InkWell(
                              onTap: () async {
                                if(passwordController.text.isEmpty || newPasswordController1.text.isEmpty || newPasswordController2.text.isEmpty) {
                                  Notification = "Vui lòng nhập thông tin";
                                  colorNotification = Colors.red;
                                } else if (newPasswordController1.text != newPasswordController2.text){
                                  Notification = "Nhập sai mật khẩu mới";
                                  colorNotification = Colors.red;
                                }
                                else if (newPasswordController1.text.length < 8){
                                  Notification = "Mật khẩu phải lớn hơn 7 ký tự";
                                  colorNotification = Colors.red;
                                } else if (!newPasswordController1.text.contains(RegExp(r'\d'))) {
                                  Notification = "Mật khẩu phải chứa ít nhất một số";
                                  colorNotification = Colors.red;
                                } else {
                                  await changePassword(passwordController.text,newPasswordController1.text);
                                  if(checkPassword == 0) {
                                    Notification = "Nhập sai mật khẩu";
                                    colorNotification = Colors.red;
                                  }
                                  if(checkPassword == 1) {
                                    Notification = "Đổi mật khẩu thành công";
                                    colorNotification = Colors.blue;
                                  }
                                }


                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      backgroundColor: Colors.white,
                                      title: const Text("Thông báo", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),),
                                      content: Text(Notification, style: TextStyle(fontSize: 20,)),
                                      actions: <Widget>[
                                        new ElevatedButton(
                                          child: new Text('OK', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),),
                                          style: TextButton.styleFrom(
                                            backgroundColor: colorNotification,
                                          ),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        )
                                      ],
                                    );
                                  },
                                );
                              },
                              splashColor: Colors.white.withOpacity(0.2),
                              child: Container(
                                width: screenWidth * 2 / 3,
                                height: 50,
                                child: Center(
                                  child: Text("Lưu thay đổi", style: TextStyle(color: Colors.white,
                                      fontSize: 20, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              )
                          ),
                        ),
                      ],
                    ),
                  ),
                ]
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String label, TextEditingController controller, String hintText, TextInputType inputType,bool isPass,  {bool enabled = true}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 3),
        TextFieldInput(
          textEditingController: controller,
          hintText: hintText,
          textInputType: inputType,
          isPass: isPass,
          isEnabled: enabled,
        ),
      ],
    );
  }

  Future<void> changePassword(String oldPassword,String newPassword) async {
    var accountModel = Provider.of<AccountModel>(context, listen: false);
    final response = await http.post(
      Uri.parse('https://mapsnap.onrender.com/v1/auth/change-password'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'id': accountModel.idUser,
        'oldPassword': oldPassword,
        'newPassword': newPassword,
      }),
    );
    if (response.statusCode == 200) {
      checkPassword = 1;
      print("Đổi mk thành công");
    } else {
      checkPassword = 0;
      print("Đổi mk không thành công");
    }
  }
}