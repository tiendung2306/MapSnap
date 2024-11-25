import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mapsnap_fe/Authentication/Onboarding_content_model.dart';
import 'package:mapsnap_fe/Widget//text_field_input.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Model/User_2.dart';
import '../Widget/AutoRefreshToken.dart';
import '../Widget/accountModel.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:mapsnap_fe/Widget/UpdateUser.dart';
import '../main.dart';



class addLocationScreen extends StatefulWidget {
  const addLocationScreen({Key? key}) : super(key: key);

  @override
  State<addLocationScreen> createState() => _addLocationScreenState();
}

class _addLocationScreenState extends State<addLocationScreen> {
  XFile? _image; // Biến lưu trữ ảnh đã chọn

  late TextEditingController nameController = TextEditingController();
  late TextEditingController titleController = TextEditingController();
  late TextEditingController addressController = TextEditingController();

  String Notification = "";
  late Color colorNotification;




  //List giới tính
  final List<String> locationCategory = [
    'Nhà',
    'Trường học',
    'Công ty',
    'Bệnh viện',
    'Siêu thị',
    'Chợ',
    'SÚC VẬT',
    'ĐCM TK NÀO NGHĨ RA MẤY CÁI NÀY V',
  ];


  String locationCategoryController = 'Chọn loại địa điểm';

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
                                'Thêm địa điểm',
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
                        Align(
                          alignment: Alignment.topLeft,
                          child: Container(
                            padding:
                            EdgeInsets.symmetric(horizontal: screenWidth / 10),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                buildTextField("Tên", nameController, "Nhập tên địa điểm", TextInputType.text),
                                const SizedBox(height: 15),
                                buildTextField("Tiêu đề", titleController, "Thêm tiêu đề", TextInputType.text),
                                const SizedBox(height: 15),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text("Loại địa điểm", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
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
                                          value: locationCategoryController == 'Chọn loại địa điểm' ? null : locationCategoryController,
                                          hint: Text(locationCategoryController),
                                          iconStyleData: const IconStyleData(
                                            icon: Icon(Icons.arrow_drop_down), // Biểu tượng mũi tên
                                            iconSize: 30,
                                          ),
                                          onChanged: (String? newValue) {
                                            setState(() {
                                              locationCategoryController = newValue!;
                                            });
                                          },
                                          items: locationCategory.map<DropdownMenuItem<String>>((String locationCategory) {
                                            return DropdownMenuItem<String>(
                                              value: locationCategory,
                                              child: Text(locationCategory),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 15),
                                buildTextField("Địa chỉ", addressController, "Nhập địa chỉ", TextInputType.text),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 50),

                        Material(
                          color: Colors.blueAccent,
                          borderRadius: BorderRadius.circular(15),
                          child: InkWell(
                              onTap:  () async {
                                if (nameController.text.isEmpty || titleController.text.isEmpty ||
                                    addressController.text.isEmpty || locationCategoryController == 'Chọn loại địa điểm') {
                                  Notification = "Vui lòng nhập thông tin";
                                  colorNotification = Colors.red;
                                } else {
                                  // Nếu tất cả đều hợp lệ, lưu dữ liệu
                                  var accountModel = Provider.of<AccountModel>(context, listen: false);
                                  Notification = "Lưu thông tin thành công";
                                  colorNotification = Colors.blue;

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
                                  child: Text("Thêm địa điểm", style: TextStyle(color: Colors.white,
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

  Widget buildTextField(String label, TextEditingController controller, String hintText, TextInputType inputType, {bool enabled = true}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 3),
        TextFieldInput(
          textEditingController: controller,
          hintText: hintText,
          textInputType: inputType,
          isEnabled: enabled,
        ),
      ],
    );
  }
}
