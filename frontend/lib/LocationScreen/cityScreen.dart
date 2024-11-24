//
// import 'package:flutter/material.dart';
// import 'package:mapsnap_fe/LocationScreen/visitLocationScreen.dart';
// import 'package:provider/provider.dart';
//
// import '../Widget/accountModel.dart';
//
//
//
//
// class cityScreen extends StatefulWidget {
//   const cityScreen({Key? key}) : super(key: key);
//
//   @override
//   State<cityScreen> createState() => _cityScreenState();
// }
//
// class _cityScreenState extends State<cityScreen> {
//   int k = 1;
//   int son = 1;
//   @override
//   Widget build(BuildContext context) {
//     var accountModel = Provider.of<AccountModel>(context, listen: true);
//     final locationManager = accountModel.locationManager;
//     final List<String> cityList = locationManager.keys.toList();
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SingleChildScrollView(
//           padding: const EdgeInsets.all(15),
//           child: Column(
//               children: [
//                 for(int i = 0 ;i < locationManager.length; i++) ...[
//                   GestureDetector(
//                     onTap: () {
//                       print("Siuuuuuuuuuuuuuu");
//                       Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => visitLocationScreen(city: cityList[i]),
//                           )
//                       );
//                     },
//                     child: Container(
//                       height: 140,
//                       decoration: BoxDecoration(
//                         color: Colors.grey,
//                         borderRadius: BorderRadius.circular(20),
//                         boxShadow: [
//                           BoxShadow(
//                               color: Colors.black.withOpacity(0.3),
//                               spreadRadius: 3,
//                               blurRadius: 6,
//                               offset: Offset(5, 5)
//                           )
//                         ],
//                         image: DecorationImage(
//                           image: AssetImage('assets/Image/${(i % 5)+10}.jpg'),
//                           fit: BoxFit.cover, // Hoặc BoxFit.none nếu bạn muốn giữ nguyên kích thước ảnh
//                         ),
//                       ),
//
//                       child: Center(child: Text(cityList[i], style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold, color: Color(
//                           0xFFFFFFFF)),)),
//
//                     ),
//                   ),
//                   SizedBox(height: 15,),
//
//                 ],
//                 SizedBox(height: 10,),
//
//                 ElevatedButton(
//                   onPressed: () {
//                     k++;
//                     accountModel.addLocation(
//                       "TP HCM${k}",
//                       {
//                         'Tên': 'THPT xx${k}',
//                         'Số lần đến': '${k}',
//                         'Lần đến gần nhất': '23-11-2024'
//                       },
//                     );
//                   },
//                   child: const Text("Thêm ảnh vào địa điểm hiện tại"),
//                 ),
//
//               ]
//           )
//
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:mapsnap_fe/LocationScreen/visitLocationScreen.dart';
import 'package:mapsnap_fe/Manager/CURD_city.dart';
import 'package:mapsnap_fe/Model/City.dart';
import 'package:provider/provider.dart';

import '../Widget/accountModel.dart';




class cityScreen extends StatefulWidget {
  const cityScreen({Key? key}) : super(key: key);

  @override
  State<cityScreen> createState() => _cityScreenState();
}

class _cityScreenState extends State<cityScreen> {
  int k = 1;
  int son = 1;

  @override
  void initState() {
    fetchCityByUserId();
    super.initState();
  }

  Future<void> fetchCityByUserId() async {
    var accountModel = Provider.of<AccountModel>(context, listen: false);
    // Kiểm tra xem đã tải ảnh chưa
    accountModel.resetCity();
    List<City> cities = await getInfoCity(accountModel.idUser);
    if (cities.isNotEmpty) {
      for (var city in cities) {
        accountModel.addCity(city);
      }
    } else {
      print('Không có thành phố nào được tìm thấy.');
    }
  }

  @override
  Widget build(BuildContext context) {
    var accountModel = Provider.of<AccountModel>(context, listen: true);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
          padding: const EdgeInsets.all(15),
          child: Column(
              children: [
                for(int i = 0 ;i < accountModel.cityManager.length; i++) ...[
                  GestureDetector(
                    onTap: () {
                      print("Siuuuuuuuuuuuuuu");
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => visitLocationScreen(city: accountModel.cityManager[i].name),
                          )
                      );
                    },
                    child: Container(
                      height: 140,
                      decoration: BoxDecoration(
                        color: Colors.grey,
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
                          fit: BoxFit.cover, // Hoặc BoxFit.none nếu bạn muốn giữ nguyên kích thước ảnh
                        ),
                      ),

                      child: Center(child: Text(accountModel.cityManager[i].name, style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold, color: Color(
                          0xFFFFFFFF)),)),

                    ),
                  ),
                  SizedBox(height: 15,),

                ],
                SizedBox(height: 10,),

                ElevatedButton(
                  onPressed: () {
                    k++;
                    accountModel.addLocation(
                      "TP HCM${k}",
                      {
                        'Tên': 'THPT xx${k}',
                        'Số lần đến': '${k}',
                        'Lần đến gần nhất': '23-11-2024'
                      },
                    );
                  },
                  child: const Text("Thêm ảnh vào địa điểm hiện tại"),
                ),

              ]
          )

      ),
    );
  }
}