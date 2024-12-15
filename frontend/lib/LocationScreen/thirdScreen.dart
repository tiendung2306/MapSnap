import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mapsnap_fe/Manager/CURD_city.dart';
import 'package:mapsnap_fe/Manager/CURD_location.dart';
import 'package:mapsnap_fe/Model/City.dart';
import 'package:mapsnap_fe/Model/Location.dart';
import 'package:mapsnap_fe/Widget/accountModel.dart';
import 'package:provider/provider.dart';


class thirdScreen extends StatefulWidget {

  const thirdScreen({Key? key}) : super(key: key);

  @override
  State<thirdScreen> createState() => _thirdScreenState();
}

class _thirdScreenState  extends State<thirdScreen>{

  int k = 1;

  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchLocationByUserId();
    });
  }

  Color getRankColor(int rank) {
    if (rank == 0) {
      return Color(0xFFFFD700); // Vàng
    } else if (rank == 1) {
      return Color(0xFFC0C0C0); // Bạc
    } else if (rank == 2) {
      return Color(0xFFCD7F32); // Đồng
    } else {
      return Color(0xFFB0E0E6); // Màu cơ bản
    }
  }



  Future<void> fetchLocationByUserId() async {
    var accountModel = Provider.of<AccountModel>(context, listen: false);
    // Kiểm tra xem đã tải ảnh chưa
    accountModel.resetLocation3();
    List<Location> locations = await getInfoLocation(accountModel.idUser,"visitedTime","sortField");
    if (locations.isNotEmpty) {
      for (var location in locations) {
        accountModel.addLocation3(location);
      }
    } else {
      print('Không có thành phố nào được tìm thấy.');
    }
  }

  @override

  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () {
        // Bỏ chọn tất cả các TextField khi bấm ra ngoài
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Consumer<AccountModel>(
          builder: (context, accountModel, child) {
            return Container(
              color: Colors.white,
              child: SingleChildScrollView(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      for(int i = 0; i < accountModel.locationManager3.length; i++) ...[
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: getRankColor(i),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black.withOpacity(0.3),
                                    spreadRadius: 3,
                                    blurRadius: 6,
                                    offset: Offset(5, 5)
                                )
                              ]
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                accountModel.locationManager3[i].title,
                                style: TextStyle(
                                    fontSize: 35,
                                    fontWeight: FontWeight.bold),
                              ),
                              Row(
                                children: [
                                  Text(
                                    'Số lần đến: ',
                                    style: TextStyle(
                                        fontSize: 25,
                                        ),
                                  ),
                                  Text(
                                    accountModel.locationManager3[i].visitedTime.toString(),
                                    style: TextStyle(
                                        fontSize: 25,
                                        ),
                                  ),
                                ],
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded( // Để tự động xuống dòng nếu chữ dài
                                    child: Text(
                                      'Địa chỉ: ${accountModel.locationManager3[i].address}' ,
                                      style: TextStyle(
                                        fontSize: 25,
                                      ),
                                      maxLines: 2, // Giới hạn 2 dòng
                                      overflow: TextOverflow.ellipsis, // Cắt bớt nếu quá dài
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ]
                    ],
                  ),
                ),
            );
          },
        ),
      ),
    );
  }
}

