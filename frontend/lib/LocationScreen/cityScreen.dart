import 'package:flutter/material.dart';
import 'package:mapsnap_fe/LocationScreen/addCityScreen.dart';
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
        // accountModel.addCity(city);
        accountModel.addLocation(city,null);
      }
    } else {
      print('Không có thành phố nào được tìm thấy.');
    }
  }

  _navigateToAddCityScreen() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const addCityScreen()),
    );

    if (result == true) {
      // Gọi lại fetchCategory để làm mới danh sách
      fetchCityByUserId();
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    var accountModel = Provider.of<AccountModel>(context, listen: true);
    final city = accountModel.locationManager;
    final List<City> cities = city.keys.toList();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
          padding: const EdgeInsets.all(15),
          child: Column(
              children: [
                for(int i = 0 ;i < cities.length; i++) ...[
                  GestureDetector(
                    onTap: () {
                      print("Siuuuuuuuuuuuuuu");
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => visitLocationScreen(city: cities[i]),
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

                      child: Center(child: Text(cities[i].name, style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold, color: Color(
                          0xFFFFFFFF)),)),

                    ),
                  ),
                  SizedBox(height: 15,),
                ],
                SizedBox(height: 20,),
                GestureDetector(
                    onTap: _navigateToAddCityScreen,
                    child:Container(
                      height: 70,
                      width: screenWidth * 2 / 3 - 50 ,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(30),
                      ),

                      child: Center(child: Text("Thêm địa danh", style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold, color: Color(
                          0xFFFFFFFF)),)),
                    )
                ),
              ]
          )

      ),
    );
  }
}