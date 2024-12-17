import 'package:flutter/material.dart';


class NonExpandListTile extends StatefulWidget {
  const NonExpandListTile({
    super.key,
    required this.type,
    required this.index,
    required this.title,
    required this.subtitle,
    required this.content,
    required this.onTapFunc,
    required this.addDelFunc,
    // required this.icon,
  });
  final String type;
  final int index;
  final String title;
  final String subtitle;
  final String content;
  final Function(int) onTapFunc;
  final Function(int, bool) addDelFunc;
  // final String icon;

  @override
  _NonExpandListTileState createState() => _NonExpandListTileState();
}

class _NonExpandListTileState extends State<NonExpandListTile> {
  final Color color = Colors.orange;

  void onTap(){
    widget.onTapFunc(widget.index);
  }

  void addordel(){
    widget.addDelFunc(widget.index, false);
    widget.onTapFunc(widget.index);
  }


  Container lead(){
    return Container(
      width: 50,
      // color: Colors.grey,
      child: Column(
        children: [
          SizedBox(height: 5,),
          if(widget.type == 'visit')
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                    color: color,
                    width: 3
                ),
              ),
              child: Center(
                // Vòng tròn nhỏ bên trong
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: color, // Màu nền xanh lá đậm
                  ),
                ),
              ),
            ),
          Expanded(
            child: Container(
              width: 3, color: color,
            ),
          )
        ],
      ),
    );
  }

  Expanded body(){
    return Expanded(
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 200,
                child: Text(
                  widget.title,
                  style: TextStyle(
                      fontSize: 20
                  ),
                ),
              ),
              Expanded(child: Container()),

              ElevatedButton.icon(
                onPressed: addordel,
                icon: widget.type == 'visit' ? Icon(Icons.remove) : Icon(Icons.add),
                label: Text(
                  widget.type == 'visit' ? "Delete visit" : "Add visit",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  // padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  backgroundColor: Colors.white,
                  shadowColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              )
            ],
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              widget.subtitle,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: onTap,
      child: IntrinsicHeight(
        child: Row(
          children: [
            lead(),

            body()
          ],
        ),
      ),
    );
  }
}
