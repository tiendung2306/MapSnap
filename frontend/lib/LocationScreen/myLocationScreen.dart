import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mapsnap_fe/LocationScreen/visitLocationScreen2.dart';
import 'package:mapsnap_fe/Manager/CRUD_LocationCategory.dart';
import 'package:mapsnap_fe/Model/LocationCategory.dart';
import 'package:mapsnap_fe/Widget/accountModel.dart';
import 'package:provider/provider.dart';


class myLocationScreen extends StatefulWidget {

  const myLocationScreen({Key? key}) : super(key: key);

  @override
  State<myLocationScreen> createState() => _myLocationScreenState();
}

class _myLocationScreenState extends State<myLocationScreen> {


  int k = 1;
  int son = 1;

  @override
  void initState() {
    fetchCategory();
    super.initState();
  }

  Future<void> fetchCategory() async {
    var accountModel = Provider.of<AccountModel>(context, listen: false);
    // Kiểm tra xem đã tải ảnh chưa
    accountModel.resetLocationCategory();
    List<LocationCategory> locationCategory = await getInfoLocationCategory(accountModel.idUser);
    if (locationCategory.isNotEmpty) {
      for (var category in locationCategory) {
        accountModel.addLocationCategory(category,null);
      }
    } else {
      print('Không có thành phố nào được tìm thấy.');
    }
  }

  IconData getCategoryIcon(String categoryType) {
    switch (categoryType) {
      case 'Home':
        return Icons.home; // Icon cho nhà
      case 'School':
        return Icons.school; // Icon cho trường
      case 'Company':
        return Icons.work; // Icon cho công viên
      case 'restaurant':
        return Icons.restaurant; // Icon cho nhà hàng
      case 'hospital':
        return Icons.local_hospital;
      case 'Supermarket':
        return Icons.shopping_cart;
      case 'Park':
        return Icons.park;
      default:
        return Icons.location_on; // Icon mặc định
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    var accountModel = Provider.of<AccountModel>(context, listen: true);
    final locationCategory = accountModel.locationCategoryManager;
    final List<LocationCategory> category = locationCategory.keys.toList();
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
          padding: const EdgeInsets.all(15),
          child: Column(
              children: [
                for(int i = 0 ;i < category.length; i++) ...[
                  GestureDetector(
                    onTap: () {
                      print("Siuuuuuuuuuuuuuu");
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => visitLocationScreen2(locationCategory: category[i]),
                          )
                      );
                    },
                    child: Row(
                      children: [
                        Container(
                          width: 70,
                          height: 70,
                          child: Icon(
                            getCategoryIcon(category[i].title), // Lấy icon theo loại
                            color: Colors.orange,
                            size: 50,
                          ),
                        ),
                        Container(
                          height: 70,
                          width: screenWidth * 2 / 3,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  spreadRadius: 3,
                                  blurRadius: 6,
                                  offset: Offset(5, 5)
                              )
                            ],
                          ),

                          child: Center(child: Text(category[i].name, style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold, color: Color(
                              0xFFFFFFFF)),)),

                        ),
                      ],
                    )
                  ),
                  SizedBox(height: 15,),
                ],
                SizedBox(height: 10,),
              ]
          )

      ),
    );
  }

}
