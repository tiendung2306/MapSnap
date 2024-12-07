import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mapsnap_fe/Manager/CURD_picture.dart';
import 'package:mapsnap_fe/Manager/CURD_posts.dart';
import 'package:mapsnap_fe/Model/Picture.dart';
import 'package:mapsnap_fe/Model/Posts.dart';
import 'package:mapsnap_fe/Widget/accountModel.dart';
import 'package:provider/provider.dart';

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

  // Journey đã có
  String? selectedJourney; // Biến lưu Journey được chọn
  List<Map<String, String>> journeys = [
    {"id": "1", "name": "Hành trình Sapa"},
    {"id": "2", "name": "Khám phá Đà Nẵng"},
    {"id": "3", "name": "Thành phố Hồ Chí Minh"},
  ];

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
              final pickedFiles = await picker.pickMultiImage();
              if (pickedFiles != null) {
                setState(() {
                  images = pickedFiles; // Lưu danh sách ảnh được chọn
                });
              }
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
            // Chọn journey
            DropdownButtonFormField<String>(
              value: selectedJourney,
              items: journeys.map((journey) {
                return DropdownMenuItem(
                  value: journey["id"],
                  child: Text(journey["name"]!),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedJourney = value;
                });
              },
              decoration: InputDecoration(
                labelText: "Chọn hành trình",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            // Nút đăng bài
            ElevatedButton.icon(
              onPressed: () async {
                String content = postContentController.text.trim();
                if (content.isNotEmpty && selectedJourney != null) {
                  DateTime now = DateTime.now();
                  DateTime vietnamTime = now.toUtc().add(Duration(hours: 7));
                  var accountModel =
                  Provider.of<AccountModel>(context, listen: false);
                  for (int i = 0; i < images!.length; i++) {
                    CreatePicture createPicture = CreatePicture(
                      userId: accountModel.idUser,
                      locationId: "5f8a5e7f575d7a2b9c0d47e5",
                      visitId: "5f8a5e7f575d7a2b9c0d47e5",
                      journeyId: "5f8a5e7f575d7a2b9c0d47e5",
                      link: images![i].path,
                      capturedAt: vietnamTime,
                    );
                    List<Picture>? picture = await upLoadImage(createPicture);
                    imageULR.add(picture![0].link);
                  }
                  for (int i = 0; i < images!.length; i++) {
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
                    journeyId: selectedJourney!, // Gắn Journey đã chọn
                  );
                  Posts posts = (await upLoadPost(createPost))!;
                  Navigator.pop(context, posts); // Quay lại màn hình chính
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(selectedJourney == null
                            ? "Vui lòng chọn hành trình!"
                            : "Vui lòng nhập nội dung bài viết!")),
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
              label: Text("Đăng bài"),
            ),
          ],
        ),
      ),
    );
  }
}
