import 'dart:async';
import 'dart:math';

import 'package:flutter/src/widgets/framework.dart';
import 'package:mapsnap_fe/Manager/CURD_city.dart';
import 'package:mapsnap_fe/Manager/CURD_location.dart';
import 'package:mapsnap_fe/Model/City.dart';
import 'package:mapsnap_fe/Model/Location.dart';
import 'package:mapsnap_fe/Widget/accountModel.dart';
import 'package:provider/provider.dart';
Timer? refreshTimer;

void autoCallAPI(BuildContext context) {
  const Duration interval = Duration(seconds: 120); // Gọi lại sau mỗi 30 giây
  refreshTimer?.cancel(); // Hủy bỏ timer cũ nếu có
  refreshTimer = Timer.periodic(interval, (Timer timer) async {
    var accountModel = Provider.of<AccountModel>(context, listen: false);
    Map<String, double> coordinates = randomVietnamCoordinates();
    int randomNumber = randomvisitedTime();
    InfoVisit? infoLocation = await AutoLocation(coordinates['latitude']!,coordinates['longitude']!);
    List<City> cities = await getInfoCity(accountModel.idUser,"searchText",infoLocation!.province);
    List<Location> locations = await getInfoLocation(accountModel.idUser, infoLocation.address,"searchText");
    if(locations.isEmpty) {
      print('heheh');
      City? city;
      if(cities.isEmpty) {
        CreateCity createCity = CreateCity(
          name: infoLocation.province,
          visitedTime: randomNumber,
          createdAt: 15415215455,
          status: "enabled",
          updatedByUser: false,
          isAutomaticAdded: true,
        );
        city = await upLoadCity(createCity, accountModel.idUser);
      } else {
        city = cities[0];
      }

      CreateLocation createLocation = CreateLocation(
          cityId: city!.id,
          categoryId: "6749c77473001346446af335",
          title: infoLocation.homeNumber,
          visitedTime: 1,
          longitude: coordinates['latitude']!,
          latitude: coordinates['longitude']!,
          createdAt: 5645165423185,
          status: "enabled",
          updatedByUser: true,
          isAutomaticAdded: false,
          address: infoLocation.address,
          country: "Việt Nam",
          district: infoLocation.district,
          homeNumber: infoLocation.homeNumber,
        );
      await upLoadLocation(createLocation, accountModel.idUser);
    }
  });
}

Map<String, double> randomVietnamCoordinates() {
  final random = Random();

  // Giới hạn Latitude và Longitude trong phạm vi Việt Nam
  double minLat = 8.179;
  double maxLat = 23.392;
  double minLng = 102.144;
  double maxLng = 109.464;

  // Random tọa độ
  double randomLat = minLat + (maxLat - minLat) * random.nextDouble();
  double randomLng = minLng + (maxLng - minLng) * random.nextDouble();

  return {
    'latitude': randomLat,
    'longitude': randomLng,
  };
}


int randomvisitedTime() {
  final random = Random();

  // Random số nguyên từ 1 đến 200
  return random.nextInt(200) + 1; // nextInt(200) trả giá trị từ 0 đến 199, cộng thêm 1 để thành 1 đến 200
}