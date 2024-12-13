import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mapsnap_fe/InApp/Positions.dart';
import 'package:mapsnap_fe/Manager/CRUD_LocationCategory.dart';
import 'package:mapsnap_fe/Manager/CURD_city.dart';
import 'package:mapsnap_fe/Manager/CURD_location.dart';
import 'package:mapsnap_fe/Model/City.dart';
import 'package:mapsnap_fe/Model/City.dart';
import 'package:mapsnap_fe/Model/Location.dart';
import 'package:mapsnap_fe/Model/LocationCategory.dart';
import 'package:mapsnap_fe/Widget//text_field_input.dart';
import 'package:provider/provider.dart';
import '../Widget/accountModel.dart';
import 'package:dropdown_button2/dropdown_button2.dart';




class addLocationScreen extends StatefulWidget {
  addLocationScreen({Key? key}) : super(key: key);

  @override
  State<addLocationScreen> createState() => _addLocationScreenState();
}

class _addLocationScreenState extends State<addLocationScreen> {

  late TextEditingController titleController = TextEditingController();
  late TextEditingController addressController = TextEditingController();

  LocationCategory? Category;
  List<LocationCategory> locationCategory = [];

  City? city;
  List<City> listCity = [];

  String Notification = "";
  late Color colorNotification;

  @override
  void initState() {
    fetchCategory();
    super.initState();
  }


  Future<void> fetchCategory() async {
    var accountModel = Provider.of<AccountModel>(context, listen: false);
    // Kiểm tra xem đã tải ảnh chưa
    locationCategory = await getInfoLocationCategory(accountModel.idUser);
    listCity = await getInfoCity(accountModel.idUser);
    setState(() {});
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                buildTextField("Tên", titleController, "Tên địa điểm", TextInputType.text),
                                const SizedBox(height: 15),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text("Loại địa điểm", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 5),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,  // Màu nền bên trong Container
                                        border: Border.all(
                                          color: Colors.black,  // Màu viền đen
                                          width: 1,  // Độ rộng viền
                                        ),
                                        borderRadius: BorderRadius.circular(5),  // Bo góc nếu bạn muốn viền bo tròn
                                      ),
                                      child: DropdownButton2<LocationCategory>(
                                        dropdownStyleData: const DropdownStyleData(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                          ),
                                          maxHeight: 200,
                                        ),
                                        value: Category, // Lưu đối tượng LocationCategory
                                        hint: Text("Chọn địa điểm"),
                                        items: locationCategory.map((category) {
                                          return DropdownMenuItem<LocationCategory>(
                                            value: category, // Đặt đối tượng LocationCategory vào value
                                            child: Text(category.name), // Hiển thị tên của loại địa điểm
                                          );
                                        }).toList(),
                                        onChanged: (LocationCategory? value) {
                                          setState(() {
                                            Category = value; // Lưu đối tượng được chọn vào Category
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 15),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text("Thành Phố", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 5),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,  // Màu nền bên trong Container
                                        border: Border.all(
                                          color: Colors.black,  // Màu viền đen
                                          width: 1,  // Độ rộng viền
                                        ),
                                        borderRadius: BorderRadius.circular(5),  // Bo góc nếu bạn muốn viền bo tròn
                                      ),
                                      child: DropdownButton2<City>(
                                        dropdownStyleData: const DropdownStyleData(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                          ),
                                          maxHeight: 200,
                                        ),
                                        value: city,
                                        hint: Text("Chọn tỉnh"),
                                        items: listCity.map((cities) {
                                          return DropdownMenuItem<City>(
                                            value: cities,
                                            child: Text(cities.name),
                                          );
                                        }).toList(),
                                        onChanged: (City? value) {
                                          setState(() {
                                            city = value;
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                ),
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
                                if (titleController.text.isEmpty  ||
                                    city == null || Category == null) {
                                  Notification = "Vui lòng nhập thông tin";
                                  colorNotification = Colors.red;
                                } else {
                                  // Nếu tất cả đều hợp lệ, lưu dữ liệu
                                  var accountModel = Provider.of<AccountModel>(context, listen: false);
                                  Notification = "Lưu thông tin thành công";
                                  colorNotification = Colors.blue;
                                  DateTime now = DateTime.now();
                                  DateTime vietnamTime = now.toUtc().add(Duration(hours: 7));
                                  // Position position = await Geolocator.getCurrentPosition(
                                  //     locationSettings: LocationSettings(
                                  //         accuracy: LocationAccuracy.high, // Độ chính xác cao
                                  //     ),
                                  // );
                                  InfoVisit? infoLocation = await AutoLocation(150, 100);
                                  CreateLocation createLocation = CreateLocation(
                                      cityId: city!.id,
                                      categoryId: Category!.id,
                                      title: titleController.text,
                                      visitedTime: 1,
                                      longitude: 150,
                                      latitude: 100,
                                      createdAt: vietnamTime.millisecondsSinceEpoch,
                                      status: "enabled",
                                      updatedByUser: true,
                                      isAutomaticAdded: false,
                                      address: infoLocation!.address,
                                      country: "Việt Nam",
                                      district: "Siuuuuuuuuuu",
                                      homeNumber: infoLocation.homeNumber,
                                  );
                                  await upLoadLocation(createLocation, accountModel.idUser);
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
