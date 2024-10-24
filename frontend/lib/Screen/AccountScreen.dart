import 'package:flutter/material.dart';
import 'package:mapsnap_fe/Widget//text_field_input.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Widget/accountModel.dart';
import 'settingScreen.dart';

class accountScreen extends StatefulWidget {
  const accountScreen({Key? key}) : super(key: key);

  @override
  State<accountScreen> createState() => _accountScreenState();
}

class _accountScreenState extends State<accountScreen> {
  late TextEditingController usernameController;
  late TextEditingController emailController;
  final TextEditingController addressController = TextEditingController();
  final TextEditingController numberPhoneController = TextEditingController();
  String Notification = "";
  late Color colorNotification;


  void initState() {
    super.initState();
    var accountModel = Provider.of<AccountModel>(context, listen: false);
    usernameController = TextEditingController(text: accountModel.username);
    emailController = TextEditingController(text: accountModel.email);
    _loadUserData();  // Tải dữ liệu khi khởi tạo màn hình
  }

  // Hàm để tải dữ liệu từ SharedPreferences
  _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      usernameController.text = prefs.getString('username') ?? '';
      emailController.text = prefs.getString('email') ?? '';
      addressController.text = prefs.getString('address') ?? '';
      numberPhoneController.text = prefs.getString('numberPhone') ?? '';
    });
  }

  // Hàm để lưu dữ liệu vào SharedPreferences
  _saveUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', usernameController.text);
    await prefs.setString('email', emailController.text);
    await prefs.setString('address', addressController.text);
    await prefs.setString('numberPhone', numberPhoneController.text);
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
          child: SingleChildScrollView(
            child: Stack(
              children: [
                Container(
                  width: screenWidth,
                  color: Colors.white,
                  height: screenHeight,
                ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: screenWidth / 15),
                width: double.infinity,
                color: Colors.white,
                child: Column(
                  children: [
                    SizedBox(height: screenHeight / 70),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            FocusScope.of(context).unfocus();
                            // Khoảng trễ cho dòng code tiếp theo
                            await Future.delayed(Duration(milliseconds: 500));
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
                            "Tài khoản",
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
                    SizedBox(height: screenHeight / 70),
                    Container(
                      width: 130,
                      height: 140,
                      child: Stack(
                        fit: StackFit.loose,
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.red,
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: GestureDetector(
                              onTap: () {
                                print("Thay ảnh đại diện");
                              },
                              child: Container(
                                width: screenWidth / 10,
                                height: screenWidth / 10,
                                decoration: BoxDecoration(
                                  color: Color(0xFFEAEAEA),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.camera_alt,
                                  size: screenWidth / 15,
                                  color: Color(0xFFFFA150),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: screenHeight / 70),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        padding:
                        EdgeInsets.symmetric(horizontal: screenWidth / 10),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            buildTextField("Tên", usernameController, "Nhập tên của bạn", TextInputType.text),
                            const SizedBox(height: 15),
                            buildTextField("Email", emailController, "Nhập email của bạn", TextInputType.emailAddress),
                            const SizedBox(height: 15),
                            buildTextField("Địa chỉ", addressController, "Nhập địa chỉ của bạn", TextInputType.text),
                            const SizedBox(height: 15),
                            buildTextField("Số điện thoại", numberPhoneController, "Nhập sđt của bạn", TextInputType.number),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 50),

                    Material(
                      color: Colors.blueAccent,
                      borderRadius: BorderRadius.circular(15),
                      child: InkWell(
                          onTap: () {
                            if(usernameController.text.isEmpty) {
                              Notification = "Chưa nhập tên";
                              colorNotification = Colors.red;
                            } else if (!RegExp(r'^[a-zA-Z0-9._%+-]+@gmail\.com$').hasMatch(emailController.text)) {
                              Notification = "Nhập sai gmail rồi";
                              colorNotification = Colors.red;
                            } else if (addressController.text.isEmpty) {
                              Notification = "Chưa nhập địa chỉ";
                              colorNotification = Colors.red;
                            } else if (!RegExp(r'^[0-9]+$').hasMatch(numberPhoneController.text)) {
                              Notification = "Nhập sai số điện thoại rồi";
                              colorNotification = Colors.red;
                            } else if (numberPhoneController.text.length != 10) {
                              Notification = "Nhập sai số điện thoại rồi";
                              colorNotification = Colors.red;
                            } else {
                              // Nếu tất cả đều hợp lệ, lưu dữ liệu
                              Notification = "Lưu thông tin thành công";
                              colorNotification = Colors.blue;
                              _saveUserData();
                              Provider.of<AccountModel>(context, listen: false)
                                  .updateUsername(usernameController.text);
                              Provider.of<AccountModel>(context, listen: false)
                                  .updateEmail(emailController.text);
                            }

                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  backgroundColor: Colors.white,
                                  title: const Text("Thông báo", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),),
                                  content: Text(Notification, style: TextStyle(fontSize: 20,)),
                                  actions: <Widget>[
                                    new ElevatedButton(
                                      child: new Text('OK', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),),
                                      style: TextButton.styleFrom(
                                        backgroundColor: colorNotification,
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    )
                                  ],
                                );
                              },
                            );
                          },
                          splashColor: Colors.white.withOpacity(0.2),
                          child: Container(
                            width: screenWidth * 2 / 3,
                            height: 50,
                            child: Center(
                              child: Text("Lưu thay đổi", style: TextStyle(color: Colors.white,
                                  fontSize: 20, fontWeight: FontWeight.bold),),
                            ),
                          )
                      ),
                    ),
                  ],
                ),
              ),
              ]
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String label, TextEditingController controller, String hintText, TextInputType inputType) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 3),
        TextFieldInput(
          textEditingController: controller,
          hintText: hintText,
          textInputType: inputType,
        ),
      ],
    );
  }
}
