import 'package:flutter/material.dart';
import 'package:mapsnap_fe/InApp/Journeys.dart';
import 'package:mapsnap_fe/InApp/Map.dart';
import 'package:provider/provider.dart';
import '../LocationScreen/locationScreen.dart';
import '../NewFeed/newFeedScreen.dart';
import '../PictureScreen/pictureManager.dart';
import 'package:mapsnap_fe/Widget/bottomNavigationBar.dart';
import 'package:mapsnap_fe/Services/APIService.dart';

import '../Widget/accountModel.dart';


class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final  _apiService = ApiService();
  List<dynamic> data = [];

  bool isDataLoad = false;


  void loadData() async {
    var accountModel = Provider.of<AccountModel>(context, listen: false);
    final response = await _apiService.GetAllJourney(accountModel.idUser, 'asc', 'startedAt', '');

    setState(() {
      data = response['data']['result'];
      isDataLoad = true;
    });
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  String calculateDuration(int startedAt, int endedAt) {
    DateTime start = DateTime.fromMillisecondsSinceEpoch(startedAt);
    DateTime end = DateTime.fromMillisecondsSinceEpoch(endedAt);

    Duration difference = end.difference(start);

    int hours = difference.inHours;
    int minutes = difference.inMinutes % 60;
    int seconds = difference.inSeconds % 60;

    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    int currentTabIndex = 0;

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
                height: 45,
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
              data.length.toString(),
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
                        icon: Icon(Icons.show_chart, size: 30,),
                        onPressed: () {
                        },
                      ),
                      Text('Data')
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
            height: 450,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: data.length,
              itemBuilder: (context, index){
                return JourneyTile(
                      title: data[index]['title'],
                      subtitle: calculateDuration(data[index]['startedAt'], data[index]['endedAt']),
                      icon: Icons.directions_walk,
                );
              },
            ),
          ),
        ],
      );
    }

    Container LoadingScreen(){
      return Container(
        color: Colors.white,
        child: Center(
          child: Text(
              'Loading'
          ),
        ),
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
    return Scaffold(
      body: !isDataLoad ?
      LoadingScreen():
      Body(),
    );
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
