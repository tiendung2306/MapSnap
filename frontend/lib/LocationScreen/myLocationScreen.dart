import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mapsnap_fe/LocationScreen/addMyLocationScreen.dart';
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
  // Hàm điều hướng và cập nhật màn hình
  _navigateToAddLocationScreen() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const addMyLocationScreen()),
    );

    if (result == true) {
      // Gọi lại fetchCategory để làm mới danh sách
      fetchCategory();
    }
  }




  IconData getCategoryIcon(String categoryType) {
    switch (categoryType) {
      case 'Nhà':
        return Icons.home;
      case 'Trường học':
        return Icons.school;
      case 'Công ty':
        return Icons.work;
      case 'Nhà hàng':
        return Icons.restaurant;
      case 'Bệnh viện':
        return Icons.local_hospital;
      case 'Siêu thị':
        return Icons.shopping_cart;
      case 'Công viên':
        return Icons.park;
      case 'Biển':
        return Icons.beach_access;
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
                      setState(() {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => visitLocationScreen2(locationCategory: category[i]),
                            )
                        );
                      });
                    },
                    onLongPress: () {
                        // Hiển thị hộp thoại xác nhận xóa
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              backgroundColor: Colors.white,
                              title: const Text("Xác nhận xóa"),
                              content: Text("Bạn có chắc chắn muốn xóa '${category[i].name}' không?"),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context); // Đóng hộp thoại
                                  },
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all<Color>(Colors.white12), // Màu nền cho nút
                                  ),
                                  child: const Text("Hủy", style: TextStyle(color: Colors.black)),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    accountModel.removeLocationCategory(category[i]);
                                    await RemoveLocationCategory(category[i].id);
                                    Navigator.pop(context); // Đóng hộp thoại
                                    // Làm mới giao diện
                                    setState(() {});
                                  },
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all<Color>(Colors.red), // Màu nền cho nút

                                  ),
                                  child: const Text("Xóa", style: TextStyle(color: Colors.white)),
                                ),
                              ],
                            );
                          },
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
                SizedBox(height: 20,),
                GestureDetector(
                    onTap: _navigateToAddLocationScreen,
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
