import 'package:flutter/material.dart';
import 'package:mapsnap_fe/Widget/ExpandableListTile.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mapsnap_fe/Model/Journey.dart';
import 'package:mapsnap_fe/Model/Visit.dart';
import 'package:mapsnap_fe/Model/Location.dart';
import 'package:mapsnap_fe/Model/Position.dart';
import 'package:mapsnap_fe/Services/APIService.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import '../Widget/accountModel.dart';
import 'AddVisit.dart';
import 'EditVisit.dart';
import 'Point.dart';

class MapScreen extends StatefulWidget {
  final String journeyID;

  const MapScreen({Key? key, required this.journeyID}) : super(key: key);
  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> with SingleTickerProviderStateMixin{
  final  _apiService = ApiService();

  bool isDataLoad = false;
  bool isMapLoad = false;

  late TabController _tabController;
  late double SlideTabTop = 700;
  int currIndex = 0;
  Color tabColor = Colors.green;

  List<Point> points = [];

  List<Point> visits = [];


  late GoogleMapController _controller;
  List<Marker> _markers = [];
  List<Marker> _visitMarkers = [];
  List<Marker> _pathMarkers = [];
  List<Marker> _periodMarkers = [];

  double _zoomLevel = 14.0;
  List<Polyline> _polylines = [];
  List<Polyline> _visitPolylines = [];
  List<Polyline> _pathPolylines = [];
  List<Polyline> _periodPolylines = [];

  TimeOfDay? startTime;
  TimeOfDay? endTime;


  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    // Lắng nghe sự kiện thay đổi tab
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {
          currIndex = 0;

          switch (_tabController.index) {
            case 0:
              _markers = _visitMarkers;
              _polylines = _visitPolylines;
              tabColor = Colors.green;
              break;
            case 1:
              _markers = _pathMarkers;
              _polylines = _pathPolylines;
              tabColor = Colors.blue;
              break;
            case 2:
              _markers = _periodMarkers;
              _polylines = _periodPolylines;
              tabColor = Colors.orange;
              break;
            default:
          }
        });;
      }
    });
    loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void loadData() async{
    final response = await _apiService.GetJourney(widget.journeyID);
    final data = response["data"]["result"];

    int id = 0;
    Visit? preVisit = null;
    for (var visitId in data['visitIds']) {
      final visit_response = await _apiService.GetVisit(visitId);
      Visit visit = Visit.fromJson(visit_response["data"]["result"]);

      final location_response = await _apiService.GetLocation(visit.locationId);
      Location location = Location.fromJson(location_response["data"]["result"]);

      if(preVisit != null){
        var accountModel = Provider.of<AccountModel>(context, listen: false);

        final l_response = await _apiService.GetPositionPeriod(accountModel.idUser, preVisit.endedAt, visit.startedAt);
        final l_data = l_response["data"]["result"];
        for(var positionData in l_data){
          Position position = Position.fromJson(positionData);

          final l_location_response = await _apiService.GetLocation(position.locationId);
          Location l_location = Location.fromJson(l_location_response["data"]["result"]);

          Point l_point = new Point(id: id, type: 'position', longitude: (position.longitude).toDouble(), latitude: (position.latitude).toDouble(), location: l_location);
          id++;
          points.add(l_point);
        }
      }

      Point point = new Point(id: id, type: 'visit', longitude: (location.longitude).toDouble(), latitude: (location.latitude).toDouble(), visit: visit, location: location);
      id++;

      points.add(point);
      visits.add(point);

      preVisit = visit;
    }

    addMarkersWithRotation(points);

    addPolyline(points);

    setState(() {
      _markers = _visitMarkers;
      _polylines = _visitPolylines;
      isDataLoad = true;
    });

  }

  void onTap(int index) {
    setState(() {
      if(currIndex == index){
        currIndex = -1;
        _fitBounds();
      }
      else{
        currIndex = index;
        _deleteMarker('current_marker');
        late Point currPos;
        switch (_tabController.index) {
          case 0:
            currPos = visits[currIndex];
            break;
          case 1:
            currPos = points[currIndex];
            break;
          case 2:
            currPos = points[currIndex];
            break;
          default:
        }

        _controller.showMarkerInfoWindow(MarkerId(currPos.getName()));
        CameraUpdate cameraUpdate = CameraUpdate.newLatLngZoom(LatLng(currPos.latitude,
            currPos.longitude), 17);
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

  void addMarkersWithRotation(List<Point> points) async {
    final BitmapDescriptor visitTab1 = await BitmapDescriptor.asset(
      const ImageConfiguration(size: Size(20, 20)),
      'assets/Common/visitTab1.png', // Đường dẫn tới icon của bạn
    );

    final BitmapDescriptor positionTab1 = await BitmapDescriptor.asset(
      const ImageConfiguration(size: Size(15, 15)),
      'assets/Common/positionTab1.png', // Đường dẫn tới icon của bạn
    );

    final BitmapDescriptor visitTab2 = await BitmapDescriptor.asset(
      const ImageConfiguration(size: Size(15, 15)),
      'assets/Common/visitTab2.png', // Đường dẫn tới icon của bạn
    );

    final BitmapDescriptor positionTab2 = await BitmapDescriptor.asset(
      const ImageConfiguration(size: Size(20, 20)),
      'assets/Common/positionTab2.png', // Đường dẫn tới icon của bạn
    );

    final BitmapDescriptor visitTab3 = await BitmapDescriptor.asset(
      const ImageConfiguration(size: Size(30, 30)),
      'assets/Common/visitTab3.png', // Đường dẫn tới icon của bạn
    );

    final BitmapDescriptor positionTab3 = await BitmapDescriptor.asset(
      const ImageConfiguration(size: Size(15, 15)),
      'assets/Common/positionTab3.png', // Đường dẫn tới icon của bạn
    );

    for (int i = 0; i < points.length - 1; i++) {
      final LatLng start = LatLng(points[i].latitude, points[i].longitude);
      final LatLng next = LatLng(points[i + 1].latitude, points[i + 1].longitude);
      final double rotation = calculateBearing(start, next); // Tính góc giữa 2 điểm

      final markerTab1 = Marker(
        markerId: MarkerId(points[i].id.toString()),
        position: start,
        icon: points[i].type == 'visit' ? visitTab1 : positionTab1,
        anchor: Offset(0.5, 0.5), // Center của icon trùng tọa độ
        rotation: rotation, // Góc xoay
        infoWindow: InfoWindow(title: points[i].getName()),
      );

      final markerTab2 = Marker(
        markerId: MarkerId(points[i].id.toString()),
        position: start,
        icon: points[i].type == 'visit' ? visitTab2 : positionTab2,
        anchor: Offset(0.5, 0.5), // Center của icon trùng tọa độ
        rotation: rotation, // Góc xoay
        infoWindow: InfoWindow(title: points[i].getName()),
      );

      final markerTab3 = Marker(
        markerId: MarkerId(points[i].id.toString()),
        position: start,
        icon: points[i].type == 'visit' ? visitTab3 : positionTab3,
        anchor: Offset(0.5, 0.5), // Center của icon trùng tọa độ
        rotation: rotation, // Góc xoay
        infoWindow: InfoWindow(title: points[i].getName()),
      );

      _visitMarkers.add(markerTab1);
      _pathMarkers.add(markerTab2);
      _periodMarkers.add(markerTab3);
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

  void addPolyline(List<Point> points){
    List<LatLng> _points = [];
    for (int i = 0; i < points.length; i++) {
      _points.add(LatLng(points[i].latitude, points[i].longitude));
    }
    _visitPolylines.add(Polyline(
      polylineId: PolylineId('route'),
      points: _points,
      color: Colors.greenAccent,
      width: 2,
    ),);

    _pathPolylines.add(Polyline(
      polylineId: PolylineId('route'),
      points: _points,
      color: Colors.lightBlue,
      width: 7,
    ),);

    for (int i = 0; i < _points.length - 1; i++) {
      _periodPolylines.add(Polyline(
        polylineId: PolylineId(points[i].id.toString()),
        points: [_points[i], _points[i + 1]],
        color: Colors.yellow,
        width: 5,
      ));
    }
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
        target: LatLng(points[0].latitude, points[0].longitude),
        zoom: _zoomLevel,
      ),
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
      zoomControlsEnabled: false, // Tắt nút phóng to/thu nhỏ mặc định
      markers: _markers.toSet(),
      polylines: _polylines.toSet(),


    );
  }

  Future<void> _selectTime(BuildContext context, bool isStart) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          startTime = picked;
        } else {
          endTime = picked;
        }
      });
    }
  }

  int timeOfDayToEpoch(TimeOfDay timeOfDay, {DateTime? baseDate}) {
    // Sử dụng ngày hiện tại nếu không truyền `baseDate`
    final DateTime now = baseDate ?? DateTime.now();

    // Tạo một đối tượng DateTime từ TimeOfDay
    final DateTime dateTime = DateTime(
      now.year,
      now.month,
      now.day,
      timeOfDay.hour,
      timeOfDay.minute,
    );

    // Trả về số mili giây từ epoch
    return dateTime.millisecondsSinceEpoch;
  }

  void updatePolyline(int startId, int endId) {
    for (int i = 0; i < _periodPolylines .length; i++) {
      final polyline = _periodPolylines [i];
      final int id = int.tryParse(polyline.polylineId.value)!; // Chuyển id sang số (nếu cần)

      // Kiểm tra nếu id nằm trong khoảng
      if (id >= startId && id < endId) {
        // Tạo một polyline mới với màu được thay đổi
        _periodPolylines [i] = polyline.copyWith(colorParam: Colors.red);
      }
      else
        _periodPolylines [i] = polyline.copyWith(colorParam: Colors.yellow);
    }
    setState(() {
      _polylines = _periodPolylines;
    });
  }

  void findPeriod(){
    //thiếu hàm xử lý chuẩn thời gian
    //need fix
    int startId = -1; int endId = -1;
    int start = timeOfDayToEpoch(startTime!) - 430680000; //fix
    int end = timeOfDayToEpoch(endTime!) - 430680000;

    for (var point in points) {
      if (point.getStart() >= start){
        startId = point.id;
        break;
      }
    }

    for (int i = points.length - 1; i >= 0; i--) {
      if (points[i].getEnd() <= end){
        endId = points[i].id;
        break;
      }
    }

    if(startId < endId && startId != -1 && endId != -1){
      updatePolyline(startId, endId);
    }
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
              onPressed: (){
                Navigator.pop(context);
              },
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
  
  Positioned AddVisit(){
    return Positioned(
        top: SlideTabTop - 50,
        left: 10,
        child: ElevatedButton.icon(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddVisitScreen(journeyID: widget.journeyID,)),
            );
          },
          icon: Icon(Icons.add),
          label: Text(
            "Add visit",
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.bold
              ),
            ),
          style: ElevatedButton.styleFrom(
            // padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            backgroundColor: Colors.white,
            shadowColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        )
      );
    }

    void editVisit(int index){
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => EditvisitScreen(journeyID: widget.journeyID)),
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
                  labelColor: tabColor,
                  unselectedLabelColor: Colors.black,
                  indicatorColor: tabColor,
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
                    itemCount: visits.length,
                    itemBuilder: (context, index){
                      return ExpandableListTile(
                        type: 'Tab1Visit',
                        index: index,
                        isFocus: currIndex == index,
                        title: visits[index].getName(),
                        subtitle: "Subtitle",
                        content: "Content",
                        onTapFunc: onTap,
                        editFunc: editVisit,
                      );
                    },
                  ),
                ),
                Container(
                  color: Colors.white,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: points.length,
                    itemBuilder: (context, index){
                      return ExpandableListTile(
                        type: points[index].type == 'visit' ? 'Tab2Visit' : 'Tab2Position',
                        index: index,
                        isFocus: currIndex == index,
                        title: points[index].getName(),
                        subtitle: "Subtitle",
                        content: "Content",
                        onTapFunc: onTap,
                        editFunc: editVisit,
                      );
                    },
                  ),
                ),
                SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        height: 148, width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () => _selectTime(context, true),
                                      child: Container(
                                        color: Colors.white,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start, // Căn giữa theo chiều ngang
                                          children: [
                                            Icon(Icons.access_time_outlined, size: 45, color: Colors.grey[500],),
                                            SizedBox(width: 10,),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text('From time'),
                                                Text(
                                                  startTime != null ? startTime!.format(context) : '..:..',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.bold
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 20),
                                    child: Container(width: 2, height: 40, color: Colors.grey[300],),
                                  ),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () => _selectTime(context, false),
                                      child: Container(
                                        color: Colors.white,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center, // Căn giữa theo chiều ngang
                                          children: [
                                            Icon(Icons.access_time_outlined, size: 45, color: Colors.grey[500],),
                                            SizedBox(width: 10,),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text('To time'),
                                                Text(
                                                endTime != null ? endTime!.format(context) : '..:..',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.bold
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Container(width: double.infinity, height: 2, color: Colors.grey[300],),
                              Expanded(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    GestureDetector(
                                        onTap: (){},
                                        child: Row(
                                          children: [
                                            Icon(Icons.filter_list, size: 35, color: Colors.grey[500],),
                                            SizedBox(width: 10,),
                                            Text('Filter',
                                              style: TextStyle(fontSize: 17, color: Colors.black, fontWeight: FontWeight.bold),),
                                          ],
                                        )
                                    ),
                                    ElevatedButton(
                                      onPressed: () => findPeriod(),
                                      child: Text('Apply', style: TextStyle(color: Colors.black),),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.orange, // Màu nền
                                        side: BorderSide(color: Colors.white, width: 2), // Viền màu trắng
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                      ),

                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        height: 2, width: double.infinity,
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
                      Container(
                        // padding: const EdgeInsets.only(top: 150.0),
                        height: max(0, MediaQuery.of(context).size.height - SlideTabTop - 150),
                        color: Colors.white,
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: points.length,
                          itemBuilder: (context, index){
                            return ExpandableListTile(
                              type: points[index].type == 'visit' ? 'Tab3Visit' : 'Tab3Position',
                              index: index,
                              isFocus: currIndex == index,
                              title: points[index].getName(),
                              subtitle: "Subtitle",
                              content: "Content",
                              onTapFunc: onTap,
                              editFunc: editVisit,
                            );
                          },
                        ),
                      ),

                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Positioned ZoomInOut(){
    return Positioned(
      top: 100, // Di chuyển lên trên
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

          AddVisit(),

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


