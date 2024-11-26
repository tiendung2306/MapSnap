
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mapsnap_fe/Model/City.dart';
import 'package:mapsnap_fe/Model/Location.dart';
import 'package:mapsnap_fe/Model/LocationCategory.dart';
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
  Map<City,List<Location>> _locationManager = {};
  Map<City,List<Location>> get locationManager => _locationManager;

  void addLocation(City city, Location? location) {
    // Kiểm tra nếu hành trình đã tồn tại
    if (_locationManager.containsKey(city)) {
      _locationManager[city]?.insert(0, location!);
    } else if(location != null) {
      // Nếu địa điểm chưa có, tạo mới danh sách ảnh
      _locationManager[city] = [location] ;
    } else {
      _locationManager[city] = [] ;
    }
    notifyListeners(); // Gọi hàm để cập nhật lại UI
  }

  void resetCity() {
    _locationManager = {};
    notifyListeners();
  }

  void resetLocation(City city) {
    _locationManager[city] = [];
    notifyListeners();
  }


  Map<LocationCategory,List<Location>> _locationCategoryManager = {};
  Map<LocationCategory,List<Location>> get locationCategoryManager => _locationCategoryManager;

  void addLocationCategory(LocationCategory category, Location? location) {
    // Kiểm tra nếu hành trình đã tồn tại
    if (_locationCategoryManager.containsKey(category)) {
      _locationCategoryManager[category]?.insert(0, location!);
    } else if(location != null) {
      // Nếu địa điểm chưa có, tạo mới danh sách ảnh
      _locationCategoryManager[category] = [location] ;
    } else {
      _locationCategoryManager[category] = [] ;
    }
    notifyListeners(); // Gọi hàm để cập nhật lại UI
  }

  void resetLocationCategory() {
    _locationCategoryManager = {};
    notifyListeners();
  }

  void resetLocation2(LocationCategory category) {
    _locationCategoryManager[category] = [];
    notifyListeners();
  }
}
