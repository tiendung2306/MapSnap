import 'package:geocoding/geocoding.dart';

// Hàm lấy địa chỉ từ latitude và longitude
Future<List<Placemark>?> getAddress(double latitude, double longitude) async {
  List<Placemark> placemarks = [];
  try {
    // Lấy danh sách địa chỉ từ tọa độ (latitude, longitude)
    final response = await placemarkFromCoordinates(latitude, longitude);
    for(Placemark plm in response)
      placemarks.add(plm);

    return placemarks;

  } catch (e) {
    print("Lỗi khi lấy địa chỉ: $e");
    return null;
  }
}