import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DevScreen extends StatefulWidget {
  @override
  _DevScreenState createState() => _DevScreenState();
}

class _DevScreenState extends State<DevScreen> {
  late GoogleMapController _mapController;
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _addMarkers();
  }

  void _addMarkers() {
    _markers.add(
      Marker(
        markerId: MarkerId('marker_1'),
        position: LatLng(21.028511, 105.804817), // Tọa độ Hà Nội
        infoWindow: InfoWindow(title: 'Marker 1', snippet: 'This is Marker 1'),
        onTap: () {
          _updateMarker('marker_1');
        },
      ),
    );

    _markers.add(
      Marker(
        markerId: MarkerId('marker_2'),
        position: LatLng(21.0245, 105.8067), // Tọa độ gần Hà Nội
        infoWindow: InfoWindow(title: 'Marker 2', snippet: 'This is Marker 2'),
        onTap: () {
          _updateMarker('marker_2');
        },
      ),
    );
  }

  void _updateMarker(String markerId) async {
    print('asdasd');
    final BitmapDescriptor visitTab1 = await BitmapDescriptor.asset(
      const ImageConfiguration(size: Size(20, 20)),
      'assets/Common/visitTab1.png', // Đường dẫn tới icon của bạn
    );
    setState(() {
      _markers = _markers.map((marker) {
        if (marker.markerId.value == markerId) {
          return marker.copyWith(
            iconParam: visitTab1
          );
        }
        return marker;
      }).toSet();
    });
  }


  void _onMarkerTapped(String markerName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Marker Tapped'),
        content: Text('You tapped on $markerName'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Google Maps Marker Interaction'),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(21.028511, 105.804817),
          zoom: 15,
        ),
        markers: _markers,
        onMapCreated: (GoogleMapController controller) {
          _mapController = controller;
        },
      ),
    );
  }
}
