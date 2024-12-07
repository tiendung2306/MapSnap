import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../Model/Picture.dart';
import '../Widget/accountModel.dart';
import '../Manager/CURD_picture.dart';

class FullImageScreen extends StatefulWidget {
  const FullImageScreen({Key? key}) : super(key: key);

  @override
  State<FullImageScreen> createState() => _FullImageScreenState();
}

class _FullImageScreenState extends State<FullImageScreen> {
  bool _isLoading = true; // Trạng thái tải ảnh
  final Set<int> _selectedIndexes = {}; // Lưu chỉ số ảnh được chọn
  List<String> selectedImages = [];

  List<XFile>? images = [];
  final ImagePicker picker = ImagePicker();

  bool _isUploading = false; // Trạng thái đang upload

  @override
  void initState() {
    super.initState();
    fetchImagesByUserId();
  }

  Future<void> fetchImagesByUserId() async {
    var accountModel = Provider.of<AccountModel>(context, listen: false);

    // Đặt trạng thái bắt đầu tải
    setState(() {
      _isLoading = true;
    });

    accountModel.resetFullImage();
    List<Picture> images = await getInfoImages(accountModel.idUser, 'user_id');
    if (images.isNotEmpty) {
      for (var image in images) {
        accountModel.addFullImage(image);
      }
    } else {
      print('Không có ảnh nào được tìm thấy.');
    }

    // Đặt trạng thái tải hoàn tất
    setState(() {
      _isLoading = false;
    });
  }

  // Hàm chọn hoặc bỏ chọn ảnh
  void toggleSelection(int index) {
    setState(() {
      if (_selectedIndexes.contains(index)) {
        _selectedIndexes.remove(index);
      } else {
        _selectedIndexes.add(index);
      }
    });
  }

  // Hàm gửi ảnh đã chọn
  Future<void> sendSelectedImages() async {
    var accountModel = Provider.of<AccountModel>(context, listen: false);
    selectedImages =  _selectedIndexes.map((index) => accountModel.fullImage[index].link).toList();
  }

  @override
  Widget build(BuildContext context) {
    var accountModel = Provider.of<AccountModel>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("Chọn ảnh"),
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
            icon: Icon(Icons.phone_android, size: 30),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator()) // Hiển thị loading
          : Column(
        children: [
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: accountModel.fullImage.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemBuilder: (context, index) {
                final imagePath = accountModel.fullImage[index].link;
                final isSelected = _selectedIndexes.contains(index);

                return GestureDetector(
                  onTap: () => toggleSelection(index),
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.red,
                          image: DecorationImage(
                            image: NetworkImage(imagePath),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      if (isSelected)
                        Positioned(
                          top: 5,
                          right: 5,
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: const BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: _isUploading ? null : () async {
              setState(() {
                _isUploading = true; // Bắt đầu upload
              });

              DateTime now = DateTime.now();
              DateTime vietnamTime = now.toUtc().add(Duration(hours: 7));
              for (int i = 0; i < images!.length; i++) {
                CreatePicture createPicture = CreatePicture(
                  userId: accountModel.idUser,
                  locationId: "5f8a5e7f575d7a2b9c0d47e5",
                  visitId: "5f8a5e7f575d7a2b9c0d47e5",
                  journeyId: "5f8a5e7f575d7a2b9c0d47e5",
                  link: images![i].path,
                  capturedAt: vietnamTime,
                  isTakenByCamera: false,
                );
                List<Picture>? picture = await upLoadImage(createPicture);
                print("Server link: ${picture![0].link}");
                selectedImages.add(picture[0].link);
              }

              await sendSelectedImages();
              setState(() {
                _isUploading = false; // Kết thúc upload
              });
              Navigator.pop(context, selectedImages);
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(
                  _isUploading ? Colors.grey : Colors.blue),
              foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
            ),
            child: _isUploading
                ? const CircularProgressIndicator(
              color: Colors.white,
            )
                : const Text("Gửi ảnh đã chọn", style: TextStyle(fontSize: 20)),
          ),

        ],
      ),
    );
  }
}
