// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:mapsnap_fe/Model/Picture.dart';
// import 'package:mapsnap_fe/Widget/accountModel.dart';
// import 'package:provider/provider.dart';
//
// class ConfirmScreen extends StatelessWidget {
//   final String imagePath;
//
//   const ConfirmScreen({Key? key, required this.imagePath}) : super(key: key);
//
//
//   @override
//   Widget build(BuildContext context) {
//     var screenHeight = MediaQuery.of(context).size.height;
//     var screenWidth = MediaQuery.of(context).size.width;
//
//
//     return Scaffold(
//       body: Column(
//         children: [
//           Expanded(
//             child: Image.file(
//               File(imagePath),
//               fit: BoxFit.cover,
//             ),
//           ),
//           Container(
//             width: screenWidth,
//             height: screenHeight / 5,
//             color: Colors.grey,
//             child: Stack(
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     GestureDetector(
//                       onTap: () {
//                         Navigator.pop(context);  // Quay lại mà không lưu ảnh
//                       },
//                       child: button(Icons.close, Alignment.bottomLeft, (screenHeight / 5) * 1 / 2, screenHeight / 20, screenWidth / 10, Colors.red),
//                     ),
//                     GestureDetector(
//                       onTap: () {
//                         // Cập nhật ảnh vào ImageManager
//                         Provider.of<AccountModel>(context, listen: false).addImageDay(imagePath);
//                         Navigator.pop(context); // Quay lại màn hình trước đó
//                       },
//                       child: button(Icons.check, Alignment.bottomRight, (screenHeight / 5) * 1 / 2, screenHeight / 20, screenWidth / 10, Colors.green),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget button(IconData icon, Alignment alignment, double size, double margin1, double margin2, Color background) {
//     return Align(
//       alignment: alignment,
//       child: Container(
//         margin: EdgeInsets.only(
//           left: margin2,
//           bottom: margin1,
//           top: margin1,
//           right: margin2,
//         ),
//         height: size,
//         width: size,
//         decoration: BoxDecoration(
//           shape: BoxShape.circle,
//           color: background,
//           boxShadow: const [
//             BoxShadow(
//               color: Colors.black26,
//               offset: Offset(2, 2),
//               blurRadius: 10,
//             ),
//           ],
//         ),
//         child: Center(
//           child: Icon(
//             icon,
//             color: Colors.white,
//             size: (size * 2) / 3,
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mapsnap_fe/Manager/CURD_location.dart';
import 'package:mapsnap_fe/Model/Location.dart';
import 'package:mapsnap_fe/Model/Picture.dart';
import 'package:mapsnap_fe/Widget/accountModel.dart';
import 'package:provider/provider.dart';

import '../Manager/CURD_picture.dart';

class ConfirmScreen extends StatefulWidget {
  final String imagePath;

  const ConfirmScreen({Key? key, required this.imagePath}) : super(key: key);

  @override
  State<ConfirmScreen> createState() {
    return _ConfirmScreenState();
  }
}

class _ConfirmScreenState  extends State<ConfirmScreen>{


  List<Location> listLocation = [];


  @override
  void initState() {
    fetchLocation();
    super.initState();
  }


  Future<void> fetchLocation() async {
    var accountModel = Provider.of<AccountModel>(context, listen: false);
    listLocation = await getInfoLocation(accountModel.idUser,"","");
    setState(() {});
  }
  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    var accountModel = Provider.of<AccountModel>(context, listen: false);

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Image.file(
              File(widget.imagePath),
              fit: BoxFit.cover,
            ),
          ),
          Container(
            width: screenWidth,
            height: screenHeight / 5,
            color: Colors.grey,
            child: Stack(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);  // Quay lại mà không lưu ảnh
                      },
                      child: button(Icons.close, Alignment.bottomLeft, (screenHeight / 5) * 1 / 2, screenHeight / 20, screenWidth / 10, Colors.red),
                    ),
                    GestureDetector(
                      onTap: () async {
                        DateTime now = DateTime.now();
                        DateTime vietnamTime = now.toUtc().add(Duration(hours: 7)); // Chuyển sang múi giờ UTC+7
                        String dayString = '${vietnamTime.day}-${vietnamTime.month}-${vietnamTime.year}';
                        Location randomLocationId = listLocation[Random().nextInt(listLocation.length)];
                        print(randomLocationId.address);
                        CreatePicture createPicture = CreatePicture(
                          userId: accountModel.idUser,
                          locationId: randomLocationId.id,
                          visitId: "60c72b2f9af1b8124cf74c9c",
                          journeyId: "60c72b2f9af1b8124cf74c9d",
                          link: widget.imagePath,
                          capturedAt: vietnamTime,
                          isTakenByCamera: true,
                        );

                        // Hiển thị spinner
                        showLoadingDialog(context);
                        try {
                          // Thực hiện upload ảnh
                          List<Picture>? picture = await upLoadImage(createPicture);
                          // Thêm ảnh vào AccountModel nếu thành công
                          Provider.of<AccountModel>(context, listen: false).addImageDay(picture![0], dayString);
                        } catch (e) {
                          print('Lỗi khi upload ảnh: $e');
                        } finally {
                          // Đóng spinner
                          Navigator.of(context).pop();
                        }
                        // Thoát màn hình
                        Navigator.pop(context);
                      },
                      child: button(Icons.check, Alignment.bottomRight, (screenHeight / 5) * 1 / 2, screenHeight / 20, screenWidth / 10, Colors.green),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget button(IconData icon, Alignment alignment, double size, double margin1, double margin2, Color background) {
    return Align(
      alignment: alignment,
      child: Container(
        margin: EdgeInsets.only(
          left: margin2,
          bottom: margin1,
          top: margin1,
          right: margin2,
        ),
        height: size,
        width: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: background,
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(2, 2),
              blurRadius: 10,
            ),
          ],
        ),
        child: Center(
          child: Icon(
            icon,
            color: Colors.white,
            size: (size * 2) / 3,
          ),
        ),
      ),
    );
  }
}

void showLoadingDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false, // Không cho phép thoát khi nhấn bên ngoài
    builder: (BuildContext context) {
      return Center(
        child: CircularProgressIndicator(),
      );
    },
  );
}


