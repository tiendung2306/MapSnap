import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:mapsnap_fe/LocationScreen/ImageLocationScreen.dart';
import 'package:mapsnap_fe/Manager/CURD_location.dart';
import 'package:mapsnap_fe/Manager/CURD_picture.dart';
import 'package:mapsnap_fe/Model/City.dart';
import 'package:mapsnap_fe/Model/Location.dart';
import 'package:mapsnap_fe/Model/Picture.dart';
import 'package:mapsnap_fe/NewFeed/fullImage.dart';
import 'package:mapsnap_fe/Widget/accountModel.dart';
import 'package:provider/provider.dart';

class visitLocationScreen extends StatefulWidget {
  final City city;

  visitLocationScreen({required this.city, Key? key}) : super(key: key);

  @override
  State<visitLocationScreen> createState() {
    return _visitLocationScreenState();
  }
}

class _visitLocationScreenState extends State<visitLocationScreen> {
  bool _isFilterVisible = false; // Hiển thị thanh lọc
  int? minVisitedTime; // Lọc theo số lần đến
  String filterType = "all"; // Giá trị lọc: all, user, auto

  @override
  void initState() {
    super.initState();
    fetchLocationByUserId();
  }

  Future<void> fetchLocationByUserId() async {
    var accountModel = Provider.of<AccountModel>(context, listen: false);
    accountModel.resetLocation(widget.city);
    accountModel.resetImageLocation();
    List<Location> locations = await getInfoLocation(accountModel.idUser, widget.city.id, 'city');
    if (locations.isNotEmpty) {
      for (var location in locations) {
        accountModel.addLocation(widget.city, location);
        List<Picture> listPicture = await getInfoImages(location.id,'locationId');
        print(listPicture);
        if(listPicture.isNotEmpty) {
          for(var image in listPicture) {
            print("hehe");
            accountModel.addImageLocation(location, image);
          }
        }
      }
    } else {
      print('Không có địa điểm nào được tìm thấy.');
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Consumer<AccountModel>(
          builder: (context, accountModel, child) {
            // Lọc dữ liệu dựa trên tiêu chí
            var filteredLocations = accountModel.locationManager[widget.city]?.where((location) {
              bool matchesVisitedTime =
                  minVisitedTime == null || location.visitedTime >= minVisitedTime!;
              bool matchesFilter = (filterType == "all") ||
                  (filterType == "user" && location.updatedByUser) ||
                  (filterType == "auto" && location.isAutomaticAdded);
              return matchesVisitedTime && matchesFilter;
            }).toList() ?? [];

            return Stack(
              children: [
                Image.asset(
                  'assets/Image/Background.png',
                  width: screenWidth,
                  height: screenHeight,
                  fit: BoxFit.none,
                ),
                SingleChildScrollView(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              width: 50,
                              height: 50,
                              child: Icon(Icons.chevron_left, size: 50),
                            ),
                          ),
                          Text(
                            widget.city.name,
                            style: TextStyle(
                                fontSize: 40, fontWeight: FontWeight.bold),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _isFilterVisible = !_isFilterVisible;
                              });
                            },
                            child: Container(
                              width: 50,
                              height: 50,
                              child: Icon(Icons.filter_list, size: 50),
                            ),
                          ),
                        ],
                      ),
                      // Thanh lọc
                      Visibility(
                        visible: _isFilterVisible,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Column(
                            children: [
                              // TextField nhập số lần đến tối thiểu
                              Row(
                                children: [
                                  SizedBox(width: 11,),
                                  Center(
                                    child: Container(
                                      color: Colors.white,
                                      width: screenWidth * 8 / 9,
                                      child: TextField(
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          labelText: "Số lần đến tối thiểu",
                                          border: OutlineInputBorder(),
                                        ),
                                        onChanged: (value) {
                                          setState(() {
                                            minVisitedTime = int.tryParse(value);
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 5), // Giảm khoảng cách giữa TextField và Radio
                              // RadioListTile để chọn loại lọc
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  RadioListTile<String>(
                                    contentPadding: EdgeInsets.zero,
                                    value: "user",
                                    groupValue: filterType,
                                    title: Text(
                                      "Hiển thị địa điểm do người dùng tạo",
                                      style: TextStyle(fontSize: 18),
                                    ),
                                    onChanged: (value) {
                                      setState(() {
                                        filterType = value!;
                                      });
                                    },
                                  ),
                                  RadioListTile<String>(
                                    contentPadding: EdgeInsets.zero,
                                    value: "auto",
                                    groupValue: filterType,
                                    title: Text(
                                      "Hiển thị địa điểm tự động thêm",
                                      style: TextStyle(fontSize: 18),
                                    ),
                                    onChanged: (value) {
                                      setState(() {
                                        filterType = value!;
                                      });
                                    },
                                  ),
                                  RadioListTile<String>(
                                    contentPadding: EdgeInsets.zero,
                                    value: "all",
                                    groupValue: filterType,
                                    title: Text(
                                      "Hiển thị tất cả địa điểm",
                                      style: TextStyle(fontSize: 18),
                                    ),
                                    onChanged: (value) {
                                      setState(() {
                                        filterType = value!;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      // Danh sách địa điểm đã lọc
                      if (filteredLocations.isNotEmpty)
                        ...filteredLocations.map((location) {
                          return GestureDetector(
                            onTap: () {
                              print("Location: ${location.title}");
                            },
                            onLongPress: () {
                              // Hiển thị hộp thoại xác nhận xóa
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    backgroundColor: Colors.white,
                                    title: const Text("Xác nhận xóa"),
                                    content: Text("Bạn có chắc chắn muốn xóa '${location.title}' không?"),
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
                                          accountModel.removeLocation(widget.city,location);
                                          await RemoveLocation(location.id);
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
                            child: Stack(
                                children: [
                                  Container(
                                    width: screenWidth - 20,
                                    margin: const EdgeInsets.fromLTRB(10, 10, 10, 60),
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFB0E0E6),
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.3),
                                          spreadRadius: 3,
                                          blurRadius: 6,
                                          offset: const Offset(5, 5),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          location.title,
                                          style: const TextStyle(
                                            fontSize: 35,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            const Text(
                                              'Số lần đến: ',
                                              style: TextStyle(
                                                fontSize: 25,
                                              ),
                                            ),
                                            Text(
                                              location.visitedTime.toString(),
                                              style: const TextStyle(
                                                fontSize: 25,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                'Địa chỉ: ${location.address}',
                                                style: const TextStyle(
                                                  fontSize: 25,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 12,
                                    right: 20,
                                    child: GestureDetector(
                                      onTap: () {
                                        if (accountModel.imageLocation[location] != null) {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => Imagelocationscreen(
                                                listPicture: accountModel.imageLocation[location]!,
                                                nameLocation: location.title,
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                      child: Container(
                                        width: (accountModel.imageLocation[location] == null ? 60 : (accountModel.imageLocation[location]?.length ?? 0) > 3 ? (3 * 40 + 20) : (accountModel.imageLocation[location]?.length ?? 0) * 40 + 20),
                                        height: 60,
                                        child: Stack(
                                          children: [
                                            // Hiển thị ảnh chồng
                                            if(accountModel.imageLocation[location] != null) ...[
                                              for (int i = 0; i < accountModel.imageLocation[location]!.length && i < 3; i++) ...[
                                                Positioned(
                                                  left: i * 40.0, // Khoảng cách giữa các ảnh
                                                  child: Container(
                                                    width: 60,
                                                    height: 60,
                                                    decoration: BoxDecoration(
                                                      color: Colors.red,
                                                      image: DecorationImage(
                                                        image: NetworkImage(accountModel.imageLocation[location]![i].link),
                                                        fit: BoxFit.cover,
                                                      ),
                                                      border: Border.all(
                                                        color: Colors.blue, // Màu viền
                                                        width: 2, // Độ dày viền
                                                      ),
                                                      borderRadius: BorderRadius.circular(10), // Làm viền bo tròn (nếu cần)
                                                    ),
                                                  ),

                                                ),
                                              ],
                                              // Hiển thị số ảnh dư
                                              if ((accountModel.imageLocation[location]?.length ?? 0) > 3) ...[
                                                Positioned(
                                                  left: 80,
                                                  child: Stack(
                                                    alignment: Alignment.center, // Đặt Text vào giữa ảnh
                                                    children: [
                                                      Container(
                                                        width: 60,
                                                        height: 60,
                                                        decoration: BoxDecoration(
                                                          image: DecorationImage(
                                                            image: NetworkImage(accountModel.imageLocation[location]![2].link),
                                                            fit: BoxFit.cover,
                                                          ),
                                                          border: Border.all(
                                                            color: Colors.blue, // Màu viền
                                                            width: 2, // Độ dày viền
                                                          ),
                                                          borderRadius: BorderRadius.circular(8),
                                                        ),
                                                        child: Opacity(
                                                          opacity: 0.2, // Làm ảnh thứ 3 trong suốt
                                                          child: Container(
                                                            color: Colors.black, // Nền mờ màu đen
                                                          ),
                                                        ),
                                                      ),
                                                      Text(
                                                        "+${(accountModel.imageLocation[location]!.length - 3).toString()}",
                                                        style: const TextStyle(
                                                          fontSize: 16,
                                                          fontWeight: FontWeight.bold,
                                                          color: Colors.white, // Màu chữ hiển thị trên nền mờ
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],

                                            ]
                                            else ...[
                                              Container(
                                                width: 60,
                                                height: 60,
                                                decoration: BoxDecoration(
                                                  color: Color(0xFFB6B6B6),
                                                  border: Border.all(
                                                    color: Colors.blue, // Màu viền
                                                    width: 2, // Độ dày viền
                                                  ),
                                                  borderRadius: BorderRadius.circular(8),
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    "0",
                                                    style: const TextStyle(
                                                      fontSize: 20,
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.white, // Màu chữ hiển thị trên nền mờ
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ]
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                          );
                        }).toList(),
                      if (filteredLocations.isEmpty)
                        Text(
                          "Không có địa điểm nào khớp với bộ lọc",
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

