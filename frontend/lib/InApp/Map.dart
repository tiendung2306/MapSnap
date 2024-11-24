import 'package:flutter/material.dart';
import 'package:mapsnap_fe/Widget/ExpandableListTile.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mapsnap_fe/Model/Journey.dart';
import 'package:mapsnap_fe/Model/Visit.dart';
import 'package:mapsnap_fe/Model/Location.dart';
import 'package:mapsnap_fe/Services/APIService.dart';
import 'dart:math';

class MapScreen extends StatefulWidget {
  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> with SingleTickerProviderStateMixin{
  final  _apiService = ApiService();

  bool isDataLoad = false;
  bool isMapLoad = false;
  bool isJustStart = true;

  late TabController _tabController;
  late double SlideTabTop = 700;
  int currVisit = 0;

  late Journey journey;
  final List<Visit> visits = [];
  final List<Location> locations = [];

  late GoogleMapController _controller;
  late Set<Marker> _markers;
  double _zoomLevel = 14.0;
  Set<Polyline> _polylines = {};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void loadData() async{
    final response = await _apiService.GetJourney('67424c5cd90b1044dcf97d40');
    final data = response["data"]["result"];
    journey = Journey.fromJson(data);

    _markers = {};
    List<LatLng> points = [];

    for (var visitId in journey.visitIds) {
      final visit_response = await _apiService.GetVisit(visitId);
      Visit visit = Visit.fromJson(visit_response["data"]["result"]);
      visits.add(visit);

      final location_response = await _apiService.GetLocation(visit.locationId);
      Location location = Location.fromJson(location_response["data"]["result"]);
      locations.add(location);

      points.add(LatLng(location.latitude, location.longitude));
    }

    addMarkersWithRotation(locations);


    _polylines.add(Polyline(
      polylineId: PolylineId('route'),
      points: points,
      color: Colors.greenAccent,
      width: 5,
    ),);

    setState(() {
      isDataLoad = true;
    });

  }

  void onVisitTap(int index) {
    setState(() {
      if(currVisit == index){
        currVisit = -1;
        _deleteMarker('current_marker');
        _fitBounds();
      }
      else{
        currVisit = index;
        _addMarker(LatLng(locations[currVisit].latitude,
            locations[currVisit].longitude), 'current_marker', Offset(0.5, 1.5));
        CameraUpdate cameraUpdate = CameraUpdate.newLatLngZoom(LatLng(locations[currVisit].latitude,
            locations[currVisit].longitude), 15);
        _controller.animateCamera(cameraUpdate);
      }
    });
  }

  void _fitBounds() async {
    if (_markers.isEmpty) return;

    // Tạo LatLngBounds bao quanh tất cả các điểm
    LatLngBounds bounds = _getLatLngBounds(
      _markers.map((m) => m.position).toList(),
    );

    // Điều chỉnh camera để phù hợp với LatLngBounds
    await _controller.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50)); // Padding 50px

    _zoomLevel = await _controller.getZoomLevel();

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

  void _onMapCreated(GoogleMapController controller) {
    _controller = controller;
    _fitBounds();
    setState(() {
      isMapLoad = true;
    });
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

  void addMarkersWithRotation(List<Location> points) async {
    final BitmapDescriptor icon = await BitmapDescriptor.asset(
      const ImageConfiguration(size: Size(20, 20)),
      'assets/Common/Stop.png', // Đường dẫn tới icon của bạn
    );

    for (int i = 0; i < points.length - 1; i++) {
      final LatLng start = LatLng(points[i].latitude, points[i].longitude);
      final LatLng next = LatLng(points[i + 1].latitude, points[i + 1].longitude);
      final double rotation = calculateBearing(start, next); // Tính góc giữa 2 điểm

      final marker = Marker(
        markerId: MarkerId(points[i].locationName),
        position: start,
        icon: icon,
        anchor: Offset(0.5, 0.5), // Center của icon trùng tọa độ
        rotation: rotation, // Góc xoay
        infoWindow: InfoWindow(title: points[i].locationName),
      );

      _markers.add(marker);
    }
  }
  // Có thể dùng BitmapDescriptor để custom marker
  void _addMarker(LatLng position, String id, Offset offset) {
    setState(() {
      _markers.add(Marker(
        markerId: MarkerId(id),
        position: position,
        anchor: offset,
        // infoWindow: InfoWindow(title: 'New Marker'),
      ));
    });
  }

  void _deleteMarker(String id) {
    setState(() {
      _markers.removeWhere((marker) => marker.markerId.value == id);
    });
  }

  void _moveCamera(LatLng position) {
    _controller.animateCamera(
      CameraUpdate.newLatLng(position),
    );
  }

  void _zoomIn() {
    _zoomLevel++;
    _controller.animateCamera(
      CameraUpdate.zoomTo(_zoomLevel),
    );
  }

  void _zoomOut() {
    _zoomLevel--;
    _controller.animateCamera(
      CameraUpdate.zoomTo(_zoomLevel),
    );
  }

  void _zoomTo(double zoomLevel) {
    _zoomLevel = zoomLevel;
    _controller.animateCamera(
      CameraUpdate.zoomTo(_zoomLevel),
    );
  }

  Container LoadingScreen(){
    return Container(
      color: Colors.white,
      child: Center(
        child: Text(
            'Loading'
        ),
      ),
    );
  }

  GoogleMap Map(){
    return GoogleMap(
      onMapCreated: _onMapCreated,
      initialCameraPosition: CameraPosition(
        target: LatLng(locations[0].latitude, locations[0].longitude),
        zoom: _zoomLevel,
      ),
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
      zoomControlsEnabled: false, // Tắt nút phóng to/thu nhỏ mặc định
      markers: _markers.toSet(),
      polylines: _polylines,


    );
  }

  Positioned Header(){
    return Positioned(
      top: 50,
      left: 10,
      right: 10,
      child: Container(
        // width: 100,
        height: 45,
        padding: EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 5)],
        ),
        child: Stack(
          children: [
            IconButton(
              onPressed: (){},
              icon: Icon(Icons.arrow_back),
            ),
            Align(
                alignment: Alignment.center,
                child: Text(
                    'Today route',
                    style: TextStyle(fontSize: 18)
                )
            ),
          ],
        ),
      ),
    );
  }

  Positioned BottomSlider(){
    return Positioned(
      bottom: 0,
      top: SlideTabTop,
      left: 0,
      right: 0,
      child: Column(
        children: [
          //Thanh cuộn
          Container(
            height: 15,
            width: double.infinity,
            color: Colors.white,
            child: Align(
              alignment: Alignment.center,
              child: GestureDetector(
                onPanUpdate: (details){
                  setState(() {
                    if(SlideTabTop + details.delta.dy > 200 && SlideTabTop + details.delta.dy < 800)
                      SlideTabTop += details.delta.dy;
                  });
                },
                child: Container(
                  width: 100,
                  height: 7,
                  decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(3)
                  ),
                ),
              ),
            ),
          ),
          //Các feature
          Container(
            width: double.infinity,
            color: Colors.white,
            child: Column(
              children: [
                TabBar(
                  controller: _tabController,
                  labelColor: Colors.green,
                  unselectedLabelColor: Colors.black,
                  indicatorColor: Colors.green,
                  tabs: [
                    Tab(text: "Stop"),
                    Tab(text: "Path"),
                    Tab(text: "Period"),
                  ],
                ),
              ],
            ),
          ),
          //Hiệu ứng đổ bóng
          Container(
            height: 5, width: double.infinity,
            color: Colors.white,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,  // Bắt đầu gradient từ trên
                  end: Alignment.bottomCenter, // Kết thúc gradient ở dưới
                  colors: [
                    Colors.grey.withOpacity(1.0), // Màu ở trên cùng, với độ mờ
                    Colors.grey.withOpacity(0.0), // Màu ở dưới cùng, nhạt hơn
                  ],
                ),
              ),
            ),
          ),
          //Journey
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Nội dung cho từng tab
                Container(
                  color: Colors.white,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: locations.length,
                    itemBuilder: (context, index){
                      return ExpandableListTile(
                        index: index,
                        isFocus: currVisit == index,
                        title: locations[index].locationName,
                        subtitle: "Subtitle",
                        content: "Content",
                        onTapFunc: onVisitTap,
                      );
                    },
                  ),
                ),
                Container(
                  color: Colors.white,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: locations.length,
                    itemBuilder: (context, index){
                      return ExpandableListTile(
                        index: index,
                        isFocus: currVisit == index,
                        title: locations[index].locationName,
                        subtitle: "Subtitle",
                        content: "Content",
                        onTapFunc: onVisitTap,
                      );
                    },
                  ),
                ),
                Center(child: Text("Content for Feature 3")),
              ],
            ),
          )
        ],
      ),
    );
  }

  Positioned ZoomInOut(){
    return Positioned(
      top: 50, // Di chuyển lên trên
      right: 10, // Căn lề phải
      child: Column(
        children: [
          FloatingActionButton(
            heroTag: "zoomIn", // Đặt heroTag để tránh lỗi nếu có nhiều nút
            mini: true,
            onPressed: _zoomIn,
            child: Icon(Icons.add),
          ),
          SizedBox(height: 10),
          FloatingActionButton(
            heroTag: "zoomOut",
            mini: true,
            onPressed: _zoomOut,
            child: Icon(Icons.remove),
          ),
        ],
      ),
    );
  }

  Container Screen(){
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        children: [
          Map(),
          // Các phần tử UI trên bản đồ
          Header(),
          // Phần thanh cuộn bên dưới
          BottomSlider(),

          ZoomInOut(),

          if(!isMapLoad)
            LoadingScreen(),
        ],
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: !isDataLoad ?
      LoadingScreen():
      Screen(),
    );
  }
}


