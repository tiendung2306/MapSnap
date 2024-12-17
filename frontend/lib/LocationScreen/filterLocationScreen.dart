import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mapsnap_fe/Manager/CURD_city.dart';
import 'package:mapsnap_fe/Manager/CURD_location.dart';
import 'package:mapsnap_fe/Model/City.dart';
import 'package:mapsnap_fe/Model/Location.dart';
import 'package:mapsnap_fe/Widget/accountModel.dart';
import 'package:provider/provider.dart';



class filterLocationScreen extends StatefulWidget {

  filterLocationScreen({
    Key? key
  }) : super(key: key);

  @override
  State<filterLocationScreen> createState() {
    return _visitLocationScreenState();
  }
}

class _visitLocationScreenState  extends State<filterLocationScreen>{

  int k = 1;

  String? selectedCity; // Lọc theo tỉnh
  int? minVisitedTime;  // Lọc theo số lần đến
  String filterType = "all"; // Giá trị lọc: all, user, auto

  bool _isFilterVisible = false;

  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchCityByUserId();
    });
  }




  Future<void> fetchCityByUserId() async {
    var accountModel = Provider.of<AccountModel>(context, listen: false);
    // Kiểm tra xem đã tải ảnh chưa
    accountModel.resetCity();
    List<City> cities = await getInfoCity(accountModel.idUser,"","");
    if (cities.isNotEmpty) {
      for (var city in cities) {
        // Kiểm tra xem đã tải ảnh chưa
        List<Location> locations = await getInfoLocation(accountModel.idUser,city.id,'city');
        if (locations.isNotEmpty) {
          for (var location in locations) {
            accountModel.addLocation(city,location);
          }
        } else {
          print('Không có thành phố nào được tìm thấy.');
        }
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
        // Bỏ chọn tất cả các TextField khi bấm ra ngoài
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Consumer<AccountModel>(
          builder: (context, accountModel, child) {
            // Lấy danh sách các tỉnh để lọc
            List<String> cities = accountModel.locationManager.keys.map((city) => city.name).toList();
            cities.insert(0,'Tất cả');

            // Lọc danh sách dựa trên bộ lọc
            var filteredData = accountModel.locationManager.entries.map((entry) {
              // Lọc danh sách địa điểm theo `minVisitedTime`
              var filteredLocations = entry.value.where((location) {
                bool matchesVisitedTime =
                    minVisitedTime == null || location.visitedTime >= minVisitedTime!;
                bool matchesFilter = (filterType == "all") ||
                    (filterType == "user" && location.updatedByUser) ||
                    (filterType == "auto" && location.isAutomaticAdded);
                return matchesVisitedTime && matchesFilter;
              }).toList() ?? [];

              // Trả về thành phố và danh sách địa điểm đã lọc
              return MapEntry(entry.key, filteredLocations);
            }).where((entry) {
              // Nếu chọn 'Tất cả', không lọc theo thành phố
              bool matchesCity = selectedCity == null || selectedCity == 'Tất cả' || entry.key.name == selectedCity;
              return matchesCity && entry.value.isNotEmpty;  // Chỉ giữ lại các thành phố có địa điểm khớp
            }).toList();

            if (filteredData.isEmpty) {
              return Center(child: Text("Không có địa điểm nào khớp với bộ lọc"));
            }

            return Stack(
              children: [
                Image.asset(
                  'assets/Image/Background.png',
                  width: screenHeight,
                  height: screenHeight,
                  fit: BoxFit.none,
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
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
                              "Tìm kiếm",
                              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _isFilterVisible = !_isFilterVisible; // Cập nhật trạng thái
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
                      ),
                      // Thanh lọc
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 0),
                        child: Visibility(
                          visible: _isFilterVisible,
                          child: Column(
                            children: [
                              // Các widget lọc theo dòng
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  // Dropdown chọn tỉnh
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,  // Màu nền bên trong Container
                                      border: Border.all(
                                        color: Colors.black,  // Màu viền đen
                                        width: 1,  // Độ rộng viền
                                      ),
                                      borderRadius: BorderRadius.circular(5),  // Bo góc nếu bạn muốn viền bo tròn
                                    ),
                                    child: DropdownButton2<String>(
                                      dropdownStyleData:const DropdownStyleData(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                        ),
                                        maxHeight: 200,
                                      ),
                                      value: selectedCity,
                                      hint: Text("Chọn tỉnh"),
                                      items: cities.map((city) {
                                        return DropdownMenuItem<String>(
                                          value: city,
                                          child: Text(city),
                                        );
                                      }).toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          selectedCity = value;
                                        });
                                      },
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  // TextField nhập số lần đến tối thiểu
                                  Container(
                                    color: Colors.white,
                                    width: screenWidth * 2 / 5,
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
                                ],
                              ),
                              SizedBox(height: 5),
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
                      Container(
                        height: _isFilterVisible == false ? (screenHeight - 90) : (screenHeight - 320),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              // Hiển thị danh sách địa điểm
                              ...filteredData.map((entry) {
                                City city = entry.key;
                                List<Location> locations = entry.value;
                                return Column(
                                  children: [
                                    Text(city.name, style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold)),
                                    ...locations.map((location) {
                                      return GestureDetector(
                                        onTap: () {
                                          print("Location: ${location.title}");
                                        },
                                        child: Container(
                                          margin: const EdgeInsets.symmetric(vertical: 10),
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                              color: const Color(0xFFB0E0E6),
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
                                                    fontSize: 35,
                                                    fontWeight: FontWeight.bold),
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    'Số lần đến: ',
                                                    style: TextStyle(
                                                      fontSize: 25,
                                                    ),
                                                  ),
                                                  Text(
                                                    location.visitedTime.toString(),
                                                    style: TextStyle(
                                                      fontSize: 25,
                                                    ),
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
                                  ],
                                );
                              }).toList(),
                            ],
                          ),
                        ),
                      )
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
