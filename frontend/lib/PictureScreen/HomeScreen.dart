import 'package:flutter/material.dart';
import 'package:mapsnap_fe/LocationScreen/locationScreen.dart';
import 'package:mapsnap_fe/PictureScreen/daySavePicture.dart';
import '../Widget/bottomNavigationBar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentTabIndex = 0;

  void onTabTapped(int index) {
    setState(() {
      currentTabIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home Screen')),
      body: Center(
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => daySaveScreen()),
                );
              },
              child: Container(
                width: 200,
                height: 100,
                color: Colors.blue,
                child: Center(child: Text("Picture", style: TextStyle(fontSize: 40),)),
              ),
            ),
            SizedBox(height: 10,),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => locationScreen()),
                );
              },
              child: Container(
                width: 200,
                height: 100,
                color: Colors.blue,
                child: Center(child: Text("Location", style: TextStyle(fontSize: 40),)),
              ),
            ),
          ],
        )
      ),
      bottomNavigationBar: CustomBottomNav(
        onTabTapped: onTabTapped,
        currentIndex: currentTabIndex,
      ),
    );
  }
}
