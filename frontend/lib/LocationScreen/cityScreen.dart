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
    List<City> cities = await getInfoCity(accountModel.idUser,"","");
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

  final Map<String, String> listCity = {
    'An Giang': 'AnGiang',
    'Bà Rịa - Vũng Tàu': 'BaRiaVungTau',
    'Bắc Giang': 'BacGiang',
    'Bắc Kạn': 'BacKan',
    'Bạc Liêu': 'BacLieu',
    'Bắc Ninh': 'BacNinh',
    'Bến Tre': 'BenTre',
    'Bình Định': 'BinhDinh',
    'Bình Dương': 'BinhDuong',
    'Bình Phước': 'BinhPhuoc',
    'Bình Thuận': 'BinhThuan',
    'Cà Mau': 'CaMau',
    'Cần Thơ': 'CanTho',
    'Cao Bằng': 'CaoBang',
    'Đà Nẵng': 'DaNang',
    'Đắk Lắk': 'DakLak',
    'Đắk Nông': 'DakNong',
    'Điện Biên': 'DienBien',
    'Đồng Nai': 'DongNai',
    'Đồng Tháp': 'DongThap',
    'Gia Lai': 'GiaLai',
    'Hà Giang': 'HaGiang',
    'Hà Nam': 'HaNam',
    'Hà Nội': 'HaNoi',
    'Hà Tĩnh': 'HaTinh',
    'Hải Dương': 'HaiDuong',
    'Hải Phòng': 'HaiPhong',
    'Hậu Giang': 'HauGiang',
    'Hòa Bình': 'HoaBinh',
    'Hưng Yên': 'HungYen',
    'Khánh Hòa': 'KhanhHoa',
    'Kiên Giang': 'KienGiang',
    'Kon Tum': 'KonTum',
    'Lai Châu': 'LaiChau',
    'Lâm Đồng': 'LamDong',
    'Lạng Sơn': 'LangSon',
    'Lào Cai': 'LaoCai',
    'Long An': 'LongAn',
    'Nam Định': 'NamDinh',
    'Nghệ An': 'NgheAn',
    'Ninh Bình': 'NinhBinh',
    'Ninh Thuận': 'NinhThuan',
    'Phú Thọ': 'PhuTho',
    'Phú Yên': 'PhuYen',
    'Quảng Bình': 'QuangBinh',
    'Quảng Nam': 'QuangNam',
    'Quảng Ngãi': 'QuangNgai',
    'Quảng Ninh': 'QuangNinh',
    'Quảng Trị': 'QuangTri',
    'Sóc Trăng': 'SocTrang',
    'Sơn La': 'SonLa',
    'Tây Ninh': 'TayNinh',
    'Thái Bình': 'ThaiBinh',
    'Thái Nguyên': 'ThaiNguyen',
    'Thanh Hóa': 'ThanhHoa',
    'Thừa Thiên Huế': 'ThuaThienHue',
    'Tiền Giang': 'TienGiang',
    'Thành phố Hồ Chí Minh': 'TPHCM',
    'Trà Vinh': 'TraVinh',
    'Tuyên Quang': 'TuyenQuang',
    'Vĩnh Long': 'VinhLong',
    'Vĩnh Phúc': 'VinhPhuc',
    'Yên Bái': 'YenBai',
  };


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
                    onLongPress: () {
                      // Hiển thị hộp thoại xác nhận xóa
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            backgroundColor: Colors.white,
                            title: const Text("Xác nhận xóa"),
                            content: Text("Bạn có chắc chắn muốn xóa thành phố '${cities[i].name}' không?"),
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
                                  accountModel.removeCity(cities[i]);
                                  await RemoveCity(cities[i].id);
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
                          image: AssetImage('assets/City/${listCity[cities[i].name]}.png'),
                          fit: BoxFit.cover, // Hoặc BoxFit.none nếu bạn muốn giữ nguyên kích thước ảnh
                        ),
                      ),

                      child: Center(
                          child: Text(
                            cities[i].name,
                            style: TextStyle(
                                fontSize: 35,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFFFFFFF)
                            ),
                          )
                      ),

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

                      child: Center(child: Text("Thêm thành phố", style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold, color: Color(
                          0xFFFFFFFF)),)),
                    )
                ),
              ]
          )

      ),
    );
  }
}