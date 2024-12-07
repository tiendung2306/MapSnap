import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mapsnap_fe/InApp/Journeys.dart';
import 'package:mapsnap_fe/InApp/Map.dart';
import 'package:mapsnap_fe/Widget/AutoRefreshToken.dart';
import 'package:mapsnap_fe/Widget/accountModel.dart';
import 'package:provider/provider.dart';

import '../LocationScreen/locationScreen.dart';
import '../NewFeed/newFeedScreen.dart';
import '../PictureScreen/pictureManager.dart';
import 'package:mapsnap_fe/Widget/bottomNavigationBar.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  void initState() {
    // 2 dòng này sẽ được để vào HomeScreen để liên tục làm mới token
    var accountModel = Provider.of<AccountModel>(context, listen: false);
    startAutoRefreshToken(context, accountModel.token_refresh_expires,accountModel.token_refresh,accountModel.idUser);
    //===============================================================
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int currentTabIndex = 0;

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double Xpix = screenWidth * 0.01; // Chiều rộng bằng 10% chiều rộng màn hình
    double Ypix = screenHeight * 0.01; // Chiều rộng bằng 10% chiều rộng màn hình

    void onTabTapped(int index) {
      setState(() {
        currentTabIndex = index;
      });
    }

    Widget Header(){
      return Padding(
        padding: const EdgeInsets.only(left: 10.0, right: 10.0, top:  10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon:  Image.asset("assets/Common/logo.png"),
              onPressed: () {},
            ),
            Expanded(
              child: SizedBox(
                height: 5 * Ypix,
                child: TextField(
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: 8.0),
                    label: Text(
                      'Search',
                      style: TextStyle(
                          fontSize: 18
                      ),
                    ),
                    prefixIcon: Image.asset("assets/Common/search.png"),
                    fillColor: Colors.black.withOpacity(0.2),
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            ),
            IconButton(
              icon:  Image.asset("assets/Common/nofi.png"),
              onPressed: () {},
            ),
          ],
        ),
      );
    }

    Widget Tilte(){
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/Common/VN.png', width: 30, height: 20),
                SizedBox(width: 8),
                Text("Vietnam", style: TextStyle(fontSize: 18)),
              ],
            ),
            SizedBox(height: 10),
            Text(
              "40",
              style: TextStyle(fontSize: 60, fontWeight: FontWeight.bold),
            ),
            Text(
              "Available journeys",
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: () {},
              icon: Image.asset("assets/Common/add.png"),
              label: Text(
                "Create new journey",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold
                ),
              ),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                side: BorderSide(
                    color: Colors.black,
                    width: 4
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ],
        ),
      );
    }

    Widget MainFeatures(){
      return
        Container(
          // height: 70,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5), // Màu bóng và độ trong suốt
                spreadRadius: 5,   // Độ lan của bóng
                blurRadius: 10,    // Độ mờ của bóng
                offset: Offset(0, 3), // Độ lệch của bóng (x, y)
              )
            ],
            borderRadius: BorderRadius.circular(15),
          ),
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      IconButton(
                        icon: Icon(Icons.map, size: 30,),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => MapScreen()),
                          );
                        },
                      ),
                      Text('Map'),
                    ],
                  ),
                  Column(
                    children: [
                      IconButton(
                        icon: Icon(Icons.photo, size: 30,),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => pictureManager()),
                          );
                        },
                      ),
                      Text('Picture'),
                    ],
                  ),
                  Column(
                    children: [
                      IconButton(
                        icon: Icon(Icons.favorite, size: 30,),
                        onPressed: () {},
                      ),
                      Text('Favorite')
                    ],
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      IconButton(
                        icon: Image.asset("assets/Common/journey.png"),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Journeys()),
                          );
                        },
                      ),
                      Text('Journey'),
                    ],
                  ),
                  Column(
                    children: [
                      IconButton(
                        icon: Icon(Icons.newspaper, size: 30,),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => newFeedScreen()),
                          );
                        },
                      ),
                      Text('Feed'),
                    ],
                  ),
                  Column(
                    children: [
                      IconButton(
                        icon: Icon(Icons.location_pin, size: 30,),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => locationScreen()),
                          );
                        },
                      ),
                      Text('Location')
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
    }

    Widget LastJourneys(){
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Last journeys",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Container(
            height: Ypix * 50,
            child: ListView(
              children: [
                JourneyTile(
                  title: "Tây du ký",
                  subtitle: "81 kiếp nạn",
                  icon: Icons.directions_walk,
                ),
                JourneyTile(
                  title: "Đi tù",
                  subtitle: "12 năm",
                  icon: Icons.directions_run,
                ),
                JourneyTile(
                  title: "Đại hải trình",
                  subtitle: "1122 tập",
                  icon: Icons.sailing,
                ),
                JourneyTile(
                  title: "Học đại học",
                  subtitle: "Ongoing",
                  icon: Icons.school,
                ),
                JourneyTile(
                  title: "Học đại học",
                  subtitle: "Ongoing",
                  icon: Icons.school,
                ),
                JourneyTile(
                  title: "Học đại học",
                  subtitle: "Ongoing",
                  icon: Icons.school,
                ),
                JourneyTile(
                  title: "Học đại học",
                  subtitle: "Ongoing",
                  icon: Icons.school,
                ),
              ],
            ),
          ),
        ],
      );
    }

    Widget Body(){
      return Scaffold(
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/Common/Background.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 60),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Tilte(),

                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Stack(
                          // clipBehavior: Clip.none, // Cho phép widget mở rộng ra khỏi Stack
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 130.0),
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 30),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20),     // Độ cong cho góc trên trái
                                      topRight: Radius.circular(20),
                                    ),
                                    color: Colors.lightBlue[100]
                                ),
                                child: Column(
                                  children: [
                                    LastJourneys(),
                                    Container(
                                      color: Colors.red, 
                                      height: 500,
                                      width: double.infinity,
                                      child: Align(
                                          alignment: Alignment.center,
                                          child: Text('Content')
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20.0),
                              child: MainFeatures(),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Header(),
            ],
          ),
        ),

        bottomNavigationBar: CustomBottomNav(
          onTabTapped: onTabTapped,
          currentIndex: currentTabIndex,
        ),        // bottomNavigationBar: BottomAppBar(
        //   shape: CircularNotchedRectangle(),
        //   notchMargin: 6.0,
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.spaceAround,
        //     children: [
        //       IconButton(icon: Icon(Icons.map), onPressed: () {}),
        //       IconButton(icon: Icon(Icons.bookmark), onPressed: () {}),
        //       SizedBox(width: 40), // khoảng trống cho nút FloatingActionButton
        //       IconButton(icon: Icon(Icons.favorite), onPressed: () {}),
        //       IconButton(icon: Icon(Icons.person), onPressed: () {}),
        //     ],
        //   ),
        // ),
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () {},
        //   child: Icon(Icons.add),
        // ),
        // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      );
    }
    return Body();
  }
}


class JourneyTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const JourneyTile({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 5),
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: Icon(Icons.arrow_forward),
      ),
    );
  }
}
