import 'package:flutter/material.dart';

import 'Services/APIService.dart';




class DevScreen extends StatelessWidget {
  final  _apiService = ApiService();
  List<Map<String, dynamic>> coordinates = [
    {"latitude": 20.998619, "longitude": 105.853809, "special": true},
    {"latitude": 20.998832, "longitude": 105.853614, "special": false},
    {"latitude": 20.998900, "longitude": 105.853272, "special": false},
    {"latitude": 20.999135, "longitude": 105.852784, "special": false},
    {"latitude": 20.998824, "longitude": 105.852524, "special": true},
    {"latitude": 20.998429, "longitude": 105.852223, "special": false},
    {"latitude": 20.998520, "longitude": 105.851654, "special": false},
    {"latitude": 20.998786, "longitude": 105.850337, "special": false},
    {"latitude": 20.997943, "longitude": 105.850190, "special": false},
    {"latitude": 20.996827, "longitude": 105.850078, "special": true},
    {"latitude": 20.995933, "longitude": 105.849929, "special": false},
    {"latitude": 20.996164, "longitude": 105.848196, "special": false},
    {"latitude": 20.996759, "longitude": 105.845729, "special": false},
    {"latitude": 20.997934, "longitude": 105.841297, "special": false},
    {"latitude": 20.999628, "longitude": 105.841212, "special": true},
    {"latitude": 21.001874, "longitude": 105.841453, "special": false},
    {"latitude": 21.003143, "longitude": 105.841425, "special": false},
    {"latitude": 21.005182, "longitude": 105.841427, "special": false},
    {"latitude": 21.007611, "longitude": 105.841459, "special": true},
  ];

  List<Map<String, dynamic>> data = [];

  void load(){
    DateTime startTime = DateTime(2024, 12, 17, 7, 0);
    for (var coord in coordinates) {
      data.add({
        "latitude": coord["latitude"],
        "longitude": coord["longitude"],
        "createdAt": startTime.millisecondsSinceEpoch,
        "type": coord["special"] ? "visit" : "position",
      });
      // Tăng thời gian
      if (coord["special"] == true) {
        startTime = startTime.add(Duration(hours: 1)); // Tăng 1 tiếng
      } else {
        startTime = startTime.add(Duration(minutes: 30)); // Tăng 30 phút
      }
    }
  }

  void onTap() async {
    load();
    for(var cor in data){
      if(cor["type"] == "visit"){
        final respoonse = await _apiService.GetNearestPosition("6749909daf248d3b800e31ef", cor["latitude"], cor["longitude"], 1734393500000, 1734431400099);
        final pos = respoonse["data"]["result"];
        print(cor["latitude"]);
        print(cor["longitude"]);
        print(pos);

        await _apiService.CreateVisit("6749909daf248d3b800e31ef", pos["locationId"], cor["createdAt"], cor["createdAt"], pos["address"]);

      }
      //
      // else
      // await _apiService.CreatePositon("6749909daf248d3b800e31ef", cor["latitude"] + 0.000001, cor["longitude"] + 0.000001, cor["createdAt"].toInt());
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nút Bấm Ở Giữa'),
        centerTitle: true,
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            onTap();
          },
          child: Text(
            'Bấm vào đây',
            style: TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }
}
