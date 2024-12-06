import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ButtonPage extends StatelessWidget {
  Future<void> createJourneys() async {
    final String apiUrl = 'http://10.0.2.2:3000/v1/journey/672b2c4241382c06b026f861/create-journey';

    // Danh sách các hành trình
    final List<Map<String, dynamic>> journeys = [
      {
        "title": "Tham quan Bảo tàng Lịch sử Việt Nam",
        "startedAt": 1731090000000,
        "endedAt": 1731093600000,
        "updatedAt": 1731072409000,
        "status": "enabled",
        "updatedByUser": true,
        "isAutomaticAdded": true
      },
      {
        "title": "Khám phá Chợ Đồng Xuân",
        "startedAt": 1731100000000,
        "endedAt": 1731103600000,
        "updatedAt": 1731072409000,
        "status": "enabled",
        "updatedByUser": true,
        "isAutomaticAdded": true
      },
      {
        "title": "Hành trình Hồ Tây vào buổi chiều",
        "startedAt": 1731110000000,
        "endedAt": 1731117200000,
        "updatedAt": 1731072409000,
        "status": "enabled",
        "updatedByUser": true,
        "isAutomaticAdded": true
      },
      {
        "title": "Chuyến xe qua cầu Long Biên",
        "startedAt": 1731120000000,
        "endedAt": 1731123600000,
        "updatedAt": 1731072409000,
        "status": "enabled",
        "updatedByUser": true,
        "isAutomaticAdded": true
      },
      {
        "title": "Tham quan Văn Miếu - Quốc Tử Giám",
        "startedAt": 1731130000000,
        "endedAt": 1731133600000,
        "updatedAt": 1731072409000,
        "status": "enabled",
        "updatedByUser": true,
        "isAutomaticAdded": true
      },
      {
        "title": "Trải nghiệm chợ đêm Hà Nội",
        "startedAt": 1731140000000,
        "endedAt": 1731147200000,
        "updatedAt": 1731072409000,
        "status": "enabled",
        "updatedByUser": true,
        "isAutomaticAdded": true
      },
      {
        "title": "Tham quan đền Quán Thánh",
        "startedAt": 1731150000000,
        "endedAt": 1731153600000,
        "updatedAt": 1731072409000,
        "status": "enabled",
        "updatedByUser": true,
        "isAutomaticAdded": true
      },
      {
        "title": "Khám phá làng gốm Bát Tràng",
        "startedAt": 1731160000000,
        "endedAt": 1731167200000,
        "updatedAt": 1731072409000,
        "status": "enabled",
        "updatedByUser": true,
        "isAutomaticAdded": true
      }
      // Thêm các hành trình khác tương tự...
    ];

    for (var journey in journeys) {
      try {
        final response = await http.post(
          Uri.parse(apiUrl),
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode(journey),
        );

        if (response.statusCode == 200) {
          print('Tạo hành trình "${journey['title']}" thành công!');
        } else {
          print('Lỗi khi tạo hành trình "${journey['title']}": ${response.body}');
        }
      } catch (e) {
        print('Lỗi khi kết nối API: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nút ở giữa màn hình'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            createJourneys();
          },
          child: Text('Bấm vào tôi'),
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
            textStyle: TextStyle(fontSize: 18.0),
          ),
        ),
      ),
    );
  }
}
