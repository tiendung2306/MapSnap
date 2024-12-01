import 'package:flutter/material.dart';
import 'package:mapsnap_fe/Manager/CURD_location.dart';
import 'package:mapsnap_fe/Model/City.dart';
import 'package:mapsnap_fe/Model/Location.dart';
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
    List<Location> locations = await getInfoLocation(accountModel.idUser, widget.city.id, 'city');
    if (locations.isNotEmpty) {
      for (var location in locations) {
        accountModel.addLocation(widget.city, location);
      }
    } else {
      print('Không có thành phố nào được tìm thấy.');
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
                                fontSize: 30, fontWeight: FontWeight.bold),
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
                            child: Container(
                              width: screenWidth - 20,
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black.withOpacity(0.3),
                                      spreadRadius: 3,
                                      blurRadius: 6,
                                      offset: Offset(5, 5)
                                  )
                                ]
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    location.title,
                                    style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        'Số lần đến: ',
                                        style: TextStyle(
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        location.visitedTime.toString(),
                                        style: TextStyle(
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded( // Để tự động xuống dòng nếu chữ dài
                                        child: Text(
                                          'Địa chỉ: ${location.address}' ,
                                          style: TextStyle(
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          maxLines: 2, // Giới hạn 2 dòng
                                          overflow: TextOverflow.ellipsis, // Cắt bớt nếu quá dài
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
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

