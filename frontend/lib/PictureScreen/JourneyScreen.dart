import 'package:flutter/material.dart';
import 'package:mapsnap_fe/PictureScreen/ImageScreen.dart';
import 'package:mapsnap_fe/Widget/DownloadImage.dart';
import 'package:provider/provider.dart';

import '../Model/Picture.dart';
import '../Widget/accountModel.dart';


class journeyScreen extends StatefulWidget {
  late String journey;

   journeyScreen({
      required this.journey,
      Key? key
   }) : super(key: key);

  @override
  State<journeyScreen> createState() {
    return _journeyScreenState();
  }
}

class _journeyScreenState  extends State<journeyScreen>{

  int k = 1;


  // Hàm chuyển đến màn hình hiển thị ảnh lớn 2
  void navigateToImageScreen2(BuildContext context, String picture, String journey, String visit) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ImageScreen(
          picture: picture,
          onDelete: (path) {
            Provider.of<AccountModel>(context, listen: false)
                .removeImageLocation(path, journey, visit);
          },
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {

    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;


    return Scaffold(
      body: Consumer<AccountModel>(
        builder: (context, accountModel, child) {
          final imageManager = accountModel.imageManager[widget.journey];
          final List<String> visitList = imageManager!.keys.toList();
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
                          Text('Ảnh theo địa điểm', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
                          Container(
                            width: 50,
                            height: 50,
                          )
                        ],
                      ),
                    ),
                    // Hiển thị các container cho từng ngày
                    for (int i = accountModel.imageManager[widget.journey]!.length - 1; i >= 0 ; i--) ...[
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                spreadRadius: 3,
                                blurRadius: 6,
                                offset: Offset(5, 5)
                            )
                          ],
                        ),

                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${visitList![i]}",
                              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 5,),
                            Container(
                              height: 2,
                              color: Colors.black54,
                            ),
                            SizedBox(height: 15,),
                            GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: accountModel.imageManager[widget.journey]![visitList![i]]!.length,
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 5,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                              ),
                              itemBuilder: (context, index) {
                                final String imagePath = accountModel.imageManager[widget.journey]![visitList?[i]]![index];
                                return GestureDetector(
                                  onTap: () {
                                    navigateToImageScreen2(context,imagePath,widget.journey,visitList[i]);
                                    // navigateToImageScreen(imagePath);
                                  },
                                  child: Container(
                                    height: 70,
                                    width: 70,
                                    child: Image.asset(
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
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        k++;
                        accountModel.addImageLocation(
                          "assets/Image/${k%7 + 1}.jpg",
                          widget.journey,
                          "Công viên nước",
                        );
                      },
                      child: const Text("Thêm ảnh vào địa điểm hiện tại"),
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


class ImageScreen extends StatefulWidget {
  final String picture;
  final Function(String) onDelete; // Thêm hàm callback để xóa ảnh

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
                      image: AssetImage(widget.picture),
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
                              downloadImage(widget.picture);
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

