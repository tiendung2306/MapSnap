

import 'package:flutter/material.dart';
import 'package:mapsnap_fe/NewFeed/ImageFullScreen.dart';

import '../Model/Picture.dart';

class Imagelocationscreen extends StatefulWidget {
  List<Picture> listPicture;
  String nameLocation;
  Imagelocationscreen({required this.listPicture,required this.nameLocation,Key? key}) : super(key: key);

  @override
  State<Imagelocationscreen> createState() => _ImagelocationscreenState();
}

class _ImagelocationscreenState extends State<Imagelocationscreen> {

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
        title: Text(widget.nameLocation, style: TextStyle(fontSize: 27,fontWeight: FontWeight.bold),),
      ),
      body: Expanded(
        child: GridView.builder(
          padding: const EdgeInsets.all(10),
          itemCount: widget.listPicture.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemBuilder: (context, index) {
            final imagePath = widget.listPicture[index].link;
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ImageFullScreen(image: imagePath),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.red,
                  image: DecorationImage(
                    image: NetworkImage(imagePath),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
