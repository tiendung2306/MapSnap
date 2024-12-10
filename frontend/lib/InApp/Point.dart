import 'package:mapsnap_fe/Model/Visit.dart';
import 'package:mapsnap_fe/Model/Location.dart';
import 'package:mapsnap_fe/Model/Position.dart';

class Point {
  final double longitude;
  final double latitude;

  String type;

  Visit? visit;
  Position? position;
  Location? location;

  String getName() {
    if(type == 'visit')
      return visit?.title ?? 'unknown';

    else
      return position?.address ?? 'unknown';
  }

  Point({required this.type, required this.longitude,required this.latitude, this.position, this.visit, this.location});
}
//
// List<Point> positions = [
//   Point(
//     name: 'Ng. 46 P. Hồng Mai',
//     type: 'visit',
//     latitude: 20.998283,
//     longitude: 105.851447,
//   ),
//   Point(
//     name: '12B Ng. Mai Hương',
//     type: 'position',
//     latitude: 20.998609,
//     longitude: 105.851505,
//   ),
//   Point(
//     name: '430-442 P. Bạch Mai',
//     type: 'position',
//     latitude: 20.998820,
//     longitude: 105.850331,
//   ),
//   Point(
//     name: '339-425 P. Bạch Mai',
//     type: 'position',
//     latitude: 21.000622,
//     longitude: 105.850592,
//   ),
//   Point(
//     name: 'Soofood',
//     type: 'visit',
//     latitude: 21.000721,
//     longitude: 105.850068,
//   ),
//   Point(
//     name: 'Trung tâm học tập trực tuyến',
//     type: 'position',
//     latitude: 21.000829,
//     longitude: 105.849764,
//   ),
//   Point(
//     name: '112-102 P. Tạ Quang Bửu',
//     type: 'position',
//     latitude: 21.001253,
//     longitude: 105.849367,
//   ),
//   Point(
//     name: '304 K12 Tổ dânphố 9',
//     type: 'position',
//     latitude: 21.001812,
//     longitude: 105.849375,
//   ),
//   Point(
//     name: '20 P. Tạ Quang Bửu',
//     type: 'position',
//     latitude: 21.002266,
//     longitude: 105.848933,
//   ),
//   Point(
//     name: 'Chill The Barber',
//     type: 'visit',
//     latitude: 21.002662,
//     longitude: 105.848554,
//   ),
//   Point(
//     name: 'P. Tạ Quang Bửu',
//     type: 'position',
//     latitude: 21.003209,
//     longitude: 105.848036,
//   ),
//   Point(
//     name: '24 Ng. 40 P. Tạ Quang Bửu',
//     type: 'position',
//     latitude: 21.004073,
//     longitude: 105.847158,
//   ),
//   Point(
//     name: '411 K12 Tổ dânphố 9',
//     type: 'position',
//     latitude: 21.004483,
//     longitude: 105.847243,
//   ),
//   Point(
//     name: 'Bach Khoa',
//     type: 'position',
//     latitude: 21.004940,
//     longitude: 105.846947,
//   ),
//   Point(
//     name: 'Bach Khoa ăn vặt',
//     type: 'position',
//     latitude: 21.005874,
//     longitude: 105.847261,
//   ),
//   Point(
//     name: '6-5 P. Tạ Quang Bửu',
//     type: 'visit',
//     latitude: 21.006844,
//     longitude: 105.847286,
//   ),
//   Point(
//     name: '22 P. Tạ Quang Bửu',
//     type: 'position',
//     latitude: 21.007343,
//     longitude: 105.847439,
//   ),
//   Point(
//     name: 'Đ. Đại Cồ Việt',
//     type: 'position',
//     latitude: 21.008140,
//     longitude: 105.847406,
//   ),
//   Point(
//     name: 'Đ. Đại Cồ Việt quay đầu',
//     type: 'position',
//     latitude: 21.008325,
//     longitude: 105.848353,
//   ),
//   Point(
//     name: 'Hanoï',
//     type: 'visit',
//     latitude: 21.008499,
//     longitude: 105.848325,
//   ),
//   Point(
//     name: '141 P. Hoa Lư',
//     type: 'position',
//     latitude: 21.008429,
//     longitude: 105.847766,
//   ),
//   Point(
//     name: '13 P. Hoa Lư',
//     type: 'visit',
//     latitude: 21.008636,
//     longitude: 105.847711,
//   ),

// ];