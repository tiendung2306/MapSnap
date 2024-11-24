
import 'package:flutter/material.dart';
import 'package:mapsnap_fe/Model/City.dart';
import 'package:mapsnap_fe/Model/Location.dart';
import '../Model/Picture.dart';
import '../Model/Token_2.dart';
import '../Model/User_2.dart';


// Class để quản lý các biến dùng chung
class AccountModel extends ChangeNotifier {

  // ================ Phần cho user =================================
  User? _user;
  late Token _token;


  String get avatar => _user?.avatar ?? ".....";
  String get phoneNumber => _user?.numberPhone ?? "??????";
  String get token_access => _token.token_access;
  String get token_refresh => _token.token_refresh;
  DateTime get token_refresh_expires => _token.token_access_expires;
  String get idUser => _user?.idUser ?? 'Chua co id';
  String get username => _user?.username ?? 'Chưa có tên người dùng';
  String get email => _user?.email ?? 'Chưa có email';
  String get address => _user?.address ?? 'Thêm địa chỉ';
  String get role => _user?.role ?? '.....';


  // Setter để cập nhật `User`
  void setUser(User newUser) {
    _user = newUser;
    notifyListeners(); // Thông báo thay đổi
  }

  void setToken(Token newToken) {
    _token = newToken;
    notifyListeners(); // Thông báo thay đổi
  }


  //================== Quản lý ảnh theo ngày =====================
  Map<String, List<Picture>> _groupedImages = {};
  Map<String, List<Picture>> get groupedImages => _groupedImages;


   void resetGroupedImages() {
     _groupedImages = {};
     notifyListeners();
   }
  // Hàm lưu ảnh theo ngày
  void addImageDay(Picture image,String dayString) {
    if (_groupedImages.containsKey(dayString)) {
      _groupedImages[dayString]!.insert(0,image);
    } else {
      _groupedImages[dayString] = [image];
    }
    notifyListeners();
  }

  // Hàm lưu ảnh theo ngày
  void removeImageDay(Picture image,int dayIndex,String dayString) {
    if (dayIndex < _groupedImages.length) {
      _groupedImages[dayString]!.remove(image);
      // Nếu ngày đó không còn ảnh nào, xóa cả ngày (tuỳ chọn)
      if (_groupedImages[dayString]!.isEmpty) {
        _groupedImages.remove(dayString);
      }
      notifyListeners(); // Cập nhật giao diện
    }
  }


//================== Quản lý ảnh theo địa điểm =====================
  Map<String,Map<String,List<String>>> _imageManager = {
    'Hà Nội': {
      'Lăng Bác': ['assets/Image/1.jpg','assets/Image/2.jpg']
    },
    'Vinh': {
      'Quảng trường': ['assets/Image/4.jpg','assets/Image/5.jpg'],
      'BigC': ['assets/Image/6.jpg','assets/Image/7.jpg','assets/Image/8.jpg']
    },
  };
  Map<String,Map<String,List<String>>> get imageManager => _imageManager;


  // Hàm lưu ảnh theo địa điểm
  void addImageLocation(String image, String journey, String visit) {
    if (_imageManager.containsKey(journey)) {
      if (_imageManager[journey]!.containsKey(visit)) {
        print('0');
        _imageManager[journey]![visit]!.insert(0, image);
      } else {
        _imageManager[journey]![visit] = [image];
        print('1');
      }
    } else {
      _imageManager[journey] = {visit: [image]};
    }
    notifyListeners(); // Gọi hàm để cập nhật lại UI
  }

  // Hàm xóa ảnh theo địa điểm
  void removeImageLocation(String image, String journey, String visit) {
    if (_imageManager.containsKey(journey)) {
      if (_imageManager[journey]!.containsKey(visit)) {
        _imageManager[journey]![visit]!.remove(image);
        if (_imageManager[journey]![visit]!.isEmpty) {
          _imageManager[journey]!.remove(visit); // Xóa visit nếu danh sách ảnh trống
        }
        if (_imageManager[journey]!.isEmpty) {
          _imageManager.remove(journey); // Xóa journey nếu không còn visit nào
        }
      }
    }
    notifyListeners(); // Gọi hàm để cập nhật lại UI
  }

  //=================================================================================
  Map<String,List<Map<String,String>>> _locationManager = {
    'Hà Nội': [
      {
        'Tên': 'Lăng  Bác',
        'Số lần đến': '5',
        'Lần đến gần nhất': '10-10-2024'
      },
      {
        'Tên': 'Công viên thống nhất',
        'Số lần đến': '20',
        'Lần đến gần nhất': '15-11-2024'
      },
      {
        'Tên': 'Bến xe Nước Ngầm',
        'Số lần đến': '2',
        'Lần đến gần nhất': '1-11-2024'
      },
      {
        'Tên': 'Times City',
        'Số lần đến': '1',
        'Lần đến gần nhất': '1-9-2024'
      },
    ],
    'Nghệ An': [
      {
        'Tên': 'Công viên nước',
        'Số lần đến': '2',
        'Lần đến gần nhất': '10-6-2024'
      },
      {
        'Tên': 'Quảng trường HCM',
        'Số lần đến': '1',
        'Lần đến gần nhất': '30-04-2024'
      },
      {
        'Tên': 'Biển Cửa Lò',
        'Số lần đến': '2',
        'Lần đến gần nhất': '1-11-2024'
      },
      {
        'Tên': 'Hòn Câu',
        'Số lần đến': '99999',
        'Lần đến gần nhất': '23-11-2024'
      },
    ]
  };
  Map<String,List<Map<String,String>>> get locationManager => _locationManager;

  void addLocation(String city, Map<String,String> location) {
    // Kiểm tra nếu hành trình đã tồn tại
    if (_locationManager.containsKey(city)) {
      _locationManager[city]?.insert(0, location);
    } else {
      // Nếu địa điểm chưa có, tạo mới danh sách ảnh
      _locationManager[city] = [location] ;

    }
    notifyListeners(); // Gọi hàm để cập nhật lại UI
  }

  List<City> _cityManager = [];
  List<City> get cityManager => _cityManager;

  void addCity(City newCity) {
    _cityManager.insert(0, newCity);
    notifyListeners();
  }

  List<Location> _LocationManager = [];
  List<Location> get LocationManager => _LocationManager;

  void addLocation2(Location newLocation) {
    _LocationManager.insert(0, newLocation);
    notifyListeners();
  }
}
