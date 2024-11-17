import 'package:flutter/material.dart';
import 'package:mapsnap_fe/InApp/TodayModel.dart';
import 'package:mapsnap_fe/Widget/ExpandableListTile.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> with SingleTickerProviderStateMixin{
  late TabController _tabController;
  late double SlideTabTop = 400;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.red,
        child: Stack(

          children: [
            // Container(
            //   width: double.infinity,
            //   height: double.infinity,
            //   decoration: BoxDecoration(
            //     image: DecorationImage(
            //       image: AssetImage("assets/Image/Map.png"),
            //       fit: BoxFit.cover,
            //     ),
            //   ),
            // ),
            // Google Maps làm nền
            GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(33.5207, -86.8025), // Tọa độ của Birmingham
                zoom: 12,
              ),
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
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
                            itemCount: contents.length,
                            itemBuilder: (context, index){
                              return ExpandableListTile(
                                  title: contents[index].title,
                                  subtitle: contents[index].subtitle,
                                  content: contents[index].content
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
          ],
        ),
      ),
    );
  }
}


