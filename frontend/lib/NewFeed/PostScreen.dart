import 'dart:math';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mapsnap_fe/Manager/CURD_location.dart';
import 'package:mapsnap_fe/Manager/CURD_picture.dart';
import 'package:mapsnap_fe/Manager/CURD_posts.dart';
import 'package:mapsnap_fe/Model/Picture.dart';
import 'package:mapsnap_fe/Model/Posts.dart';
import 'package:mapsnap_fe/NewFeed/FullScreenImageGallery.dart';
import 'package:mapsnap_fe/NewFeed/ImageFullScreen.dart';
import 'package:mapsnap_fe/NewFeed/fullImage.dart';
import 'package:mapsnap_fe/Widget/accountModel.dart';
import 'package:provider/provider.dart';

import '../Model/Location.dart';

class PostScreen extends StatefulWidget {
  PostScreen({Key? key}) : super(key: key);

  @override
  _PostScreenState createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final TextEditingController postContentController = TextEditingController();
  final ImagePicker picker = ImagePicker();
  List<XFile>? images = [];
  List<Map<String, String>> listMedia = [];
  List<String> imageULR = [];
  Location? location;
  List<Location> listLocation = [];
  bool isCurrentLocationSelected = false;
  String address = "Một nơi nào đó";


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

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text("Bài viết mới"),
          actions: [
            IconButton(
              onPressed: () async {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FullImageScreen(),
                    )
                ).then((values) {
                  if (values != null) {
                    imageULR.addAll(values);
                    print(imageULR);
                  }
                  for (int i = 0; i < imageULR.length; i++) {
                    listMedia.add({
                      "type": "image",
                      "url": imageULR[i],
                    });
                  }
                  setState(() {});
                });
              },
              icon: Icon(Icons.photo, size: 30),
            ),
          ],
        ),
        body: Container(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Nội dung bài viết
                  TextField(
                    controller: postContentController,
                    maxLines: 5,
                    decoration: InputDecoration(
                      hintText: "Nội dung bài viết...",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 20),
            
                  Container(
                    height: imageULR.isNotEmpty
                        ? ((imageULR.length > 4 ? 2 : (imageULR.length / (imageULR.length > 1 ? 2 : 1)).ceil()) *
                        (screenWidth / (imageULR.length > 1 ? 2 : 1))) +
                        ((imageULR.length > 4 ? 1 : (imageULR.length / (imageULR.length > 1 ? 2 : 1)).ceil() - 1) * 5)
                        : 0,
                    child: GridView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: imageULR.length > 1 ? 2 : 1,
                        crossAxisSpacing: 5,
                        mainAxisSpacing: 5,
                        childAspectRatio: 1,
                      ),
                      itemCount: imageULR.length > 4 ? 4 : imageULR.length,
                      itemBuilder: (context, imgIndex) {
                        if (imgIndex == 3 && imageULR.length > 4) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => FullScreenImageGallery(
                                    images: listMedia, // Toàn bộ danh sách ảnh
                                  ),
                                ),
                              );
                            },
                            child: Stack(
                              alignment: Alignment.center, // Đặt Text vào giữa ảnh
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: NetworkImage(imageULR[imgIndex]),
                                      fit: BoxFit.cover,
                                    ),
                                    border: Border.all(
                                      color: Colors.blue, // Màu viền
                                      width: 2, // Độ dày viền
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Opacity(
                                    opacity: 0.3, // Làm ảnh thứ 3 trong suốt
                                    child: Container(
                                      color: Colors.black, // Nền mờ màu đen
                                    ),
                                  ),
                                ),
                                Text(
                                  "+${(imageULR.length - 4).toString()}",
                                  style: const TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white, // Màu chữ hiển thị trên nền mờ
                                  ),
                                ),
                              ],
                            ),
                          );
                        } else {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ImageFullScreen(
                                    image: imageULR[imgIndex],
                                  ),
                                ),
                              );
                            },
                            child: Image.network(
                              imageULR[imgIndex],
                              fit: BoxFit.cover,
                            ),
                          );
                        }
                      },
                    ),
                  ),
            
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Địa điểm", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 5),
            
                      // Nút chọn "Vị trí hiện tại"
                      Row(
                        children: [
                          ElevatedButton.icon(
                            onPressed: () async {
                              if (!isCurrentLocationSelected) {
                                try {
                                  Map<String, double> coordinates = randomVietnamCoordinates();
                                  InfoVisit? infoLocation = await AutoLocation(coordinates['latitude']!,coordinates['longitude']!);
                                  // Cập nhật trạng thái
                                  setState(() {
                                    address = infoLocation!.address;
                                    isCurrentLocationSelected = true;
                                  });
                                } catch (e) {
                                  print("Không thể lấy vị trí hiện tại: $e");
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text("Không thể lấy vị trí hiện tại!")),
                                  );
                                }
                              } else {
                                setState(() {
                                  isCurrentLocationSelected = false;
                                  location = null;
                                });
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isCurrentLocationSelected ? Colors.red : Colors.blue,
                            ),
                            icon: Icon(
                              isCurrentLocationSelected ? Icons.close : Icons.my_location,
                            ),
                            label: Text(
                              isCurrentLocationSelected ? "Hủy vị trí hiện tại" : "Chọn vị trí hiện tại",
                              style: TextStyle(color: Colors.white, fontSize: 15),
                            ),
                          ),
                          const SizedBox(width: 10),
                          if (isCurrentLocationSelected)
                            Expanded(
                              child: Text(
                                address,
                                style: TextStyle(fontSize: 16),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 10),
            
                      // Dropdown chọn địa điểm
                      Container(
                        width: screenWidth,
                        decoration: BoxDecoration(
                          color: isCurrentLocationSelected ? Colors.grey[300] : Colors.white,
                          border: Border.all(
                            color: Colors.black,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: DropdownButton2<Location>(
                          isExpanded: true,
                          dropdownStyleData: const DropdownStyleData(
                            decoration: BoxDecoration(
                              color: Colors.white,
                            ),
                            maxHeight: 200,
                          ),
                          value: isCurrentLocationSelected ? null : location,
                          hint: Text("Chọn địa điểm                                                  "),
                          items: listLocation.map((locations) {
                            return DropdownMenuItem<Location>(
                              value: locations,
                              child: Text(
                                locations.address,
                                softWrap: true, // Cho phép xuống dòng khi văn bản vượt quá chiều rộng
                              ),
                            );
                          }).toList(),
                          onChanged: isCurrentLocationSelected ? null : (Location? value) {
                            setState(() {
                              location = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
            
                  SizedBox(height: 50),
                  // Nút đăng bài
                  ElevatedButton.icon(
                    onPressed: () async {
                      String content = postContentController.text.trim();
                      if (content.isNotEmpty) {
                        var accountModel = Provider.of<AccountModel>(context, listen: false);
                        DateTime now = DateTime.now();
                        DateTime vietnamTime = now.toUtc().add(Duration(hours: 7));
            
            
                        CreatePost createPost = CreatePost(
                          userId: accountModel.idUser,
                          content: postContentController.text,
                          media: listMedia,
                          createdAt: vietnamTime.millisecondsSinceEpoch,
                          updatedAt: vietnamTime.millisecondsSinceEpoch,
                          commentsCount: 0,
                          likesCount: 0,
                          journeyId: "5f8a5e7f575d7a2b9c0d47e5",
                          address: location == null ? address : location!.address,
                        );
                        Posts posts = (await upLoadPost(createPost))!;
                        Navigator.pop(context, posts);// Quay lại màn hình chính
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text("Vui lòng nhập nội dung bài viết!")),
                        );
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.blue), // Màu nền
                      foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.white), // Màu chữ
                    ),
                    icon: Icon(Icons.post_add_outlined,size: 35,),
                    label: Text("Đăng bài", style: TextStyle(fontSize: 25),),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Map<String, double> randomVietnamCoordinates() {
  final random = Random();

  // Giới hạn Latitude và Longitude trong phạm vi Việt Nam
  double minLat = 8.179;
  double maxLat = 23.392;
  double minLng = 102.144;
  double maxLng = 109.464;

  // Random tọa độ
  double randomLat = minLat + (maxLat - minLat) * random.nextDouble();
  double randomLng = minLng + (maxLng - minLng) * random.nextDouble();

  return {
    'latitude': randomLat,
    'longitude': randomLng,
  };
}

