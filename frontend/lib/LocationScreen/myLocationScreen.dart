import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class myLocationScreen extends StatefulWidget {

  const myLocationScreen({Key? key}) : super(key: key);

  @override
  State<myLocationScreen> createState() => _myLocationScreenState();
}

class _myLocationScreenState extends State<myLocationScreen> {


  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          color: Colors.white,
        )
      ),
    );
  }

}
