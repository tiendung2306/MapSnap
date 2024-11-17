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

import 'package:flutter/material.dart';
import 'package:mapsnap_fe/Model/Picture.dart';
import 'package:mapsnap_fe/Widget/accountModel.dart';
import 'package:provider/provider.dart';

import '../PictureManager/CURD_picture.dart';

class ConfirmScreen extends StatelessWidget {
  final String imagePath;

  const ConfirmScreen({Key? key, required this.imagePath}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    var accountModel = Provider.of<AccountModel>(context, listen: false);
    DateTime now = DateTime.now();
    DateTime vietnamTime = now.toUtc().add(Duration(hours: 7)); // Chuyển sang múi giờ UTC+7
    String dayString = '${vietnamTime.day}-${vietnamTime.month}-${vietnamTime.year}';

    CreatePicture createPicture = CreatePicture(
      userId: accountModel.idUser,
      locationId: "60c72b2f9af1b8124cf74c9b",
      visitId: "60c72b2f9af1b8124cf74c9c",
      journeyId: "60c72b2f9af1b8124cf74c9d",
      link: imagePath,
      capturedAt: vietnamTime,
    );



    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Image.file(
              File(imagePath),
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
                        List<Picture>? picture = await upLoadImage(createPicture);
                        // Cập nhật ảnh vào ImageManager
                        // Provider.of<AccountModel>(context, listen: false).addImageDay(picture![0]);
                        Provider.of<AccountModel>(context, listen: false).addImageDay(picture![0], dayString);
                        Navigator.pop(context); // Quay lại màn hình trước đó
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


