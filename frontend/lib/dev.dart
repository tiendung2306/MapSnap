import 'package:geocoding/geocoding.dart';
import 'package:flutter/material.dart';

import 'Services/AddressServive.dart';

class AddressConverter extends StatefulWidget {
  @override
  _AddressConverterState createState() => _AddressConverterState();
}

class _AddressConverterState extends State<AddressConverter> {
  late List<Placemark> plms;
  // Hàm lấy địa chỉ từ latitude và longitude
  void loaddata() async{
    // Ví dụ về tọa độ, có thể thay đổi với giá trị thực tế
    double latitude = 20.9967872;  // Tọa độ ví dụ cho Hà Nội
    double longitude = 105.8363802;  // Tọa độ ví dụ cho Hà Nội
    plms = await getAddress(latitude, longitude) ?? [];
  }


  @override
  void initState() {
    super.initState();
    loaddata();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chuyển tọa độ thành địa chỉ'),
      ),
      body: Center(
        child: ListView.builder(
            itemCount: plms.length,
            itemBuilder: (context, index){
              return Row(
                children: [
                  Text(plms[index].country ?? 'null'),
                  Text(plms[index].name ?? 'null'),
                  Text(plms[index].street ?? 'null'),
                  Text(plms[index].locality ?? 'null'),
                ],
              );
            }
        ),
      ),
    );
  }
}

