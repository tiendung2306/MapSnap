import 'package:flutter/material.dart';

class ResizableWidget extends StatefulWidget {
  const ResizableWidget({
    super.key,
    required this.label,
    required this.controller,
  });

  final String label;
  final TextEditingController controller;


  @override
  _ResizableWidgetState createState() => _ResizableWidgetState();
}

class _ResizableWidgetState extends State<ResizableWidget> {
  double _width = 150; // Chiều rộng ban đầu của widget
  double _height = 150; // Chiều cao ban đầu của widget

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Resizable Widget")),
      body: Center(
        child: Stack(
          children: [
            Container(
              width: _width,
              height: _height,
              color: Colors.blueAccent,
              alignment: Alignment.topRight,
              child: Text(
                "Drag to Resize",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
            Positioned(
              left: 0,
              top: 0,
              child: GestureDetector(
                onPanUpdate: (details) {
                  setState(() {
                    // _width -= details.delta.dx;
                    _height -= details.delta.dy;
                  });
                },
                child: Container(
                  width: 20,
                  height: 20,
                  color: Colors.red,
                  child: Icon(Icons.drag_handle, color: Colors.white, size: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


