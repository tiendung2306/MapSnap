import 'package:flutter/material.dart';

class outline_IconButton extends StatelessWidget {
  const outline_IconButton({
    super.key,
    required this.label,
    required this.color,
  });

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () {
        // Xử lý đăng nhập với Google
      },

      child: Stack(
        children: [
          Align(
              alignment: Alignment.centerLeft,
              child:Image.asset(
                ("assets/Login/" + this.label + "_icon.png"),
                height: 30,
                width: 30,
              )
          ),
          Align(
            alignment: Alignment.center,
            child: Text(
              this.label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: this.color,
              ),
            ),
          )
        ],
      ),

      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)
        ),
        minimumSize: Size(double.infinity, 60),
        side: BorderSide(
            color: this.color,
            width: 4
        ),
      ),
    );;
  }
}
