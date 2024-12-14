import 'package:flutter/material.dart';
import 'package:mapsnap_fe/Widget/bottomNavigationBar.dart';

class statisticScreen extends StatefulWidget {
  const statisticScreen({Key? key}) : super(key: key);

  @override
  State<statisticScreen> createState() => _statisticScreenState();
}

class _statisticScreenState extends State<statisticScreen> {
  int currentTabIndex = 0;

  void onTabTapped(int index) {
    setState(() {
      currentTabIndex = index;
    });
  }


  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Stack(
            children: [
              Image.asset(
                  'assets/Image/Background.png',
                  width: screenWidth,
                  height: screenHeight,
                  fit: BoxFit.none,
              ),
              Container(
                child: Column(
                  children: [
                    SizedBox(height: screenHeight / 70),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: ()  {
                            Navigator.pop(context);
                          },
                          child: Container(
                            width: 50,
                            height: 50,
                            child: Icon(
                              Icons.keyboard_arrow_left,
                              size: 50,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Container(
                          child: Text(
                            "Thống kê",
                            style: TextStyle(fontSize: 30),
                          ),
                        ),
                        Container(
                          width: 50,
                          height: 50,
                        ),
                      ],
                    ),
                    SizedBox(height: 15,),
                    Container(
                      height: screenHeight * 4 / 5 - 10,
                      child: Image.asset(
                        'assets/Image/Thongke.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(height: screenHeight / 50),
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
              ),
            ]
        ),
      ),
    );
  }
}