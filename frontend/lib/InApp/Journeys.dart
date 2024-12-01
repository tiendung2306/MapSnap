import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class Journeys extends StatefulWidget  {
  @override
  State<Journeys> createState() => _JourneysState();
}

class _JourneysState extends State<Journeys> with SingleTickerProviderStateMixin{
  late double SlideTabTop = 700;
  late TabController _tabController;

  final List<Map<String, dynamic>> created_journeys = [
    {
      "date": "1th, Sep, 2024",
      "location": "Birmingham",
    },
    {
      "date": "2nd, Sep, 2024",
      "location": "Fountain Heights",
    },
    {
      "date": "3th, Sep, 2024",
      "location": "Birmingham",
    },
  ];

  final List<Map<String, dynamic>> byday_journeys = [
    {
      "date": "1th, Sep, 2024",
      "location": "Birmingham",
    },
    {
      "date": "2nd, Sep, 2024",
      "location": "Fountain Heights",
    },
    {
      "date": "3th, Sep, 2024",
      "location": "Birmingham",
    },
  ];

  final List<Map<String, dynamic>> other_journeys = [
    {
      "date": "1th, Sep, 2024",
      "location": "Birmingham",
    },
    {
      "date": "2nd, Sep, 2024",
      "location": "Fountain Heights",
    },
    {
      "date": "3th, Sep, 2024",
      "location": "Birmingham",
    },
  ];


  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
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
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/Login/Background.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.only(top: 50),
          child: Column(
            children: [
              // Các feature
              Container(
                width: double.infinity,
                color: Colors.white,
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      height: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          IconButton(
                              onPressed: (){},
                              icon: Icon(Icons.arrow_back),
                          ),
                          Text(
                            'Saved Journeys',
                            style: TextStyle(
                              fontSize: 20
                            ),
                          ),
                          IconButton(
                              onPressed: (){} ,
                              icon: Icon(Icons.account_circle),
                          )
                        ],
                      ),
                    ),
                    TabBar(
                      controller: _tabController,
                      labelColor: Colors.blue,
                      unselectedLabelColor: Colors.black,
                      indicatorColor: Colors.blue,
                      tabs: [
                        Tab(text: "Created"),
                        Tab(text: "By day"),
                        Tab(text: "Others"),
                      ],
                    ),
                  ],
                ),
              ),
              // Hiệu ứng đổ bóng
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
                    ListView.builder(
                      itemCount: created_journeys.length,
                      itemBuilder: (context, index) {
                        final journey = created_journeys[index];
                        return _JourneyItem(journey);
                      },
                    ),

                    ListView.builder(
                      itemCount: byday_journeys.length,
                      itemBuilder: (context, index) {
                        final journey = byday_journeys[index];
                        return _JourneyItem(journey);
                      },
                    ),

                    ListView.builder(
                      itemCount: other_journeys.length,
                      itemBuilder: (context, index) {
                        final journey = other_journeys[index];
                        return _JourneyItem(journey);
                      },
                    ),

                  ],
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }




  Widget _buildJourneyItem(Map<String, dynamic> journey) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            journey['date'],
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Stack(
            children: [
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey.shade300,
                ),

              child: GoogleMap(
                // onMapCreated: _onMapCreated,
                initialCameraPosition: CameraPosition(
                  target: LatLng(21.0285, 105.8542),
                  zoom: 15,
                ),
                myLocationEnabled: true,
                myLocationButtonEnabled: false,
                zoomControlsEnabled: false, // Tắt nút phóng to/thu nhỏ mặc định
                // markers: _markers.toSet(),
                // polylines: _polylines,
                ),
              ),
              Positioned(
                top: 70, bottom: 0, left: 0, right: 0,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,  // Bắt đầu gradient từ trên
                      end: Alignment.bottomCenter, // Kết thúc gradient ở dưới
                      colors: [
                        Colors.black.withOpacity(0.0), // Màu ở trên cùng, với độ mờ
                        Colors.black.withOpacity(0.6), // Màu ở dưới cùng, nhạt hơn
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 10, left: 10,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Title',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    Text(
                      'Description',
                      style: TextStyle(
                          color: Colors.white,
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }


}

class _JourneyItem extends StatefulWidget {
  final Map<String, dynamic> journey;

  _JourneyItem(this.journey);

  @override
  __JourneyItemState createState() => __JourneyItemState();
}

class __JourneyItemState extends State<_JourneyItem> with AutomaticKeepAliveClientMixin {
  late Map<String, dynamic> journey;

  @override
  void initState() {
    journey = widget.journey;
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    super.build(context); // Required to enable state preservation
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            journey['date'],
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Stack(
            children: [
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey.shade300,
                ),

                child: GoogleMap(
                  // onMapCreated: _onMapCreated,
                  initialCameraPosition: CameraPosition(
                    target: LatLng(21.0285, 105.8542),
                    zoom: 15,
                  ),
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                  zoomControlsEnabled: false, // Tắt nút phóng to/thu nhỏ mặc định
                  // markers: _markers.toSet(),
                  // polylines: _polylines,
                ),
              ),
              Positioned(
                top: 70, bottom: 0, left: 0, right: 0,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,  // Bắt đầu gradient từ trên
                      end: Alignment.bottomCenter, // Kết thúc gradient ở dưới
                      colors: [
                        Colors.black.withOpacity(0.0), // Màu ở trên cùng, với độ mờ
                        Colors.black.withOpacity(0.6), // Màu ở dưới cùng, nhạt hơn
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 10, left: 10,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Title',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    Text(
                      'Description',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
