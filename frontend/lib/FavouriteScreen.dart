import 'package:flutter/material.dart';
import 'Widget/bottomNavigationBar.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  int currentTabIndex = 3;

  void onTabTapped(int index) {
    setState(() {
      currentTabIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Favourite Screen')),
      body: Center(
        child: Text('Favourite Screen Content'),
      ),
      bottomNavigationBar: CustomBottomNav(
        onTabTapped: onTabTapped,
        currentIndex: currentTabIndex,
      ),
    );
  }
}
