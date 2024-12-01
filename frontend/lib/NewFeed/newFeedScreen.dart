
import 'package:flutter/material.dart';
import 'package:mapsnap_fe/NewFeed/CommentScreen.dart';
import 'package:mapsnap_fe/NewFeed/PostScreen.dart';
import 'package:mapsnap_fe/Widget/accountModel.dart';
import 'package:mapsnap_fe/Widget/bottomNavigationBar.dart';
import 'package:provider/provider.dart';

class newFeedScreen extends StatefulWidget {
  newFeedScreen({Key? key}) : super(key: key);

  @override
  State<newFeedScreen> createState() => _newFeedScreenState();
}

class _newFeedScreenState extends State<newFeedScreen> {
  int like = 0;
  int count = 3;

  final TextEditingController commentController = TextEditingController();

  int currentTabIndex = 3;

  bool result = false;

  void onTabTapped(int index) {
    setState(() {
      currentTabIndex = index;
    });
    print("Tab $index selected");
  }

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  void fetchData() {
    var accountModel = Provider.of<AccountModel>(context, listen: false);
    accountModel.resetListComment();
    for(int i = 0; i < count; i++) {
      accountModel.addListComment();
    }
  }


  void showComments(BuildContext context,int index) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return CommentScreen(index: index);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        body: Consumer<AccountModel>(
          builder: (context, accountModel, child) {
            return Stack(
              children: [
                Image.asset(
                  'assets/Image/Background.png',
                  width: screenHeight,
                  height: screenHeight,
                  fit: BoxFit.none,
                ),
                Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            spreadRadius: 3,
                            blurRadius: 6,
                            offset: Offset(5, 5),
                          )
                        ],
                      ),
                      padding: EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            color: Colors.red,
                          ),
                          SizedBox(width: 15,),
                          Expanded(
                            child: Container(
                              height: 50,
                              child: TextField(
                                decoration: InputDecoration(
                                  hintText: "Tìm kiếm...",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  prefixIcon: Icon(Icons.search),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 20,),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => PostScreen(result)),
                              ).then((success) {
                                if (success == true) { // Chỉ tăng count khi đăng bài thành công
                                  setState(() {
                                    count++;  // Tăng số lượng bài viết
                                    accountModel.addListComment(); // Cập nhật thêm bài viết vào danh sách
                                  });
                                }
                              });
                            },
                            child: Container(
                              width: 50,
                              height: 50,
                              child: Icon(
                                Icons.add,
                                size: 40,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 5),
                    Expanded(
                      child: ListView.builder(
                        reverse: true,
                        itemCount: count, // Số lượng bài viết
                        itemBuilder: (context, index) {
                          return Container(
                            padding: EdgeInsets.all(10),
                            margin: EdgeInsets.only(bottom: 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  spreadRadius: 3,
                                  blurRadius: 6,
                                  offset: Offset(5, 5),
                                )
                              ],
                            ),
                            child: Column(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(10),
                                      height: 70,
                                      width: 70,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(35),
                                        color: Colors.red,
                                      ),
                                    ),
                                    SizedBox(width: 15),
                                    Container(
                                      padding: EdgeInsets.symmetric(vertical: 5),
                                      height: 70,
                                      width: screenWidth - 175,
                                      child: Text(
                                        "Haizzzz ${index}",
                                        style: TextStyle(
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold),
                                        maxLines: 2, // Giới hạn tối đa 2 dòng
                                        overflow: TextOverflow.ellipsis, // Thêm dấu "..." nếu vượt quá
                                      ),
                                    ),
                                    SizedBox(width: 20),
                                    GestureDetector(
      
                                      onTap: () {
                                        // Không cần xử lý ở đây vì PopupMenuButton tự động hiển thị menu
                                      },
                                      child: PopupMenuButton<String>(
                                        color: Colors.white,
                                        onSelected: (String value) {
                                          switch (value) {
                                            case 'edit':
                                              print("Chỉnh sửa bài viết");
                                              // Thêm logic chỉnh sửa bài viết tại đây
                                              break;
                                            case 'delete':
                                              print("Xóa bài viết");
                                              // Thêm logic xóa bài viết tại đây
                                              break;
                                            case 'hide':
                                              print("Ẩn bài viết");
                                              // Thêm logic ẩn bài viết tại đây
                                              break;
                                          }
                                        },
                                        itemBuilder: (BuildContext context) {
                                          return [
                                            PopupMenuItem<String>(
                                              value: 'edit',
                                              child: Row(
                                                children: [
                                                  Icon(Icons.edit, color: Colors.grey),
                                                  SizedBox(width: 10),
                                                  Text('Chỉnh sửa bài viết'),
                                                ],
                                              ),
                                            ),
                                            PopupMenuItem<String>(
                                              value: 'delete',
                                              child: Row(
                                                children: [
                                                  Icon(Icons.delete, color: Colors.red),
                                                  SizedBox(width: 10),
                                                  Text('Xóa bài viết'),
                                                ],
                                              ),
                                            ),
                                            PopupMenuItem<String>(
                                              value: 'hide',
                                              child: Row(
                                                children: [
                                                  Icon(Icons.visibility_off, color: Colors.grey),
                                                  SizedBox(width: 10),
                                                  Text('Ẩn bài viết'),
                                                ],
                                              ),
                                            ),
                                          ];
                                        },
                                        icon: Icon(
                                          Icons.more_horiz,
                                          size: 30,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 5),
                                Container(
                                  padding: EdgeInsets.all(10),
                                  child: Text(
                                    "kjdfhbgkjasbndkjfhbaskjdbfkjasdfsdfasndbfkja"
                                        "sbdkjfbaskjdnfsdfasdfasdfasdfcsdvsesfddfvbsdfbsdbsdfgsdfgsdfg"
                                        "gasdc",
                                  ),
                                ),
                                Container(
                                  height: 300,
                                  color: Colors.pink,
                                ),
                                Container(
                                  padding: EdgeInsets.all(10),
                                  height: 50,
                                  child: Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            like++;
                                          });
                                        },
                                        child: Container(
                                          height: 30,
                                          child: Icon(Icons.favorite_border),
                                        ),
                                      ),
                                      SizedBox(width: 5),
                                      Container(
                                        width: 50,
                                        child: Text(
                                          like.toString(),
                                          style: TextStyle(fontSize: 17),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            showComments(context, index);
                                          });
                                        },
                                        child: Container(
                                          height: 30,
                                          child: Icon(Icons.chat_bubble_outline),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    Container(
                      height: 2,
                      color: Colors.grey,
                    ),
                    CustomBottomNav(
                      onTabTapped: onTabTapped,
                      currentIndex: currentTabIndex,
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
