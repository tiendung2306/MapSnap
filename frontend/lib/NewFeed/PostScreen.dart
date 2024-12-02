import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mapsnap_fe/Manager/CURD_posts.dart';
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Bài viến mới"),
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
            icon: Icon(Icons.photo, size: 30,),

          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: postContentController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: "Nội dung bài viết...",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () async {
                String content = postContentController.text.trim();
                if (content.isNotEmpty) {
                  // Thêm bài viết mới vào danh sách
                  var accountModel = Provider.of<AccountModel>(context, listen: false);
                  for(int i = 0; i < images!.length ; i++) {
                    listMedia.add({"type": "image",
                      "url": images![i].path});
                  }
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
                  );
                  Posts posts = (await upLoadPost(createPost))!;
                  Navigator.pop(context, posts ); // Quay lại màn hình chính
                } else {
                  // Hiển thị cảnh báo nếu nội dung trống
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Vui lòng nhập nội dung bài viết!")),
                  );
                }
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.blue), // Màu nền cho nút
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white), // Màu chữ
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
