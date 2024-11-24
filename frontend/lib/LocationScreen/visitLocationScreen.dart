import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mapsnap_fe/Manager/CURD_location.dart';
import 'package:mapsnap_fe/Model/Location.dart';
import 'package:mapsnap_fe/Widget/accountModel.dart';
import 'package:provider/provider.dart';



class visitLocationScreen extends StatefulWidget {
  late String city;

  visitLocationScreen({
    required this.city,
    Key? key
  }) : super(key: key);

  @override
  State<visitLocationScreen> createState() {
    return _visitLocationScreenState();
  }
}

class _visitLocationScreenState  extends State<visitLocationScreen>{

  int k = 1;

  void initState() {
    fetchLocationByUserId();
    super.initState();
  }

  Future<void> fetchLocationByUserId() async {
    var accountModel = Provider.of<AccountModel>(context, listen: false);
    // Kiểm tra xem đã tải ảnh chưa
    accountModel.resetLocation();
    List<Location> locations = await getInfoLocation(accountModel.idUser);
    if (locations.isNotEmpty) {
      for (var location in locations) {
        accountModel.addLocation2(location);
      }
    } else {
      print('Không có thành phố nào được tìm thấy.');
    }
  }

  @override
  Widget build(BuildContext context) {

    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;


    return Scaffold(
        body: Consumer<AccountModel>(
            builder: (context, accountModel, child) {
              return Stack(
                children: [
                  Image.asset(
                    'assets/Image/Background.png',
                    width: screenHeight,
                    height: screenHeight,
                    fit: BoxFit.none,
                  ),
                  SingleChildScrollView(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  width: 50,
                                  height: 50,
                                  child: Icon(Icons.chevron_left, size: 50,),
                                ),
                              ),
                              Text(widget.city, style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
                              Container(
                                width: 50,
                                height: 50,
                              )
                            ],
                          ),
                        ),
                        // Hiển thị các container cho từng ngày
                        for (int i = 0; i < accountModel.LocationManager.length; i++) ...[
                          GestureDetector(
                            onTap: () {
                              print(i);
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Container(
                                // color: Colors.grey,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(accountModel.LocationManager[i].name, style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
                                    Row(
                                      children: [
                                        Text('Số lần đến: ', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
                                        Text(accountModel.LocationManager[i].visitedTime as String, style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
                                      ],
                                    ),
                                    // Row(
                                    //   children: [
                                    //     Text('Lần đến gần nhất: ', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
                                    //     Text(
                                    //       DateFormat('yyyy-MM-dd HH:mm:ss').format(
                                    //         DateTime.fromMillisecondsSinceEpoch(accountModel.LocationManager[i].createdAt),
                                    //       ),
                                    //       style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                                    //     ),
                                    //   ],
                                    // )

                                  ],
                                ),
                              )
                            ),
                          ),
                        ],
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            k++;
                            accountModel.addLocation(
                              widget.city,
                              {
                                'Tên': 'THPT xx${k}',
                                'Số lần đến': '${k}',
                                'Lần đến gần nhất': '23-11-2024'
                              },
                            );
                          },
                          child: const Text("Thêm địa điểm"),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }
        )
    );
  }
}
