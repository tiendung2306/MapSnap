import 'package:flutter/material.dart';

class helpScreen extends StatefulWidget {
  const helpScreen({Key? key}) : super(key: key);

  @override
  State<helpScreen> createState() => _helpScreenState();
}

class _helpScreenState extends State<helpScreen> {


  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Stack(
            children: [
                  Container(
                    width: screenWidth,
                    color: Colors.white,
                    height: screenHeight,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: screenWidth / 15),
                    width: double.infinity,
                    color: Colors.white,
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
                                width: screenWidth / 8,
                                height: screenWidth / 8,
                                child: Icon(
                                  Icons.keyboard_arrow_left,
                                  size: screenWidth / 8,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            Container(
                              child: Text(
                                "Hỗ trợ NPT",
                                style: TextStyle(fontSize: 30),
                              ),
                            ),
                            Container(
                              width: screenWidth / 8,
                              height: screenWidth / 8,
                              child: GestureDetector(
                                onTap: () {
                                  print("Tìm kiếm");
                                },
                                child: Icon(
                                  Icons.search,
                                  size: screenWidth / 8,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: screenHeight / 50),
                        Center(
                          child: Container(
                            child: Image.asset('assets/Image/Donate.png'),
                          ),
                        ),
                        SizedBox(height: screenHeight / 50),
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Cảm ơn ', style: TextStyle(fontSize: 30),),
                              Icon(Icons.favorite , color: Colors.red,size: 30,),
                              Icon(Icons.favorite , color: Colors.red,size: 30,),
                              Icon(Icons.favorite , color: Colors.red,size: 30,),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ]
        ),
      ),
    );
  }
}