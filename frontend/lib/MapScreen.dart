import 'package:flutter/material.dart';
import 'Widget/bottomNavigationBar.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  int currentTabIndex = 1;

  void onTabTapped(int index) {
    setState(() {
      currentTabIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Map Screen')),
      body: Center(
        child: Text('Map Screen Content'),
      ),
      bottomNavigationBar: CustomBottomNav(
        onTabTapped: onTabTapped,
        currentIndex: currentTabIndex,
      ),
    );
  }
}
