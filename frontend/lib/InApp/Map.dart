import 'package:flutter/material.dart';
// import 'package:mapsnap_fe/InApp/TodayModel.dart';
import 'package:mapsnap_fe/Widget/ExpandableListTile.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mapsnap_fe/Model/Journey.dart';
import 'package:mapsnap_fe/Model/Visit.dart';
import 'package:mapsnap_fe/Model/Location.dart';
import 'package:mapsnap_fe/Services/APIService.dart';

class MapScreen extends StatefulWidget {
  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> with SingleTickerProviderStateMixin{
  final  _apiService = ApiService();

  bool isDataLoad = false;
  bool isMapLoad = false;

  late TabController _tabController;

  late double SlideTabTop = 400;

  late Journey journey;
  final List<Visit> visits = [];
  final List<Location> locations = [];

  int currVisit = 0;
  late GoogleMapController _controller;
  late Set<Marker> _markers;
  double _zoomLevel = 14.0; // Mức phóng to ban đầu
  Set<Polyline> _polylines = {};


  void loadData() async{
    final response = await _apiService.GetJourney('673a36e9c516704fa4524ee5');
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

      _addMarker(LatLng(location.latitude, location.longitude), location.locationName);

      points.add(LatLng(location.latitude, location.longitude));
    }

    _polylines.add(Polyline(
      polylineId: PolylineId('route'),
      points: points,
      color: Colors.blue, // Màu của đường
      width: 5, // Độ rộng của đường
    ),);

    setState(() {
      isDataLoad = true;
    });

  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void onVisitTap(int index) {
    setState(() {
      if(currVisit == index){
        currVisit = -1;
        _fitBounds();
      }
      else{
        currVisit = index;
        CameraUpdate cameraUpdate = CameraUpdate.newLatLngZoom(LatLng(locations[currVisit].latitude,
            locations[currVisit].longitude), 15);
        _controller.animateCamera(cameraUpdate);
      }
    });
  }

  void _fitBounds() {
    if (_markers.isEmpty) return;

    // Tạo LatLngBounds bao quanh tất cả các điểm
    LatLngBounds bounds = _getLatLngBounds(
      _markers.map((m) => m.position).toList(),
    );

    // Điều chỉnh camera để phù hợp với LatLngBounds
    _controller.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50)); // Padding 50px
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


  void _addMarker(LatLng position, String id) {
    setState(() {
      _markers.add(Marker(
        markerId: MarkerId(id),
        position: position,
        // infoWindow: InfoWindow(title: 'New Marker'),
      ));
    });
  }

  void _moveCamera(LatLng position) {
    _controller.animateCamera(
      CameraUpdate.newLatLng(position), // Ví dụ với tọa độ Hà Nội
    );
  }

  // Hàm phóng to
  void _zoomIn() {
    _zoomLevel++;
    _controller.animateCamera(
      CameraUpdate.zoomTo(_zoomLevel),
    );
  }

  // Hàm thu nhỏ
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

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: !isDataLoad ?
      Container(
        color: Colors.white,
        child: Center(
          child: Text(
            'Loading'
          ),
        ),
      ) :
      Container(
        width: double.infinity,
        height: double.infinity,
        // color: Colors.red,
        child: Stack(

          children: [

            GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: currVisit == -1 ? LatLng(21.0285, 105.8542) :
                  LatLng(locations[currVisit].latitude, locations[currVisit].longitude),
                zoom: 13,
              ),
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false, // Tắt nút phóng to/thu nhỏ mặc định
              markers: _markers.toSet(),
              polylines: _polylines,


            ),
            // Các phần tử UI trên bản đồ
            Positioned(
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
            ),

            // Phần thanh cuộn bên dưới
            Positioned(
              bottom: 0,
              top: SlideTabTop,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  Container(
                    height: 15,
                    width: double.infinity,
                    color: Colors.white,
                    child: Align(
                      alignment: Alignment.center,
                      child: GestureDetector(
                        onPanUpdate: (details){
                          setState(() {
                            if(SlideTabTop + details.delta.dy > 200 && SlideTabTop + details.delta.dy < 700)
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
                            Tab(text: "Feature 1"),
                            Tab(text: "Feature 2"),
                            Tab(text: "Feature 3"),
                            Tab(text: "Feature 4"),
                          ],
                        ),
                      ],
                    ),
                  ),
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
                        SingleChildScrollView(
                          child: Column(
                            children: [
                              Container(
                                width: double.infinity, height: 500,
                                color: Colors.red,
                              ),
                              Container(
                                width: double.infinity, height: 500,
                                color: Colors.blue,
                              ),
                              Container(
                                width: double.infinity, height: 500,
                                color: Colors.grey,
                              )
                            ],
                          ),
                        ),
                        Center(child: Text("Content for Feature 3")),
                        Center(child: Text("Content for Feature 4")),
                      ],
                    ),
                  )
                ],
              ),


              //           // // List các mục trong lịch trình
              //           // Container(
              //           //   color: Colors.white,
              //           //   child: ListView(
              //           //     shrinkWrap: true,
              //           //     children: [
              //           //       ListTile(
              //           //         leading: Icon(Icons.home),
              //           //         title: Text("Nhà"),
              //           //         subtitle: Text("Hà Nội, Bách Khoa, ...\nRời đi lúc 9:00"),
              //           //       ),
              //           //       ListTile(
              //           //         leading: Icon(Icons.directions_bike),
              //           //         title: Text("Lái xe máy"),
              //           //         subtitle: Text("2km - 10 phút\n9:00 - 9:10"),
              //           //       ),
              //           //       // Các mục tiếp theo...
              //           //     ],
              //           //   ),
              //           // ),

            ),

            Positioned(
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
            ),

            if(!isMapLoad)
              Container(
                // width: double.infinity,
                // height: double.infinity,
                color: Colors.white,
                child: Center(child: Text('Loading')),
              ),
          ],
        ),
      ),
    );
  }
}


