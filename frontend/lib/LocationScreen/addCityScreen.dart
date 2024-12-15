import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mapsnap_fe/Authentication/Onboarding_content_model.dart';
import 'package:mapsnap_fe/LocationScreen/myLocationScreen.dart';
import 'package:mapsnap_fe/Manager/CRUD_LocationCategory.dart';
import 'package:mapsnap_fe/Manager/CURD_city.dart';
import 'package:mapsnap_fe/Model/City.dart';
import 'package:mapsnap_fe/Model/LocationCategory.dart';
import 'package:mapsnap_fe/PictureScreen/HomeScreen.dart';
import 'package:mapsnap_fe/Widget//text_field_input.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Model/User_2.dart';
import '../Widget/AutoRefreshToken.dart';
import '../Widget/accountModel.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:mapsnap_fe/Widget/UpdateUser.dart';
import '../main.dart';



class addCityScreen extends StatefulWidget {
  const addCityScreen({Key? key}) : super(key: key);

  @override
  State<addCityScreen> createState() => _addCityScreenState();
}

class _addCityScreenState extends State<addCityScreen> {
  XFile? _image; // Biến lưu trữ ảnh đã chọn

  late TextEditingController nameController = TextEditingController();
  late TextEditingController titleController = TextEditingController();

  String Notification = "";
  late Color colorNotification;



  String selectedCity = 'Chọn thành phố';


  final List<String> cities = [
    'An Giang',
    'Bà Rịa - Vũng Tàu',
    'Bắc Giang',
    'Bắc Kạn',
    'Bạc Liêu',
    'Bắc Ninh',
    'Bến Tre',
    'Bình Định',
    'Bình Dương',
    'Bình Phước',
    'Bình Thuận',
    'Cà Mau',
    'Cần Thơ',
    'Cao Bằng',
    'Đà Nẵng',
    'Đắk Lắk',
    'Đắk Nông',
    'Điện Biên',
    'Đồng Nai',
    'Đồng Tháp',
    'Gia Lai',
    'Hà Giang',
    'Hà Nam',
    'Hà Nội',
    'Hà Tĩnh',
    'Hải Dương',
    'Hải Phòng',
    'Hậu Giang',
    'Hòa Bình',
    'Hưng Yên',
    'Khánh Hòa',
    'Kiên Giang',
    'Kon Tum',
    'Lai Châu',
    'Lâm Đồng',
    'Lạng Sơn',
    'Lào Cai',
    'Long An',
    'Nam Định',
    'Nghệ An',
    'Ninh Bình',
    'Ninh Thuận',
    'Phú Thọ',
    'Phú Yên',
    'Quảng Bình',
    'Quảng Nam',
    'Quảng Ngãi',
    'Quảng Ninh',
    'Quảng Trị',
    'Sóc Trăng',
    'Sơn La',
    'Tây Ninh',
    'Thái Bình',
    'Thái Nguyên',
    'Thanh Hóa',
    'Thừa Thiên Huế',
    'Tiền Giang',
    'Thành phố Hồ Chí Minh',
    'Trà Vinh',
    'Tuyên Quang',
    'Vĩnh Long',
    'Vĩnh Phúc',
    'Yên Bái',
  ];




  String statusController = 'enabled';

  void initState() {
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    var accountModel = Provider.of<AccountModel>(context, listen: false);
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: GestureDetector(
        onTap: () {
          // Bỏ chọn tất cả các TextField khi bấm ra ngoài
          FocusScope.of(context).unfocus();
        },
        child: SafeArea(
          // Màn hình di chuyển khi hiện bàn phím ảo che phần nhập
          child: SingleChildScrollView(
            child: Stack(
                children: [
                  Image.asset(
                    'assets/Image/Background.png',
                    width: screenHeight,
                    height: screenHeight,
                    fit: BoxFit.none,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: screenWidth / 15),
                    width: double.infinity,
                    child: Column(
                      children: [
                        SizedBox(height: screenHeight / 70),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () async {
                                FocusScope.of(context).unfocus();
                                // Khoảng trễ cho dòng code tiếp theo
                                await Future.delayed(Duration(milliseconds: 500));
                                Navigator.pop(context,true);
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
                                'Thêm thành phố',
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
                        SizedBox(height: screenHeight / 70),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Thành phố", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 5),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              width: screenWidth,
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton2 (
                                  isExpanded: true,
                                  dropdownStyleData:const DropdownStyleData(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                    ),
                                    maxHeight: 200,
                                  ),
                                  value: selectedCity == 'Chọn thành phố' ? null : selectedCity,
                                  hint: Text(selectedCity),
                                  iconStyleData: const IconStyleData(
                                    icon: Icon(Icons.arrow_drop_down), // Biểu tượng mũi tên
                                    iconSize: 30,
                                  ),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      selectedCity = newValue!;
                                    });

                                  },
                                  items: cities.map<DropdownMenuItem<String>>((String city) {
                                    return DropdownMenuItem<String>(
                                      value: city,
                                      child: Text(city),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),

                        Material(
                          color: Colors.blueAccent,
                          borderRadius: BorderRadius.circular(15),
                          child: InkWell(
                              onTap: () async {
                                if (selectedCity == 'Chọn thành phố') {
                                  Notification = "Vui lòng chọn thông tin";
                                  colorNotification = Colors.red;
                                } else {
                                  // Nếu tất cả đều hợp lệ, lưu dữ liệu
                                  var accountModel = Provider.of<AccountModel>(context, listen: false);
                                  Notification = "Thêm thành phố thành công";
                                  colorNotification = Colors.blue;
                                  DateTime now = DateTime.now();
                                  DateTime vietnamTime = now.toUtc().add(Duration(hours: 7)); // Múi giờ Việt Nam
                                  CreateCity createCity = CreateCity(
                                    name: selectedCity,
                                    visitedTime: 1,
                                    createdAt: vietnamTime.millisecondsSinceEpoch,
                                    status: "enabled",
                                    updatedByUser: true,
                                    isAutomaticAdded: false,
                                  );
                                  await upLoadCity(createCity, accountModel.idUser);
                                }

                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      backgroundColor: Colors.white,
                                      title: const Text("Thông báo", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),),
                                      content: Text(Notification, style: TextStyle(fontSize: 20,)),
                                      actions: <Widget>[
                                        new ElevatedButton(
                                          child: new Text('OK', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),),
                                          style: TextButton.styleFrom(
                                            backgroundColor: colorNotification,
                                          ),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        )
                                      ],
                                    );
                                  },
                                );
                              },
                              splashColor: Colors.white.withOpacity(0.2),
                              child: Container(
                                width: screenWidth * 2 / 3,
                                height: 50,
                                child: const Center(
                                  child: Text("Thêm thành phố", style: TextStyle(color: Colors.white,
                                      fontSize: 20, fontWeight: FontWeight.bold),),
                                ),
                              )
                          ),
                        ),
                      ],
                    ),
                  ),
                ]
            ),
          ),
        ),
      ),
    );
  }
}
