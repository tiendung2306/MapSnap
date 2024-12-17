import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mapsnap_fe/InApp/Map.dart';
import 'package:mapsnap_fe/Widget/NonExpandListTile.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mapsnap_fe/Model/Journey.dart';
import 'package:mapsnap_fe/Model/Visit.dart';
import 'package:mapsnap_fe/Model/Location.dart';
import 'package:mapsnap_fe/Services/APIService.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import '../Model/Position.dart';
import '../Widget/accountModel.dart';
import 'Point.dart';

class AddJourneyScreen extends StatefulWidget {

  const AddJourneyScreen({Key? key}) : super(key: key);
  @override
  State<AddJourneyScreen> createState() => _AddJourneyScreenState();
}

class _AddJourneyScreenState extends State<AddJourneyScreen> with SingleTickerProviderStateMixin {
  final  _apiService = ApiService();

  bool isDataLoad = false;
  bool isMapLoad = false;

  late TabController _tabController;
  late double SlideTabTop = 650;
  Color tabColor = Colors.green;

  final ScrollController _scrollController = ScrollController();
  int currIndex = 0;

  late Journey journey;

  List<Point> points = [];

  List<Point> visits = [];

  late GoogleMapController _controller;
  List <Marker> _markers = [];
  List<Marker> _startMarkers = [];
  List<Marker> _endMarkers = [];


  double _zoomLevel = 14.0;
  List<Polyline> _polylines = [];
  List<Polyline> _startPolylines = [];
  List<Polyline> _endPolylines = [];

  TimeOfDay? startTime = null;
  TimeOfDay? endTime = null;

  DateTime? startDay = null;
  DateTime? endDay = null;


  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    // Lắng nghe sự kiện thay đổi tab
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {
          currIndex = 0;

          switch (_tabController.index) {
            case 0:
              _markers = _startMarkers;
              _polylines = _startPolylines;
              tabColor = Colors.green;
              break;
            case 1:
              _markers = _endMarkers;
              _polylines = _endPolylines;
              tabColor = Colors.blue;
              break;
            default:
          }
        });;
      }
    });
    loadData("67535832f142e638dca818eb", "start");
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void loadData(String journeyId, String loadInto) async{
    final response = await _apiService.GetJourney(journeyId);
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

    addMarkersWithRotation(points, loadInto);

    addPolyline(points, loadInto);

    setState(() {
      isDataLoad = true;
    });

  }

  void save() {
    for (int i = 0; i < points.length - 1; i++) {
      if(points[i].og_type != points[i].type){
        var accountModel = Provider.of<AccountModel>(context, listen: false);
        if(points[i].og_type == 'position'){
          _apiService.CreateVisit(accountModel.idUser, points[i].getStart(), points[i].getEnd());
        }

        else
          _apiService.DeleteVisit(points[i].visit!.id);
      }
    }
  }

  void addOrDelete(int index, bool ischeck) async {
    if(points[index].type == 'visit'){
      final BitmapDescriptor positionTab3 = await BitmapDescriptor.asset(
        const ImageConfiguration(size: Size(15, 15)),
        'assets/Common/positionTab3.png', // Đường dẫn tới icon của bạn
      );
      setState(() {
        points[index].type = 'position';
        _markers[index] = _markers[index].copyWith(iconParam: positionTab3);
      });
      showAlertDialog(context, "Xóa điểm thăm thành công", " ");
    }

    else{
      bool isAccept = true;
      if(ischeck){
        //api need
      }
      if(isAccept){
        final BitmapDescriptor visitTab3 = await BitmapDescriptor.asset(
          const ImageConfiguration(size: Size(30, 30)),
          'assets/Common/visitTab3.png', // Đường dẫn tới icon của bạn
        );
        setState(() {
          points[index].type = 'visit';
          _markers[index] = _markers[index].copyWith(iconParam: visitTab3);
        });
        showAlertDialog(context, "Thêm điểm thăm thành công", " ");
      }
      else
        showAlertDialog(context, "Thêm điểm thăm thất bại", "Điểm thăm quá xa lộ trình");
    }

  }

  void onTap(int index) {
    setState(() {
      if(currIndex == index){
        currIndex = -1;
        _fitBounds();
      }
      else{
        currIndex = index;
        _controller.showMarkerInfoWindow(MarkerId(index.toString()));

        CameraUpdate cameraUpdate = CameraUpdate.newLatLngZoom(LatLng(points[index].latitude,
            points[index].longitude), 17);
        _controller.animateCamera(cameraUpdate);
      }
    });
  }

  void showAlertDialog(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Đóng hộp thoại
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }


  void onMapTap(LatLng pos){
    void create(){
      addOrDelete(1, true);
    }

    setState(() {
      _markers.add(Marker(
        markerId: MarkerId('select'),
        position: pos,
        infoWindow: InfoWindow(
            title: 'New Marker',
            snippet: 'Tap add visit',
            onTap: create
        ),
      ));
      _controller.showMarkerInfoWindow(MarkerId('select'));
      CameraUpdate cameraUpdate = CameraUpdate.newLatLngZoom(pos, 17);
      _controller.animateCamera(cameraUpdate);

      List <LatLng> l_points = [];
      l_points.add(pos);
      l_points.add(LatLng(points[1].latitude, points[1].longitude)); //need fix

      _polylines.add(Polyline(
        polylineId: PolylineId('newVisit'),
        points: l_points,
        color: Colors.orange,
        width: 5,
      ),);
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

  void _scrollToIndex(int index) {
    final double position = index * 70.0;
    _scrollController.animateTo(
      position,
      duration: Duration(seconds: 1),
      curve: Curves.easeInOut,
    );
  }

  void onMarkerTap(int index){
    _scrollToIndex(index);
  }

  void addMarkersWithRotation(List<Point> points, String loadInto) async {
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


      final markerTab3 = Marker(
          markerId: MarkerId(points[i].id.toString()),
          position: start,
          icon: points[i].type == 'visit' ? visitTab3 : positionTab3,
          anchor: Offset(0.5, 0.5), // Center của icon trùng tọa độ
          rotation: rotation, // Góc xoay
          infoWindow: InfoWindow(title: points[i].getName()),
          onTap: (){
            _scrollToIndex(i);
          }
      );
      if(loadInto == 'start')
        _startMarkers.add(markerTab3);
      else
        _endMarkers.add(markerTab3);
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

  void addPolyline(List<Point> points, String loadInto){
    List<LatLng> _points = [];
    for (int i = 0; i < points.length; i++) {
      _points.add(LatLng(points[i].latitude, points[i].longitude));
    }
    if(loadInto == 'start')
      _startPolylines.add(Polyline(
        polylineId: PolylineId('route'),
        points: _points,
        color: Colors.yellow,
        width: 5,
      ),);
    else
      _endPolylines.add(Polyline(
        polylineId: PolylineId('route'),
        points: _points,
        color: Colors.yellow,
        width: 5,
      ),);
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

  Future<void> _selectTime(BuildContext context, bool isStart) async {
    // Chọn ngày
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      // Chọn giờ
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        setState(() {

          if (isStart) {
            startTime = pickedTime;
            startDay = pickedDate;
          } else {
            endTime = pickedTime;
            endDay = pickedDate;
          }
        });
      }
    }
  }

  void SaveTime(){
    //thiếu hàm xử lý chuẩn thời gian
    //need fix
    
    loadData("67535832f142e638dca818eb", "start");
    loadData("67535832f142e638dca818eb", "end");
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
      onTap: onMapTap,
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

  Positioned Header(){
    return Positioned(
      top: 50,
      left: 10,
      right: 10,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 5)],
            ),
            child: IconButton(
              onPressed: (){
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 5)],
            ),
            child: Align(
                alignment: Alignment.center,
                child: Text(
                    'Add new journey',
                    style: TextStyle(fontSize: 18)
                )
            ),
          ),
          ElevatedButton.icon(
            onPressed: () {
              save();
            },
            icon: Icon(Icons.check),
            label: Text(
              "Save",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold
              ),
            ),
            style: ElevatedButton.styleFrom(
              // padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              backgroundColor: Colors.greenAccent,
              shadowColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          )
        ],
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
            padding: EdgeInsets.only(top: 10),
            height: 15,
            width: double.infinity,
            color: Colors.white,
            child: Align(
              alignment: Alignment.topCenter,
              child: GestureDetector(
                onPanUpdate: (details){
                  setState(() {
                    if(SlideTabTop + details.delta.dy > 200 && SlideTabTop + details.delta.dy < 660)
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
          //Chọn thời gian
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
                                Icon(Icons.calendar_month_outlined, size: 45, color: Colors.grey[500],),
                                SizedBox(width: 10,),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(startDay == null ? 'From time' : DateFormat('dd/MM/yyyy').format(startDay!)),
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
                                Icon(Icons.calendar_month_outlined, size: 45, color: Colors.grey[500],),
                                SizedBox(width: 10,),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(endDay == null ? 'To time' : DateFormat('dd/MM/yyyy').format(endDay!)),
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
                          onPressed: () {
                            SaveTime();
                          },
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
                    Tab(text: "Start Day"),
                    Tab(text: "End Day"),
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
                Container(
                  color: Colors.white,
                  child: ListView.builder(
                    shrinkWrap: true,
                    controller: _scrollController,
                    itemCount: points.length,
                    itemBuilder: (context, index){
                      return NonExpandListTile(
                        type: points[index].type,
                        index: index,
                        title: points[index].getName(),
                        subtitle: "Subtitle",
                        content: "Content",
                        onTapFunc: onTap,
                        addDelFunc: addOrDelete,
                      );
                    },
                  ),
                ),
                Container(
                  color: Colors.white,
                  child: ListView.builder(
                    shrinkWrap: true,
                    controller: _scrollController,
                    itemCount: points.length,
                    itemBuilder: (context, index){
                      return NonExpandListTile(
                        type: points[index].type,
                        index: index,
                        title: points[index].getName(),
                        subtitle: "Subtitle",
                        content: "Content",
                        onTapFunc: onTap,
                        addDelFunc: addOrDelete,
                      );
                    },
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


