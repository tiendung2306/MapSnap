import 'package:flutter/material.dart';
import 'package:mapsnap_fe/Widget/accountModel.dart';
import 'package:provider/provider.dart';


class PostScreen extends StatefulWidget {
  final bool result;
  PostScreen(this.result, {Key? key}) : super(key: key);

  @override
  _PostScreenState createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final TextEditingController postContentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Bài viến mới"),
        actions: [
          IconButton(
            onPressed: () {
              print("Thêm ảnh");
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
              onPressed: () {
                String content = postContentController.text.trim();
                if (content.isNotEmpty) {
                  // Thêm bài viết mới vào danh sách
                  var accountModel = Provider.of<AccountModel>(context, listen: false);
                  Navigator.pop(context, true); // Quay lại màn hình chính
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
