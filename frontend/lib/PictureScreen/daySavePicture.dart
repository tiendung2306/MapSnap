import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mapsnap_fe/Model/Picture.dart';
import 'package:mapsnap_fe/Widget/accountModel.dart';
import 'package:provider/provider.dart';
import '../PictureManager/CURD_picture.dart';
import 'ImageScreen.dart';

class daySaveScreen extends StatefulWidget {
  const daySaveScreen({Key? key}) : super(key: key);

  @override
  State<daySaveScreen> createState() => _daySaveScreenState();
}

class _daySaveScreenState extends State<daySaveScreen> {

  @override
  void initState() {
    fetchImagesByUserId();
    super.initState();
  }

  Future<void> fetchImagesByUserId() async {
    var accountModel = Provider.of<AccountModel>(context, listen: false);

    // Kiểm tra xem đã tải ảnh chưa
    if (!accountModel.isFetchedImage) {
      List<Picture> images = await getInfoImages(accountModel.idUser, 'user_id');

      if (images.isNotEmpty) {
        for (var image in images) {
          accountModel.addImageDay(image);
          print('Ảnh: ${image.link}');
        }
      } else {
        print('Không có ảnh nào được tìm thấy.');
      }

      // Đánh dấu là đã tải ảnh
      accountModel.setFetchedImage(true);
    }
  }



  // Hàm chuyển đến màn hình hiển thị ảnh lớn
  void navigateToImageScreen(BuildContext context, Picture picture, int dayIndex) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ImageScreen(
          picture: picture,
          onDelete: (Picture path) {
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
                for(int i = imageProvider.imageManager.length - 1; i >= 0; i--) ...[
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
                          // reverse: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: imageProvider.imageManager[i].length,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 5,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                          ),
                          itemBuilder: (BuildContext context, int index) {
                            // Đảo ngược thứ tự khi hiển thị
                            final String imagePath = 'http://10.0.2.2:3000${imageProvider.imageManager[i][index].link}';

                            return GestureDetector(
                              onTap: () {
                                navigateToImageScreen(context,imageProvider.imageManager[i][index],i);
                              },
                              child: Container(
                                height: 70,
                                width: 70,
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  image: DecorationImage(
                                    image: NetworkImage(imagePath),
                                    fit: BoxFit.cover,
                                  )
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
                SizedBox(height: 20,),
                ElevatedButton(
                  onPressed: () {
                    imageProvider.addImageManager([]); // Tạo một ngày mới
                  },
                  child: const Text("Thêm ngày mới"),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

