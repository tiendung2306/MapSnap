import 'package:flutter/material.dart';
import 'package:mapsnap_fe/NewFeed/ImageFullScreen.dart';

class FullScreenImageGallery extends StatelessWidget {
  final List<Map<String, String>> images;

  FullScreenImageGallery({required this.images});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView.builder(
        itemCount: images.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              // Khi người dùng nhấn vào ảnh, hiển thị ảnh phóng to
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ImageFullScreen(image: images[index]['url']!)
                ),
              );
            },
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              padding: EdgeInsets.all(10),
              child: Image.network(
                images[index]['url']!,
                fit: BoxFit.contain,  // Cách hiển thị ảnh
              ),
            ),
          );
        },
      ),
    );
  }
}
