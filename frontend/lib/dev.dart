import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CustomMarkerExample extends StatefulWidget {
  @override
  _CustomMarkerExampleState createState() => _CustomMarkerExampleState();
}

class _CustomMarkerExampleState extends State<CustomMarkerExample> {
  late GoogleMapController _controller;

  final List<Marker> markers = [];

  @override
  void initState() {
    super.initState();
    _createMarkers();
  }

  Future<void> _createMarkers() async {
    // Tạo marker nhỏ hơn từ một hình ảnh
    final customIcon = await _resizeMarkerAsset("assets/marker.png", 50, 50);

    setState(() {
      markers.addAll([
        Marker(
          markerId: MarkerId("marker1"),
          position: LatLng(10.762622, 106.660172), // TP HCM
          icon: customIcon,
          infoWindow: InfoWindow(title: "TP HCM"),
        ),
        Marker(
          markerId: MarkerId("marker2"),
          position: LatLng(21.028511, 105.804817), // Hà Nội
          icon: customIcon,
          infoWindow: InfoWindow(title: "Hà Nội"),
        ),
      ]);
    });
  }

  Future<BitmapDescriptor> _resizeMarkerAsset(
      String assetPath, int width, int height) async {
    // Load hình ảnh từ tài nguyên
    final ByteData data = await DefaultAssetBundle.of(context).load("assets/Common/VN.png");
    final ui.Codec codec = await ui.instantiateImageCodec(
      data.buffer.asUint8List(),
      targetWidth: width,
      targetHeight: height,
    );
    final ui.FrameInfo frameInfo = await codec.getNextFrame();

    // Chuyển đổi hình ảnh thành byte array
    final ByteData? resizedData =
    await frameInfo.image.toByteData(format: ui.ImageByteFormat.png);

    return BitmapDescriptor.fromBytes(resizedData!.buffer.asUint8List());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Custom Marker Example")),
      body: GoogleMap(
        onMapCreated: (GoogleMapController controller) {
          _controller = controller;
        },
        markers: markers.toSet(),
        initialCameraPosition: CameraPosition(
          target: LatLng(16.047079, 108.206230), // Đà Nẵng
          zoom: 5,
        ),
      ),
    );
  }
}
