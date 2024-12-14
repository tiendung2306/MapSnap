
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mapsnap_fe/LocationScreen/addLocationScreen.dart';
import 'package:mapsnap_fe/LocationScreen/cityScreen.dart';
import 'package:mapsnap_fe/LocationScreen/filterLocationScreen.dart';
import 'package:mapsnap_fe/LocationScreen/myLocationScreen.dart';
import 'package:mapsnap_fe/LocationScreen/thirdScreen.dart';

import '../Widget/bottomNavigationBar.dart';


class locationScreen extends StatefulWidget {

  const locationScreen({Key? key}) : super(key: key);

  @override
  State<locationScreen> createState() => _locationScreenState();
}

class _locationScreenState extends State<locationScreen> {

  @override
  void initState() {
    super.initState();
  }

  int currentTabIndex = 0;

  void onTabTapped(int index) {
    setState(() {
      currentTabIndex = index;
    });
    print("Tab $index selected");
  }


  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      endDrawer: Container(
        width: MediaQuery.of(context).size.width * 0.7,
        child: Drawer(
          backgroundColor: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                color: Colors.blueAccent,
                width: MediaQuery.of(context).size.width * 0.7,
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16), // Giảm padding
                child: Text(
                  "Tùy chọn",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.add),
                title: Text("Thêm địa điểm"),
                onTap: () {
                  Navigator.pop(context); // Đóng drawer
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => addLocationScreen(),
                    ),
                  );
                },
              ),
              Divider(color: Colors.grey, thickness: 1),
              ListTile(
                leading: Icon(Icons.search),
                title: Text("Tìm kiếm nâng cao"),
                onTap: () {
                  Navigator.pop(context); // Đóng drawer
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => filterLocationScreen(),
                    ),
                  );
                },
              ),
              Divider(color: Colors.grey, thickness: 1),

            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Stack(
            children: [
              Image.asset(
                'assets/Image/Background.png',
                width: screenHeight,
                height: screenHeight,
                fit: BoxFit.none,
              ),
              Container(
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: screenWidth / 40),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: screenHeight / 80),
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                    width: 50,
                                    height: 50,
                                    child: Icon(Icons.chevron_left, size: 50,),
                                  ),
                                ),
                                Text('Địa điểm', style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),),
                                Builder(
                                  builder: (BuildContext context) {
                                    return GestureDetector(
                                      onTap: () {
                                        Scaffold.of(context).openEndDrawer();
                                      },
                                      child: Container(
                                        width: 50,
                                        height: 50,
                                        child: Icon(Icons.dehaze, size: 50,),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 10),
                          Container(
                            height: screenHeight * 4 / 5 + 5,
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
                              length: 3,
                              child: Scaffold(
                                appBar: AppBar(
                                  backgroundColor: Colors.white, // Màu nền trắng
                                  toolbarHeight: 0, // Điều chỉnh chiều cao của AppBar
                                  bottom: TabBar(
                                    indicatorColor: Colors.black, // Màu chỉ báo của tab
                                    labelColor: Colors.black, // Màu của văn bản trong tab
                                    unselectedLabelColor: Colors.grey, // Màu văn bản tab chưa chọn
                                    labelStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold), // Kích thước chữ khi được chọn
                                    tabs: [
                                      Tab(text: "Thành phố"),
                                      Tab(text: "Của tôi"),
                                      Tab(text: "Yêu thích",)
                                    ],
                                  ),
                                ),
                                body: TabBarView(

                                  children: [
                                    cityScreen(),
                                    myLocationScreen(),
                                    thirdScreen(),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
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
