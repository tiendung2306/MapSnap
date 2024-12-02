import 'package:flutter/material.dart';
import 'package:mapsnap_fe/Manager/CURD_posts.dart';
import 'package:mapsnap_fe/Model/Posts.dart';
import 'package:mapsnap_fe/Model/User_2.dart';
import 'package:mapsnap_fe/NewFeed/CommentScreen.dart';
import 'package:mapsnap_fe/NewFeed/FullScreenImageGallery.dart';
import 'package:mapsnap_fe/NewFeed/PostScreen.dart';
import 'package:mapsnap_fe/Widget/UpdateUser.dart';
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
  int count = 0;
  late Future<List<Posts>> listPost;
  late List<User?> user; // Cho phép null
  Posts? post;


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
    super.initState();
    listPost = resetData().then((posts) async {
      user = List<User?>.generate(posts.length, (index) => null); // Danh sách có thể thay đổi
      var accountModel = Provider.of<AccountModel>(context, listen: false);

      accountModel.resetListComment();
      for (int i = 0; i < posts.length; i++) { // Tạo dữ liệu giả
        accountModel.addListComment();
      }
      // Sử dụng Future.wait để đợi tất cả dữ liệu người dùng được tải về
      await Future.wait(posts.asMap().entries.map((entry) async {
        int index = entry.key;
        Posts post = entry.value;
        user[index] = await getUser(post.userId, accountModel.token_access);
      }));
      return posts;
    });
  }


  Future<List<Posts>> resetData() async {
    return await getInfoPosts('-createdAt',"sortBy");
  }

  Future<User?> getUser(String userId, String token_access) async {
    try {
      return await fetchData(userId, token_access);
    } catch (e) {
      print("Error fetching user: $e");
      return null;
    }
  }

  void showComments(BuildContext context, int index) {
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
        resizeToAvoidBottomInset: false,
        body: FutureBuilder<List<Posts>>(
          future: listPost,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                  child: CircularProgressIndicator()
              );
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                  child: Scaffold(
                    appBar: AppBar(
                      title: Text('HIHI'),
                      leading: IconButton(
                        icon: Icon(Icons.close, color: Colors.black),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  )
              );
            }

            var posts = snapshot.data!; // Lấy dữ liệu từ snapshot


            return Consumer<AccountModel>(
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
                              ),
                            ],
                          ),
                          padding: EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: 70,
                                height: 50,
                                child: Image.asset(
                                    'assets/Login/logo.png',
                                  fit: BoxFit.cover,
                                )
                              ),
                              SizedBox(width: 15),
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
                              SizedBox(width: 20),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => PostScreen(),
                                    ),
                                  ).then((success) {
                                    if (success != null) {
                                      setState(() {
                                        setState(() async {
                                          posts.insert(0,success);  // Thêm bài viết mới vào đầu danh sách
                                          user.insert(0,null);
                                          user[0] = await getUser(success.userId, accountModel.token_access);
                                          accountModel.addListComment();
                                        });
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
                            // reverse: true,
                            itemCount: posts.length, // Dùng posts.length thay vì count
                            itemBuilder: (context, index) {
                              var post = posts[index];
                              var postUser = user[index];
                              if(postUser != null) {
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
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: 70,
                                            height: 70,
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.grey,
                                                image: DecorationImage(
                                                  image: NetworkImage(postUser.avatar),
                                                  fit: BoxFit.cover,
                                                )
                                            ),
                                          ),
                                          SizedBox(width: 15),
                                          Expanded(
                                            child: Container(
                                              padding: EdgeInsets.symmetric(vertical: 5),
                                              height: 70,
                                              child: Text(
                                                postUser.username,
                                                style: TextStyle(
                                                  fontSize: 25,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 20),
                                          GestureDetector(
                                            onTap: () {
                                              // Không cần xử lý ở đây vì PopupMenuButton tự động hiển thị menu
                                            },
                                            child: PopupMenuButton<String>(
                                              color: Colors.white,
                                              onSelected: (String value) async {
                                                switch (value) {
                                                  case 'edit':
                                                    print("Chỉnh sửa bài viết");
                                                    break;
                                                  case 'delete':
                                                  // Gọi API xóa bài viết
                                                    await RemovePost(post.id);  // Xóa bài viết
                                                    setState(() {
                                                      posts.remove(post); // Xóa bài viết khỏi danh sách cục bộ
                                                      user.remove(postUser);   // Xóa thông tin người dùng tương ứng
                                                    });
                                                    break;
                                                  case 'hide':
                                                    print("Ẩn bài viết");
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
                                        child: Text(post.content, style: TextStyle(fontSize: 20),),
                                      ),
                                      Container(
                                        height: post.media.isNotEmpty
                                            ? ((post.media.length > 4 ? 2 : (post.media.length / (post.media.length > 1 ? 2 : 1)).ceil()) *
                                            (screenWidth / (post.media.length > 1 ? 2 : 1))) +
                                            ((post.media.length > 4 ? 1 : (post.media.length / (post.media.length > 1 ? 2 : 1)).ceil() - 1) * 5)
                                            : 0,
                                        child: GridView.builder(
                                          physics: NeverScrollableScrollPhysics(),
                                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: post.media.length > 1 ? 2 : 1,
                                            crossAxisSpacing: 5,
                                            mainAxisSpacing: 5,
                                            childAspectRatio: 1,
                                          ),
                                          itemCount: post.media.length > 4 ? 4 : post.media.length,
                                          itemBuilder: (context, imgIndex) {
                                            if (imgIndex == 3 && post.media.length > 4) {
                                              return GestureDetector(
                                                onTap: () {
                                                  print("Xem thêm ảnh");
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.black.withOpacity(0.5),
                                                    borderRadius: BorderRadius.circular(8),
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      '+${post.media.length - 3}',
                                                      style: TextStyle(color: Colors.white, fontSize: 24),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            } else {
                                              return GestureDetector(
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) => FullScreenImageGallery(
                                                        images: post.media, // Toàn bộ danh sách ảnh
                                                      ),
                                                    ),
                                                  );
                                                },
                                                child: Image.network(
                                                  post.media[imgIndex]['url']!,
                                                  fit: BoxFit.cover,
                                                ),
                                              );
                                            }
                                          },
                                        ),
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
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      Icons.thumb_up_alt_outlined,
                                                      color: Colors.blue,
                                                    ),
                                                    SizedBox(width: 10),
                                                    Text(like.toString()),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 30),
                                            GestureDetector(
                                              onTap: () => showComments(context, index ),
                                              child: Container(
                                                height: 30,
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      Icons.comment,
                                                      color: Colors.green,
                                                    ),
                                                    SizedBox(width: 10),
                                                    Text("Comment"),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }
                              return null;
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
            );
          },
        ),
      ),
    );
  }
}
