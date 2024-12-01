import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mapsnap_fe/PersonalPageScreen/albumScreen.dart';
import 'package:mapsnap_fe/PersonalPageScreen/postScreen.dart';
import 'package:mapsnap_fe/SettingScreen/settingScreen.dart';
import 'package:mapsnap_fe/Camera/mainScreenCamera.dart';
import 'package:provider/provider.dart';

import '../Widget/AutoRefreshToken.dart';
import '../Widget/accountModel.dart';
import '../Widget/bottomNavigationBar.dart';


class personalPageScreen extends StatefulWidget {

  const personalPageScreen({Key? key}) : super(key: key);

  @override
  State<personalPageScreen> createState() => personalPageScreenState();
}

class personalPageScreenState extends State<personalPageScreen> {
  XFile? _image;


  @override
  void initState() {
    // 2 dòng này sẽ được để vào HomeScreen để liên tục làm mới token
    // var accountModel = Provider.of<AccountModel>(context, listen: false);
    // startAutoRefreshToken(context, accountModel.token_refresh_expires,accountModel.token_refresh,accountModel.idUser);
    //===============================================================
    _loadImage();
    super.initState();
  }

  int currentTabIndex = 4;

  void onTabTapped(int index) {
    setState(() {
      currentTabIndex = index;
    });
    print("Tab $index selected");
  }

  Future<void> _loadImage() async {
    var accountModel = Provider.of<AccountModel>(context, listen: true);
    final imagePath =  'http://10.0.2.2:3000${accountModel.avatar}';// Lấy đường dẫn ảnh
    if (imagePath != null) {
      setState(() {
        _image = XFile(imagePath); //Chuyển đường dẫn thành ảnh
      });
    } else {
      print("Đường dẫn ảnh không hợp lệ");
    }
  }

  @override
  Widget build(BuildContext context) {
    var accountModel = Provider.of<AccountModel>(context, listen: false);
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
            children: [
              Image.asset(
                'assets/Login/Background.png',
                width: screenHeight,
                height: screenHeight,
                fit: BoxFit.none,
              ),
              Container(
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: screenWidth / 15),
                      width: screenWidth,
                      // color: Colors.white,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: screenHeight / 70),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  print("Đổi tài khoản");
                                },
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: screenWidth * 1 / 2,
                                      child: Text(
                                        accountModel.email,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: TextStyle(
                                            fontSize: 30,
                                            fontWeight: FontWeight.bold
                                        ),
                                      ),
                                    ),
                                    Icon(Icons.expand_more, size: screenWidth / 10,
                                      color: Colors.black,),
                                  ],
                                ),
                              ),


                              Container(
                                width: screenWidth / 8,
                                height: screenWidth / 8,
                                child: GestureDetector(
                                  onTap: () {
                                    print("Cài đặt");
                                    Navigator.push(
                                      context,
                                      PageRouteBuilder(
                                        pageBuilder: (context, animation, secondaryAnimation) =>  settingScreen(),
                                        transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                          const begin = Offset(1.0, 0.0); // Bắt đầu từ bên phải
                                          const end = Offset.zero;        // Kết thúc ở vị trí bình thường
                                          const curve = Curves.ease;

                                          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                                          var offsetAnimation = animation.drive(tween);

                                          return SlideTransition(
                                            position: offsetAnimation,
                                            child: child,
                                          );
                                        },
                                      ),
                                    );
                                  },
                                  child: Icon(Icons.dehaze, size: screenWidth / 9,
                                    color: Colors.black,),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: screenHeight / 50),
                          Container(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: screenWidth / 4,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Consumer<AccountModel>(
                                        builder: (context, accountModel, child) {
                                          return Container(
                                            width: 80,
                                            height: 80,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.grey,
                                              image: accountModel.avatar.isNotEmpty
                                                  ? DecorationImage(
                                                image: NetworkImage(accountModel.avatar),
                                                fit: BoxFit.cover,
                                              )
                                                  : null,
                                            ),
                                          );
                                        },
                                      ),
                                      const SizedBox(height: 10,),
                                      Container(
                                          child: Text(
                                            accountModel.username,
                                            style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
                                            overflow: TextOverflow.ellipsis,
                                          )
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: screenWidth / 20),
                                Expanded(
                                  child: Row(
                                    children: [
                                      Flexible(
                                        child: Material(
                                          color: Colors.transparent, // Màu nền để không che mất hiệu ứng và nền
                                          child: InkWell(
                                            onTap: () {
                                              print("Bài viết được nhấn");
                                              // Thêm hành động khi nhấn vào "bài viết"
                                            },
                                            splashColor: Colors.grey,
                                            child: Column(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                const SizedBox(height: 10,),
                                                Text(
                                                  "0",
                                                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                ),
                                                const SizedBox(height: 5),
                                                Text(
                                                  "bài viết",
                                                  style: TextStyle(fontSize: 16),
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: screenWidth / 20),
                                      Flexible(
                                        child: Material(
                                          color: Colors.transparent, // Màu nền để không che mất hiệu ứng và nền
                                          child: InkWell(
                                            onTap: () {
                                              print("Người theo dõi được nhấn");
                                              // Thêm hành động khi nhấn vào "người theo dõi"
                                            },
                                            splashColor: Colors.grey,
                                            child: Column(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                const SizedBox(height: 10,),
                                                Text(
                                                  "1000",
                                                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                ),
                                                const SizedBox(height: 5),
                                                Text(
                                                  "người theo dõi",
                                                  style: TextStyle(fontSize: 16),
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: screenWidth / 20),
                                      Flexible(
                                        child: Material(
                                          color: Colors.transparent,
                                          child: InkWell(
                                            onTap: () {
                                              print("Đang theo dõi được nhấn");
                                            },
                                            splashColor: Colors.grey,
                                            child: Column(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                const SizedBox(height: 10,),
                                                Text(
                                                  "500",
                                                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                ),
                                                const SizedBox(height: 5),
                                                Text(
                                                  "đang theo dõi",
                                                  style: TextStyle(fontSize: 16),
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10,),
                          Container(
                            height: screenHeight * 2 / 3 - 15,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2), // Màu của bóng
                                  spreadRadius: 2, // Phóng tỏa bóng
                                  blurRadius: 8, // Làm mờ bóng
                                  offset: Offset(5, 5), // Vị trí bóng (Offset theo trục X, Y)
                                ),
                              ],
                            ),
                            child: DefaultTabController(
                              length: 2,
                              child: Scaffold(
                                appBar: AppBar(
                                  backgroundColor: Colors.white, // Màu nền trắng
                                  toolbarHeight: 0, // Điều chỉnh chiều cao của AppBar
                                  // elevation: 0, // Xóa bóng của AppBar
                                  bottom: TabBar(
                                    indicatorColor: Colors.black, // Màu chỉ báo của tab
                                    labelColor: Colors.black, // Màu của văn bản trong tab
                                    unselectedLabelColor: Colors.grey, // Màu văn bản tab chưa chọn
                                    labelStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold), // Kích thước chữ khi được chọn
                                    tabs: [
                                      Tab(text: "Bài viết"),
                                      Tab(text: "Album")
                                    ],
                                  ),
                                ),
                                body: TabBarView(

                                  children: [
                                    postScreen(),
                                    albumScreen(),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 15),
                    Container(
                      height: 3,
                      color: Colors.grey,
                    ),
                    Expanded(
                      child: CustomBottomNav(
                        onTabTapped: onTabTapped,
                        currentIndex: currentTabIndex,
                      ),
                    ),
                  ],
                ),
              )
            ]
        ),
      ),
    );
  }
}
