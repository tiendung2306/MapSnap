import 'package:flutter/material.dart';

import '../Camera/mainScreenCamera.dart';

class CustomBottomNav extends StatelessWidget {
  final Function(int) onTabTapped;
  final int currentIndex;

  const CustomBottomNav({
    Key? key,
    required this.onTabTapped,
    this.currentIndex = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          buildNavItem(context, Icons.home, 0, '/home'),
          buildNavItem(context, Icons.map_outlined, 1, '/map'),
          buildNavItem(context, Icons.photo_camera, 2, '/camera', size: 65),
          buildNavItem(context, Icons.favorite_border, 3, '/favorites'),
          buildNavItem(context, Icons.account_circle, 4, '/account'),
        ],
      ),
    );
  }

  Widget buildNavItem(BuildContext context, IconData icon, int index, String routeName, {double size = 35,}) {
    // Color iconColor = (index == currentIndex) ? Colors.deepOrange : Colors.black54; // Set color for current index
    Color iconColor;
    if(index == 2) {
      iconColor = Colors.blue;
    } else if (index == currentIndex && index != 2) {
      iconColor = Colors.deepOrange;
    } else {
      iconColor = Colors.black54;
    }

    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: () {
          if (index == 4) {
            // Điều hướng đến Home mà giữ lại trong stack
            Navigator.pushNamedAndRemoveUntil(context, '/account', (route) => false);
          } else if(index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MainScreenCamera()),
            );
          } else {
            // Các màn hình khác thay thế màn hình hiện tại
            Navigator.pushReplacementNamed(context, routeName);
          }
          onTabTapped(index);
        },
        splashColor: Colors.grey.withOpacity(0.3),
        child: Container(
          width: size + 20,
          height: size + 20,
          child: Icon(icon, size: size, color: iconColor),  // Use dynamic color here
        ),
      ),
    );
  }
}
