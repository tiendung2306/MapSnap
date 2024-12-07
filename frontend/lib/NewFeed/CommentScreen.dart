import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mapsnap_fe/Manager/CURD_comment.dart';
import 'package:mapsnap_fe/Model/Comment.dart';
import 'package:mapsnap_fe/Model/Posts.dart';
import 'package:mapsnap_fe/Model/User_2.dart';
import 'package:mapsnap_fe/Widget/UpdateUser.dart';
import 'package:mapsnap_fe/Widget/accountModel.dart';
import 'package:provider/provider.dart';

class CommentScreen extends StatefulWidget {
  List<Comment> listComment;
  Posts post;
  CommentScreen({
    Key? key,
    required this.listComment,
    required this.post,
  }) : super(key: key);

  @override
  _CommentScreenState createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> with WidgetsBindingObserver {
  final TextEditingController commentController = TextEditingController();
  String? editingCommentId;
  double keyboardHeight = 0;
  String commentId = "";
  int commentIndex = 0;
  List<User?> listUser = [];
  bool isReset = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final keyboardVisibility = MediaQuery.of(context).viewInsets.bottom;
      setState(() {
        keyboardHeight = keyboardVisibility;
      });
    });
    loadAllUsers();
  }


  Future<void> loadAllUsers() async {
    var accountModel = Provider.of<AccountModel>(context, listen: false);
    listUser = [];
    for (var comment in widget.listComment) {
      User? user = await fetchData(comment.userId, accountModel.token_access);
      listUser.add(user);
    }
  }

  Future<void> OKE() async {

  }


  @override
  void dispose() {
    // Hủy đăng ký WidgetsBindingObserver
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var accountModel = Provider.of<AccountModel>(context, listen: false);

    return Scaffold(
      body: FutureBuilder(
        future: isReset == false ? loadAllUsers() : OKE(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting && !isReset) {
            // Hiển thị màn hình chờ trong khi tải dữ liệu
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError && !isReset) {
            // Hiển thị lỗi nếu quá trình tải thất bại
            return Center(child: Text('Lỗi khi tải dữ liệu!'));
          }
          isReset = true;

          // Giao diện chính khi dữ liệu đã tải xong
          return GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: DraggableScrollableSheet(
              expand: false,
              initialChildSize: 1,
              minChildSize: 1,
              maxChildSize: 1,
              builder: (context, scrollController) {
                return Container(
                  padding: EdgeInsets.all(10),
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Bình luận",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Expanded(
                        child: ListView.builder(
                          controller: scrollController,
                          itemCount: widget.listComment.length,
                          itemBuilder: (context, index) {
                            var comment = widget.listComment[index];
                            var user = listUser[index];
                            return ListTile(
                              leading: CircleAvatar(
                                maxRadius: 30,
                                backgroundColor: Colors.grey,
                                child: Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.grey,
                                      image: DecorationImage(
                                        image: NetworkImage(user!.avatar),
                                        fit: BoxFit.cover,
                                      )
                                  ),
                                ),
                              ),
                              title: Text(user.username, style: TextStyle(fontSize: 20),),
                              subtitle: Text(comment.content),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.edit),
                                    onPressed: () {
                                      commentController.text = comment.content;
                                      commentId = comment.id;
                                      commentIndex = index;
                                      setState(() {
                                        editingCommentId = comment.id;
                                      });
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete),
                                    onPressed: () async {
                                      await RemoveComments(comment.id);
                                      setState(() {
                                        widget.listComment.removeAt(index);
                                      });
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: commentController,
                              decoration: InputDecoration(
                                hintText: editingCommentId == null
                                    ? "Viết bình luận..."
                                    : "Chỉnh sửa bình luận...",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                contentPadding: EdgeInsets.symmetric(horizontal: 15),
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.send),
                            onPressed: () async {
                              if (commentController.text.isNotEmpty) {
                                DateTime now = DateTime.now();
                                DateTime vietnamTime = now.toUtc().add(Duration(hours: 7));
                                Comment? comment;

                                if (editingCommentId == null) {
                                  addComment addcomment = addComment(
                                    postId: widget.post.id,
                                    userId: accountModel.idUser,
                                    content: commentController.text,
                                    createdAt: vietnamTime.millisecondsSinceEpoch,
                                    updatedAt: vietnamTime.millisecondsSinceEpoch,
                                  );
                                  comment = await AddComment(addcomment);
                                  User? user = await fetchData(comment!.userId, accountModel.token_access);
                                  setState(() {
                                    widget.listComment.insert(0, comment!);
                                    listUser.insert(0, user);
                                  });
                                } else {
                                  addComment addcomment = addComment(
                                    postId: widget.post.id,
                                    userId: accountModel.idUser,
                                    content: commentController.text,
                                    createdAt: vietnamTime.millisecondsSinceEpoch,
                                    updatedAt: vietnamTime.millisecondsSinceEpoch,
                                  );
                                  comment = await updateComment(addcomment, commentId);
                                  setState(() {
                                    widget.listComment[commentIndex] = comment!;
                                  });
                                }

                                commentController.clear();
                                setState(() {
                                  editingCommentId = null;
                                });
                              }
                            },
                          ),
                        ],
                      ),
                      if (keyboardHeight > 0)
                        Container(
                          color: Colors.blue,
                          height: keyboardHeight,
                        ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
