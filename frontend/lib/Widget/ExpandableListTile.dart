import 'package:flutter/material.dart';


class ExpandableListTile extends StatefulWidget {
  const ExpandableListTile({
    super.key,
    required this.index,
    required this.isFocus,
    required this.title,
    required this.subtitle,
    required this.content,
    required this.onTapFunc,
    // required this.icon,
  });
  final int index;
  final bool isFocus;
  final String title;
  final String subtitle;
  final String content;
  final Function(int) onTapFunc;
  // final String icon;

  @override
  _ExpandableListTileState createState() => _ExpandableListTileState();
}

class _ExpandableListTileState extends State<ExpandableListTile> {

  void onTap(){
    widget.onTapFunc(widget.index);
  }

  Container lead(){
    return Container(
      width: 50,
      // color: Colors.grey,
      child: Column(
        children: [
          SizedBox(height: 5,),
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                  color: Colors.green,
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
                  color: Colors.green, // Màu nền xanh lá đậm
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              width: 3, color: Colors.green,
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
              if(widget.isFocus)
                Row(
                  children: [
                    IconButton(
                        onPressed: (){print('vpa');},
                        icon: Icon(Icons.delete,),
                    ),
                    IconButton(
                      onPressed: (){print('vpa');},
                      icon: Icon(Icons.edit),
                    ),
                    IconButton(
                      onPressed: (){print('vpa');},
                      icon: Icon(Icons.keyboard_arrow_up)
                    ),
                  ],
                )
              else
                Icon(Icons.arrow_drop_down),
            ],
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              widget.subtitle,
            ),
          ),
          if(widget.isFocus)
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                widget.content,
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
