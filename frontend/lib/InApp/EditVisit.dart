import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../Model/Visit.dart';
import '../Services/APIService.dart';
import '../Widget/accountModel.dart';
import 'Point.dart';

class EditvisitScreen extends StatefulWidget {
  final String journeyID;

  const EditvisitScreen({Key? key, required this.journeyID}) : super(key: key);

  @override
  State<EditvisitScreen> createState() => _EditvisitScreenState();
}

class _EditvisitScreenState extends State<EditvisitScreen> {
  final  _apiService = ApiService();

  List<Visit> visits = [];

  bool isDataLoad = true;

  void loadData() async {
    final response = await _apiService.GetJourney(widget.journeyID);
    final data = response["data"]["result"];

    for (var visitId in data['visitIds']) {
      final visit_response = await _apiService.GetVisit(visitId);
      visits.add(Visit.fromJson(visit_response["data"]["result"]));
    }

    setState(() {
      isDataLoad = true;
    });
  }

  void initState() {
    super.initState();
    loadData();
  }

  Container LoadingScreen(){
    return Container(
      color: Colors.white,
      child: Center(
        child: Text(
            'Loading'
        ),
      ),
    );
  }

  Widget Screen(){
    return Scaffold(
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/Common/Background.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.only(top: 50),
            child: Column(
              children: [
                // Các feature
                Container(
                  width: double.infinity,
                  color: Colors.white,
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        height: 50,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            IconButton(
                              onPressed: (){
                                Navigator.pop(context);
                              },
                              icon: Icon(Icons.arrow_back),
                            ),
                            Text(
                              'Visits',
                              style: TextStyle(
                                  fontSize: 20
                              ),
                            ),
                            IconButton(
                              onPressed: (){} ,
                              icon: Icon(Icons.account_circle),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // Hiệu ứng đổ bóng
                Container(
                  height: 5, width: double.infinity,
                  color: Colors.white,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,  // Bắt đầu gradient từ trên
                        end: Alignment.bottomCenter, // Kết thúc gradient ở dưới
                        colors: [
                          Colors.grey.withOpacity(1.0), // Màu ở trên cùng, với độ mờ
                          Colors.grey.withOpacity(0.0), // Màu ở dưới cùng, nhạt hơn
                        ],
                      ),
                    ),
                  ),
                ),

                Expanded(
                  child: ListView.builder(
                    itemCount: visits.length,
                    itemBuilder: (context, index) {
                      return VisitItem(visit: visits[index],);
                    },
                  ),
                ),
              ],
            ),
          ),
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: !isDataLoad ?
      LoadingScreen():
      Screen(),
    );
  }

}


class VisitItem extends StatefulWidget {
  const VisitItem({
    super.key,
    required this.visit,
    this.editFunc,
    // required this.icon,
  });
  final Visit visit;
  final Function(int)? editFunc;
  // final String icon;

  @override
  _VisitItemState createState() => _VisitItemState();
}

class _VisitItemState extends State<VisitItem> {
  late Color color = Colors.blue;

  final List<String> imageUrls = [
    "https://picsum.photos/200/300?random=1",
    "https://picsum.photos/200/300?random=2",
    "https://picsum.photos/200/300?random=3",
    "https://picsum.photos/200/300?random=4",
    "https://picsum.photos/200/300?random=5",
  ];

  String period(){
    DateTime startTime = DateTime.fromMillisecondsSinceEpoch(widget.visit.startedAt);
    String startformattedTime = DateFormat('HH:mm - ').format(startTime);
    String dayformattedTime = DateFormat('dd/MM/yyyy: ').format(startTime);

    DateTime endTime = DateTime.fromMillisecondsSinceEpoch(widget.visit.endedAt);
    String endformattedTime = DateFormat('HH:mm').format(endTime);

    return dayformattedTime + startformattedTime + endformattedTime;
  }

  void add(int index, String url){
    setState(() {
      imageUrls.insert(index + 1, url);
    });
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
                  color: color,
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
          Container(
            alignment: Alignment.topLeft,
            child: Text(
              period(),
              style: TextStyle(
                  fontSize: 20
              ),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              widget.visit.title,
              style: TextStyle(
                fontSize: 25
              ),
            ),
          ),
          Container(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: imageUrls.length,
              itemBuilder: (context, index) {
                return ImageItem(index: index, url: imageUrls[index], visit: widget.visit, addFunc: add,);
              },
            ),
          ),
          SizedBox(height: 30,)
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        children: [
          lead(),

          body()
        ],
      ),
    );
  }
}

class ImageItem extends StatefulWidget {
  final int index;
  final Visit visit;
  final String url;
  final Function(int, String) addFunc;
  const ImageItem({super.key,required this.index, required this.url, required this.visit, required this.addFunc});

  @override
  State<ImageItem> createState() => _ImageItemState();
}

class _ImageItemState extends State<ImageItem> {
  bool isExtend = false;

  Future<void> add() async {
    final  _apiService = ApiService();
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if(image != null){
      var accountModel = Provider.of<AccountModel>(context, listen: false);
      DateTime now = DateTime.now();
      int epochMilliseconds = now.millisecondsSinceEpoch;
      final response = await _apiService.UploadPicture(accountModel.idUser, widget.visit.journeyId,
          widget.visit.id, widget.visit.journeyId, epochMilliseconds, image!);
      widget.addFunc(widget.index, response["data"]["link"]);
    }
  }

  void delete(){
    //need fix
  }
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        setState(() {
          isExtend = !isExtend;
        });;
      },
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 5),
            child: Container(
              width: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                    image: NetworkImage(widget.url),
                    fit: BoxFit.cover
                ),
              ),
            ),
          ),
          if(isExtend)
            Column(
              children: [
                IconButton(
                  onPressed: (){
                    showDialog(
                      context: context,
                      builder: (context) {
                        return Dialog(
                          child: Image.network(
                            widget.url,
                            fit: BoxFit.contain,
                          ),
                        );
                      },
                    );
                  },
                  icon: Icon(Icons.camera_alt),
                ),
                IconButton(
                  onPressed: (){
                    add();
                  },
                  icon: Icon(Icons.add),
                ),
                IconButton(
                  onPressed: (){},
                  icon: Icon(Icons.edit),
                ),
                IconButton(
                  onPressed: (){},
                  icon: Icon(Icons.delete),
                ),
              ],
            )
        ],
      ),
    );
  }
}


