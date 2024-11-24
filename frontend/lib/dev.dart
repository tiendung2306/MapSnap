import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:math';

class CustomMarkerMap extends StatefulWidget {
  @override
  _CustomMarkerMapState createState() => _CustomMarkerMapState();
}

class _CustomMarkerMapState extends State<CustomMarkerMap> {
  late GoogleMapController mapController;
  Set<Marker> markers = {};

  @override
  void initState() {
    super.initState();
    final List<LatLng> routePoints = [
      LatLng(21.0285, 105.8542), // Marker 1
      LatLng(21.0300, 105.8600), // Marker 2
      LatLng(21.0400, 105.8500), // Marker 3
      LatLng(21.0200, 105.8900), // Marker 3
      LatLng(21.0300, 105.8900), // Marker 3

    ];

    addMarkersWithRotation(routePoints);
  }



  double calculateBearing(LatLng start, LatLng end) {
    final double startLat = start.latitude * (pi / 180); // Chuyển đổi sang radian
    final double startLng = start.longitude * (pi / 180);
    final double endLat = end.latitude * (pi / 180);
    final double endLng = end.longitude * (pi / 180);

    final double dLng = endLng - startLng;

    final double y = sin(dLng) * cos(endLat);
    final double x = cos(startLat) * sin(endLat) - sin(startLat) * cos(endLat) * cos(dLng);

    double bearing = atan2(y, x) * (180 / pi); // Chuyển từ radian sang độ
    bearing = (bearing + 360) % 360; // Chuyển góc về khoảng [0, 360]
    return bearing;
  }

  void addMarkersWithRotation(List<LatLng> points) async {
    final BitmapDescriptor icon = await BitmapDescriptor.asset(
      const ImageConfiguration(size: Size(20, 20)),
      'assets/Common/Stop.png', // Đường dẫn tới icon của bạn
    );

    for (int i = 0; i < points.length - 1; i++) {
      print('vpa');
      final LatLng start = points[i];
      final LatLng next = points[i + 1];
      final double rotation = calculateBearing(start, next); // Tính góc giữa 2 điểm

      final marker = Marker(
        markerId: MarkerId('marker_$i'),
        position: start,
        icon: icon,
        anchor: Offset(0.5, 0.5), // Center của icon trùng tọa độ
        rotation: rotation, // Góc xoay
        infoWindow: InfoWindow(title: 'Marker $i'),
      );

      markers.add(marker);
    }
  }


  Future<void> _addCustomMarkers() async {
    final customIcon = await BitmapDescriptor.asset(
      ImageConfiguration(size: Size(48, 48)), // Kích thước tùy chọn
      'assets/Common/add.png', // Đường dẫn tới ảnh trong thư mục assets
    );

    setState(() {
      markers.add(
        Marker(
          markerId: MarkerId('marker_1'),
          position: LatLng(21.0278, 105.8342), // Vị trí marker (VD: Hà Nội)
          icon: customIcon,
          infoWindow: InfoWindow(
            title: 'Vị trí tùy chỉnh',
            snippet: 'Hà Nội, Việt Nam',
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Custom Marker Example')),
      body: GoogleMap(
        onMapCreated: (GoogleMapController controller) {
          mapController = controller;
        },
        initialCameraPosition: CameraPosition(
          target: LatLng(21.0400, 105.8500), // Tọa độ khởi tạo
          zoom: 14.0,
        ),
        markers: markers,
      ),
    );
  }
}
