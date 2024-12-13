import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mapsnap_fe/Manager/CURD_location.dart';
import 'package:mapsnap_fe/Manager/CURD_picture.dart';
import 'package:mapsnap_fe/Manager/CURD_posts.dart';
import 'package:mapsnap_fe/Model/Picture.dart';
import 'package:mapsnap_fe/Model/Posts.dart';
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


  @override
  void initState() {
    fetchLocation();
    super.initState();
  }


  Future<void> fetchLocation() async {
    var accountModel = Provider.of<AccountModel>(context, listen: false);
    listLocation = await getInfoLocation(accountModel.idUser,"","");
    setState(() {});
    // listLocation.insert(0, "Vị trí hiện tại" );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  // Thêm các giá trị vào danh sách
                  imageULR.addAll(values);
                  print(imageULR); // In danh sách sau khi đã cập nhật
                }
              });
            },
            icon: Icon(Icons.photo, size: 30),
          ),
        ],
      ),
      body: Padding(
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

                            // Cập nhật trạng thái
                            setState(() {
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
                    if (isCurrentLocationSelected && location != null)
                      Expanded(
                        child: Text(
                          location!.address,
                          style: TextStyle(fontSize: 16),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 10),

                // Dropdown chọn địa điểm
                Container(
                  decoration: BoxDecoration(
                    color: isCurrentLocationSelected ? Colors.grey[300] : Colors.white,
                    border: Border.all(
                      color: Colors.black,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: DropdownButton2<Location>(
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
                        child: Text(locations.address),
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

            SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                print("Chọn hành trình");
              },
              child: Container(
                width: 150,
                height: 50,

                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Center(
                  child: Text(
                    "Chọn hành trình",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,

                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            // Nút đăng bài
            ElevatedButton.icon(
              onPressed: () async {
                String content = postContentController.text.trim();
                if (content.isNotEmpty) {
                  var accountModel = Provider.of<AccountModel>(context, listen: false);
                  DateTime now = DateTime.now();
                  DateTime vietnamTime = now.toUtc().add(Duration(hours: 7));
                  for (int i = 0; i < imageULR.length; i++) {
                    listMedia.add({
                      "type": "image",
                      "url": imageULR[i],
                    });
                  }

                  CreatePost createPost = CreatePost(
                    userId: accountModel.idUser,
                    content: postContentController.text,
                    media: listMedia,
                    createdAt: vietnamTime.millisecondsSinceEpoch,
                    updatedAt: vietnamTime.millisecondsSinceEpoch,
                    commentsCount: 0,
                    likesCount: 0,
                    journeyId: "5f8a5e7f575d7a2b9c0d47e5", // Gắn Journey đã chọn
                  );
                  Posts posts = (await upLoadPost(createPost))!;
                  Navigator.pop(context, {
                    'post': posts,
                    'Location': location == null ? "Một nơi nào đó": location!.address,
                  }); // Quay lại màn hình chính
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
              icon: Icon(Icons.post_add_outlined),
              label: Text("Đăng bài", style: TextStyle(fontSize: 16),),
            ),
          ],
        ),
      ),
    );
  }
}
