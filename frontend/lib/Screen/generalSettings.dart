import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dropdown_button2/dropdown_button2.dart';


class generalSettings extends StatefulWidget {
  const generalSettings({Key? key}) : super(key: key);

  @override
  State<generalSettings> createState() => _generalSettingsState();
}

class _generalSettingsState extends State<generalSettings> {

  // 3 Cái này dùng để lưu giá trị được chọn và khởi tại cho nó làm giá trị khởi tạo để khi thoát ra cũng không mấy dữ liệu
  //=======================================================================
  void initState() {
    super.initState();
    // _loadUserData();
  }

  _loadUserData() async {
    SharedPreferences prefs2 = await SharedPreferences.getInstance();
    setState(() {
      selectedCountry = prefs2.getString('country') ?? '';
    });
  }

  _saveUserData(String country) async {
    SharedPreferences prefs2 = await SharedPreferences.getInstance();
    await prefs2.setString('country', country);
  }
//=====================================================================

  final List<String> countries = [
    'United States',
    'Canada',
    'Germany',
    'France',
    'Japan',
    'Việt Nam',
    'Australia',
    'India',
  ];

  String selectedCountry = "Việt Nam";
  bool isSwitched = false;

  void toggleSwitch(bool value) {

    if(isSwitched == false)
    {
      setState(() {
        isSwitched = true;
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              backgroundColor: Colors.white,
              title: const Text("Thông báo", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),),
              content: Text("Tính năng đang được phát triển", style: TextStyle(fontSize: 20,)),
              actions: <Widget>[
                new ElevatedButton(
                  child: new Text('OK', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    setState(() {
                      isSwitched = false;
                    });
                  },
                )
              ],
            );
          },
        );
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        onTap: () {
          // Bỏ chọn tất cả các TextField khi bấm ra ngoài
          FocusScope.of(context).unfocus();
        },
        child: SafeArea(
          // Màn hình di chuyển khi hiện bàn phím ảo che phần nhập
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: screenWidth / 15),
            width: double.infinity,
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: screenHeight / 70),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        Navigator.pop(context);
                        },
                      child: Container(
                        width: screenWidth / 8,
                        height: screenWidth / 8,
                        child: Icon(
                          Icons.keyboard_arrow_left,
                          size: screenWidth / 8,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Container(
                      child: Text(
                        "Cài đặt chung",
                        style: TextStyle(fontSize: 30),
                      ),
                    ),
                    Container(
                      width: screenWidth / 8,
                      height: screenWidth / 8,
                      child: GestureDetector(
                        onTap: () {
                          print("Tìm kiếm");
                          },
                        child: Icon(
                            Icons.search,
                          size: screenWidth / 8,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: screenHeight / 50),
                const Text("Ngôn ngữ", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                const SizedBox(height: 7),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      width: screenWidth,
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton2 (
                          isExpanded: true,
                          dropdownStyleData:DropdownStyleData(
                            decoration: BoxDecoration(
                              color: Colors.white,
                            )
                          ),
                          value: selectedCountry == "Việt Nam" ? null : selectedCountry,
                          hint: Text(selectedCountry),
                          iconStyleData: IconStyleData(
                            icon: Icon(Icons.arrow_drop_down), // Biểu tượng mũi tên
                            iconSize: 30,
                          ),
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedCountry = newValue!;
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    backgroundColor: Colors.white,
                                    title: const Text("Thông báo", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),),
                                    content: Text("Tính năng đang được phát triển", style: TextStyle(fontSize: 20,)),
                                    actions: <Widget>[
                                      new ElevatedButton(
                                        child: new Text('OK', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),),
                                        style: TextButton.styleFrom(
                                          backgroundColor: Colors.blue,
                                        ),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          setState(() {
                                            isSwitched = false;
                                          });
                                        },
                                      )
                                    ],
                                  );
                                },
                              );
                            });
                            // _saveUserData(newValue!);    // Mở cmt để lưu giá trị để khi thoát ra thì không mất dữ liệu
                          },
                          items: countries.map<DropdownMenuItem<String>>((String country) {
                            return DropdownMenuItem<String>(
                              value: country,
                              child: Text(country),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Bản tối", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
                    Switch(
                        value: isSwitched,
                        onChanged: toggleSwitch,
                        activeColor: Colors.red,    //được sử dụng để chỉ định màu của công tắc bóng tròn khi nó BẬT
                        activeTrackColor: Colors.black54,     //Nó chỉ định màu thanh chuyển hướng.
                        inactiveThumbColor: Colors.blue,    //Nó được sử dụng để chỉ định màu của công tắc bóng tròn khi nó TẮT.
                        inactiveTrackColor: Colors.white,      //Nó chỉ định màu thanh công tắc khi nó TẮT.
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
