import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../Services/APIService.dart';
import '../Widget/accountModel.dart';


class HistoryLog extends StatefulWidget  {
  @override
  State<HistoryLog> createState() => _HistoryLogState();
}

class _HistoryLogState extends State<HistoryLog> with SingleTickerProviderStateMixin{
  bool isDataLoad = false;
  late TabController _tabController;
  final  _apiService = ApiService();
  late List<dynamic> data;

  void loadData() async {
    var accountModel = Provider.of<AccountModel>(context, listen: false);
    final response = await _apiService.GetAllHistoryLogs(accountModel.idUser);
    data = response["data"]["result"];
    setState(() {
      isDataLoad = true;
    });
  }

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


  @override
  Widget build(BuildContext context) {
    return isDataLoad ? Scaffold(
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
                            onPressed: (){
                              Navigator.pop(context);
                            },
                            icon: Icon(Icons.arrow_back),
                          ),
                          Text(
                            'History Log',
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
                        Tab(text: "Today"),
                        Tab(text: "Last week"),
                        Tab(text: "Last month"),
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
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        return _HistoryItem(data[index]);
                      },
                    ),

                    ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        return _HistoryItem(data[index]);
                      },
                    ),

                    ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        return _HistoryItem(data[index]);
                      },
                    ),

                  ],
                ),
              ),

            ],
          ),
        ),
      ),
    ) : LoadingScreen();
  }

}

class _HistoryItem extends StatefulWidget {
  final Map<String, dynamic> historyLog;

  _HistoryItem(this.historyLog);

  @override
  __HistoryItemState createState() => __HistoryItemState();
}

class __HistoryItemState extends State<_HistoryItem> with AutomaticKeepAliveClientMixin {

  String epochToString(int epoch){
    // Chuyển epoch sang DateTime
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(epoch);

    // Định dạng DateTime thành ngày tháng năm
    return DateFormat('dd/MM/yyyy HH:mm').format(dateTime);
  }

  late Color color;

  @override
  void initState() {
    Random random = Random(); // need fix
    int randomNumber = random.nextInt(100);
    if(randomNumber % 3 == 0)
      widget.historyLog['activityType'] = "Update";
    if(randomNumber % 3 == 1)
      widget.historyLog['activityType'] = "Create";
    if(randomNumber % 3 == 2)
      widget.historyLog['activityType'] = "Delete";

    if(widget.historyLog['activityType'] == "Update")
      color = Colors.lightBlueAccent;
    if(widget.historyLog['activityType'] == "Create")
      color = Colors.greenAccent;
    if(widget.historyLog['activityType'] == "Delete")
      color = Colors.redAccent;
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
            epochToString(widget.historyLog['createdAt']),
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Stack(
            children: [
              Container(
                height: 100,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: color,
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
                bottom: 10, left: 10, top: 10,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.historyLog["activityType"],
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    Text(
                      widget.historyLog["modelImpact"],
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20
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
