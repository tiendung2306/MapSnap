import 'package:flutter/material.dart';
import 'package:mapsnap_fe/PictureScreen/JourneyScreen.dart';
import 'package:provider/provider.dart';

import '../Widget/accountModel.dart';

class locationScreen extends StatefulWidget {
  const locationScreen({Key? key}) : super(key: key);

  @override
  State<locationScreen> createState() => _locationScreenState();
}

class _locationScreenState extends State<locationScreen> {
  int k = 1;
  @override
  Widget build(BuildContext context) {
    var accountModel = Provider.of<AccountModel>(context, listen: true);
    final imageManager = accountModel.imageManager;
    final List<String> journeysList = imageManager.keys.toList();
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
            padding: const EdgeInsets.all(15),
            child: Column(
                children: [
                  for(int i = 0 ;i < imageManager.length; i++) ...[
                    GestureDetector(
                      onTap: () {
                        print("Siuuuuuuuuuuuuuu");
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => journeyScreen(journey: journeysList[i]),
                            )
                        );
                      },
                      child: Container(
                        height: 130,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                spreadRadius: 3,
                                blurRadius: 6,
                                offset: Offset(5, 5)
                            )
                          ],
                          image: DecorationImage(
                            image: AssetImage('assets/Image/${(i % 6)+10}.jpg'),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Center(child: Text(journeysList[i], style: TextStyle(fontSize: 30, color: Colors.white),)),
      
                      ),
                    ),
                    SizedBox(height: 15,),
                  ],
                  SizedBox(height: 10,),
      
                  ElevatedButton(
                    onPressed: () {
                      k++;
                      accountModel.addImageLocation(
                        "assets/Image/${k%7 + 1}.jpg",
                        "TP HCM ${k}",
                        "Siuuuuu",
                      );
                    },
                    child: const Text("Thêm ảnh vào địa điểm hiện tại"),
                  ),
                ]
            )
        ),
      ),
    );
  }
}