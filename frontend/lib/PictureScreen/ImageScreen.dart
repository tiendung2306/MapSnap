import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mapsnap_fe/Model/Picture.dart';

import '../Manager/CURD_picture.dart';

class ImageScreen extends StatefulWidget {
  final Picture picture;
  final Function(Picture) onDelete; // Thêm hàm callback để xóa ảnh

  const ImageScreen({
    Key? key,
    required this.picture,
    required this.onDelete,
  }) : super(key: key);


  @override
  State<ImageScreen> createState() => ImageScreenState();
}

class ImageScreenState extends State<ImageScreen> {



  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    // Hàm hiển thị hộp thoại xác nhận
    Future<void> _showConfirmationDialog({
      required String title,
      required String content,
      required Function() onConfirm,
    }) async {
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            title: Text(title, style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold ,color: Colors.black)),
            content: Text(content, style: TextStyle(fontSize: 20 ,color: Colors.black)),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context), // Đóng hộp thoại
                child: const Text("Hủy", style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold ,color: Colors.black)),
              ),
              ElevatedButton(
                onPressed: () {
                  onConfirm();
                  Navigator.pop(context); // Đóng hộp thoại sau khi xác nhận
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll<Color>(Colors.blue),
                ),
                child: Text("Đồng ý",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold ,color: Colors.white),),
              ),
            ],
          );
        },
      );
    }

    return SafeArea(
      child: Scaffold(
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          color: Colors.white,
          height: screenHeight,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const SizedBox(
                  width: 55,
                  height: 55,
                  child: Icon(Icons.close, size: 40, color: Colors.black),
                ),
              ),
              const SizedBox(height: 5),
              Container(
                height: screenHeight - 150,
                decoration: BoxDecoration(
                    color: Colors.white,
                    image: DecorationImage(
                      image: NetworkImage(widget.picture.link),
                      fit: BoxFit.contain,
                    )
                ),
              ),
              const SizedBox(height: 5),
              Expanded(
                child: Container(
                  width: screenWidth,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(
                        onTap: () {
                          _showConfirmationDialog(
                            title: "Xác nhận tải xuống",
                            content: "Bạn có muốn tải ảnh này xuống không?",
                            onConfirm: () {
                              print('Tải xuống');
                              // Thực hiện tải xuống ảnh ở đây
                            },
                          );
                        },
                        child: const SizedBox(
                          width: 100,
                          height: 60,
                          child: Icon(Icons.file_download, size: 40, color: Colors.black),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          _showConfirmationDialog(
                            title: "Xác nhận xóa",
                            content: "Bạn có chắc chắn muốn xóa ảnh này không?",
                            onConfirm: () async {
                              widget.onDelete(widget.picture);
                              await RemoveImage(widget.picture.id);
                              Navigator.pop(context); // Quay về màn hình trước
                            },
                          );
                        },
                        child: const SizedBox(
                          width: 100,
                          height: 60,
                          child: Icon(Icons.delete_outline, size: 40, color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
