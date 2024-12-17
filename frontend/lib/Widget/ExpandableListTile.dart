import 'package:flutter/material.dart';


class ExpandableListTile extends StatefulWidget {
  const ExpandableListTile({
    super.key,
    required this.type,
    required this.index,
    required this.isFocus,
    required this.title,
    required this.subtitle,
    required this.content,
    required this.onTapFunc,
    this.editFunc,
    // required this.icon,
  });
  final String type;
  final int index;
  final bool isFocus;
  final String title;
  final String subtitle;
  final String content;
  final Function(int) onTapFunc;
  final Function(int)? editFunc;
  // final String icon;

  @override
  _ExpandableListTileState createState() => _ExpandableListTileState();
}

class _ExpandableListTileState extends State<ExpandableListTile> {
  late Color color;

  @override
  void initState() {
    switch (widget.type) {
      case 'Tab1Visit':
        color = Colors.green;
        break;
      case 'Tab2Visit':
        color = Colors.blue;
        break;
      case 'Tab2Position':
        color = Colors.blue;
        break;
      case 'Tab3Visit':
        color = Colors.orange;
        break;
      case 'Tab3Position':
        color = Colors.orange;
        break;
      default:
    }
    super.initState();
  }

  void onTap(){
    widget.onTapFunc(widget.index);
  }

  void edit(){
    widget.editFunc!(widget.index);
  }

  Container lead(){
    return Container(
      width: 50,
      // color: Colors.grey,
      child: Column(
        children: [
          SizedBox(height: 5,),
          if(widget.type == 'Tab1Visit' || widget.type == 'Tab2Visit' || widget.type == 'Tab3Visit')
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
              if(widget.isFocus)
                Row(
                  children: [
                    if(widget.type == 'Tab1Visit' || widget.type == 'Tab2Visit' || widget.type == 'Tab3Visit')
                      IconButton(
                        onPressed: (){
                          edit();
                        },
                        icon: Icon(Icons.edit),
                      ),

                    IconButton(
                      onPressed: (){},
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
