import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapTab extends StatefulWidget {
  @override
  _GoogleMapTabState createState() => _GoogleMapTabState();
}

class _GoogleMapTabState extends State<GoogleMapTab>
    with AutomaticKeepAliveClientMixin {
  late GoogleMapController _mapController;

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context); // Cần gọi để kích hoạt `AutomaticKeepAliveClientMixin`
    return GoogleMap(
      onMapCreated: (controller) => _mapController = controller,
      initialCameraPosition: CameraPosition(
        target: LatLng(21.0285, 105.8542), // Hà Nội
        zoom: 14.0,
      ),
    );
  }
}
