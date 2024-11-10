import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mapsnap_fe/Widget/accountModel.dart';
import 'package:provider/provider.dart';
import 'ImageScreen.dart';

class daySaveScreen extends StatelessWidget {
  const daySaveScreen({Key? key}) : super(key: key);

  // Hàm chuyển đến màn hình hiển thị ảnh lớn
  void navigateToImageScreen(BuildContext context, String imagePath, int dayIndex) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ImageScreen(
          imagePath: imagePath,
          onDelete: (String path) {
            Provider.of<AccountModel>(context, listen: false)
                .removeImageDay(path, dayIndex);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Consumer<AccountModel>(  // Lắng nghe thay đổi trong ImageProvider
        builder: (context, imageProvider, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              children: [
                const SizedBox(height: 15),
                for(int i=0; i<imageProvider.imageManager.length; i++) ...[
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          child: Text("Ngày $i",style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                        ),
                        SizedBox(height: 5,),
                        Container(
                          height: 2,
                          color: Colors.black54,
                        ),
                        SizedBox(height: 10,),
                        GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: imageProvider.imageManager[i].length,
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 5,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                            ),
                            itemBuilder: (BuildContext context, int index) {
                              final String imagePath = imageProvider.imageManager[i][index];
                              return GestureDetector(
                                onTap: () {
                                  navigateToImageScreen(context, imagePath,i);
                                },
                                child: Container(
                                  height: 70,
                                  width: 70,
                                  color: Colors.red,
                                  child: imagePath.startsWith('/')
                                      ? Image.file(
                                    File(imagePath),
                                    fit: BoxFit.cover,
                                  )
                                      : Image.asset(
                                    imagePath,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              );
                            },
                          ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 15),
                ElevatedButton(
                  onPressed: () {
                    imageProvider.addImageManager([]); // Tạo một ngày mới
                  },
                  child: const Text("Thêm ngày mới"),
                ),
                ElevatedButton(
                  onPressed: () {
                    imageProvider.addImageDay("assets/Image/8.jpg"); // Thêm ảnh vào ngày hiện tại
                  },
                  child: const Text("Thêm ảnh vào ngày hiện tại"),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

