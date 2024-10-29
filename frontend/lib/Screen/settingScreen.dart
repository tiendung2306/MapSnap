import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'securityScreen.dart';
import 'package:provider/provider.dart';
import '../Widget/accountModel.dart';
import 'AccountScreen.dart';
import 'helpScreen.dart';
import 'generalSettings.dart';



class settingScreen extends StatefulWidget {

  const settingScreen({Key? key}) : super(key: key);

  @override
  State<settingScreen> createState() => settingScreenState();
}

class settingScreenState extends State<settingScreen> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    var accountModel = Provider.of<AccountModel>(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
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
                    onTap: () {
                      print("Thoat ra");
                    },
                    child: Container(
                        width: screenWidth / 8,
                        height: screenWidth / 8,
                        child: Icon(Icons.keyboard_arrow_left,size: screenWidth / 8, color: Colors.black,)
                    ),
                  ),
                  Container(
                    child: Text("Cài đặt", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),),
                  ),

                  Container(
                    width: screenWidth / 8,
                    height: screenWidth / 8,
                    child: GestureDetector(
                      onTap: () {
                        print("Tim kiem");
                      },
                      child: Icon(Icons.search,size: screenWidth / 8, color: Colors.black,),
                    ),
                  ),
                ],
              ),
              SizedBox(height: screenHeight / 50),
              Container(
                child: Row(
                  children: [
                    // Container(
                    //   width: 80,
                    //   height: 80,
                    //   decoration: BoxDecoration(
                    //     shape: BoxShape.circle,
                    //     color: Colors.red,
                    //   ),
                    // ),
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey,
                        image: accountModel.image != null
                            ? DecorationImage(
                          image: FileImage(File(accountModel.image!.path)), // Sử dụng FileImage để hiển thị ảnh
                          fit: BoxFit.cover,
                        )
                            : null,
                      ),
                      child: accountModel.image == null
                          ? Center(
                            child: Icon(
                              Icons.person_2_rounded,
                              color: Colors.black12,
                              size: 60,
                            ),
                           )
                          : null,
                    ),

                    SizedBox(width: screenWidth / 20),

                    Container(
                        child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(accountModel.username, style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold) ,),
                              const SizedBox(height: 5,),
                              Text(accountModel.email, style: TextStyle(fontSize: 15 )),
                            ]
                        )
                    )
                  ],
                ),
              ),
              const SizedBox(height: 10,),
              Container(
                width: double.infinity,
                height: 2,
                color: const Color(0xD8E8E8E8),
              ),
              const SizedBox(height: 25,),

              Container(
                padding: EdgeInsets.symmetric(horizontal: screenWidth / 15),
                child: Column(
                  children: [
                    Material(
                      color: Colors.white,
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => accountScreen()),
                          );
                        },
                        splashColor: Colors.grey.withOpacity(0.2),
                        child: buildButtonSetting(Icons.person_add,"Tài khoản","Thông tin cá nhân: gmail,sđt,...",screenWidth),
                      ),
                    ),
                    const SizedBox(height: 30),

                    Material(
                        color: Colors.white,
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => securityScreen()),
                            );
                          },
                          splashColor: Colors.grey.withOpacity(0.2),
                          child: buildButtonSetting(Icons.lock,"Bảo mật","Đổi mật khẩu ",screenWidth),
                        )
                    ),
                    const SizedBox(height: 30),

                    Material(
                        color: Colors.white,
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => generalSettings()),
                            );
                          },
                          splashColor: Colors.grey.withOpacity(0.2),
                          child: buildButtonSetting(Icons.settings,"Cài đặt chung","Giao diện, ngôn ngữ,...",screenWidth),
                        )
                    ),
                    const SizedBox(height: 30),

                    Material(
                        color: Colors.white,
                        child: InkWell(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  backgroundColor: Colors.white,
                                  title: const Text("Thông báo", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),),
                                  content: Text("Tính năng đang được phát triển", style: TextStyle(fontSize: 20,)),
                                  actions: <Widget>[
                                    new ElevatedButton(
                                      child: new Text('OK', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),),
                                      style: TextButton.styleFrom(
                                        backgroundColor: Colors.blue,
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
                          splashColor: Colors.grey.withOpacity(0.2),
                          child: buildButtonSetting(Icons.notifications,"Thông báo","Cài đặt thông báo",screenWidth),
                        )
                    ),
                    const SizedBox(height: 30),

                    Material(
                        color: Colors.white,
                        child: InkWell(
                          onTap: () {
                            print("Đăng xuất");
                          },
                          splashColor: Colors.grey.withOpacity(0.2),
                          child: buildButtonSetting(Icons.logout,"Đăng xuất","Thoát khỏi tài khoản hiện tại",screenWidth),
                        )
                    ),
                    const SizedBox(height: 30),

                    Material(
                        color: Colors.white,
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => helpScreen()),
                            );
                          },
                          splashColor: Colors.grey.withOpacity(0.2),
                          child: buildButtonSetting(Icons.help,"Trợ giúp","NPT khều donate",screenWidth),
                        )
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildButtonSetting(IconData icon, String text, String subText, double screenWidth) {
    return Container(
      width: screenWidth * 11 / 15,
      height: screenWidth / 6,
      child: Row(
        children: [
          Container(
              width: 50,
              height: 50,
              child: Icon(icon,size: screenWidth / 8, color: Colors.deepOrangeAccent,)
          ),
          SizedBox(width: 20),
          Container(
            child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(text, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold) ,),
                  SizedBox(height: 5,),
                  Text(subText, style: TextStyle(fontSize: 15 )),
                ]
            ),
          ),
        ],
      ),
    );
  }
}

