import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class FitMarkersToBounds extends StatefulWidget {
  @override
  _FitMarkersToBoundsState createState() => _FitMarkersToBoundsState();
}

class _FitMarkersToBoundsState extends State<FitMarkersToBounds> {
  late GoogleMapController _mapController;

  // Danh sách marker
  final List<Marker> _markers = [
    Marker(
      markerId: MarkerId('marker_1'),
      position: LatLng(21.0285, 105.8542), // Hà Nội
      infoWindow: InfoWindow(title: 'Marker 1'),
    ),
    Marker(
      markerId: MarkerId('marker_2'),
      position: LatLng(21.0366, 105.8342), // Một vị trí khác
      infoWindow: InfoWindow(title: 'Marker 2'),
    ),
  ];

  // Polyline nối các marker
  final List<LatLng> _polylinePoints = [
    LatLng(21.0285, 105.8542), // Marker 1
    LatLng(21.0366, 105.8342), // Marker 2
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        onMapCreated: (controller) {
          _mapController = controller;
          _fitBounds(); // Căn chỉnh bản đồ sau khi khởi tạo
        },
        initialCameraPosition: CameraPosition(
          target: LatLng(21.0285, 105.8542), // Vị trí ban đầu
          zoom: 14,
        ),
        markers: _markers.toSet(),
        polylines: {
          Polyline(
            polylineId: PolylineId('route'),
            points: _polylinePoints,
            color: Colors.blue,
            width: 5,
          ),
        },
      ),
    );
  }

  // Hàm căn chỉnh bản đồ để hiển thị tất cả marker và polyline
  void _fitBounds() {
    if (_markers.isEmpty) return;

    // Tạo LatLngBounds bao quanh tất cả các điểm
    LatLngBounds bounds = _getLatLngBounds(
      _markers.map((m) => m.position).toList(),
    );

    // Điều chỉnh camera để phù hợp với LatLngBounds
    _mapController.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50)); // Padding 50px
  }

  // Hàm tính toán LatLngBounds từ danh sách LatLng
  LatLngBounds _getLatLngBounds(List<LatLng> positions) {
    double south = positions.first.latitude;
    double north = positions.first.latitude;
    double west = positions.first.longitude;
    double east = positions.first.longitude;

    for (var latLng in positions) {
      if (latLng.latitude < south) south = latLng.latitude;
      if (latLng.latitude > north) north = latLng.latitude;
      if (latLng.longitude < west) west = latLng.longitude;
      if (latLng.longitude > east) east = latLng.longitude;
    }

    return LatLngBounds(
      southwest: LatLng(south, west),
      northeast: LatLng(north, east),
    );
  }
}
