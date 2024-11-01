import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mapsnap_fe/Widget//text_field_input.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Widget/accountModel.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:mapsnap_fe/Widget/UpdateUser.dart';
import '../main.dart';



class accountScreen extends StatefulWidget {
  const accountScreen({Key? key}) : super(key: key);

  @override
  State<accountScreen> createState() => _accountScreenState();
}

class _accountScreenState extends State<accountScreen> {
  XFile? _image; // Biến lưu trữ ảnh đã chọn

  late TextEditingController usernameController;
  late TextEditingController emailController;
  late TextEditingController addressController ;
  final TextEditingController numberPhoneController = TextEditingController();

  String Notification = "";
  late Color colorNotification;


  //List giới tính
  final List<String> sex = [
    'Male',
    'Female',
    'Transsexual Male',
    'Transsexual Female',
    'Metrosexual Male',
    'Metrosexual Female',
    'Male, But Curious What Being a Female is Like',
    'Female, But Curious What Being a Male is Like',
    'Male. But Overweight. So Have Moobs',
    'Hermaphrodite with Predominant Male Leanings',
    'Hermaphrodite with Predominant Female Leanings',
    'Conjoined Twin-Male',
    'Conjoined Twin-Female',
    'Bom Without Genitals-Identify as Male',
    'Bom Without Genitals-Identify as Female',
    'Household Pet That Walked Across the Keyboard',
    'SÚC VẬT',
    'ĐCM TK NÀO NGHĨ RA MẤY CÁI NÀY V',
  ];


  String sexController = 'Chọn giới tính của bạn';

  void initState() {
    super.initState();
    _loadImage();
    var accountModel = Provider.of<AccountModel>(context, listen: false);
    usernameController = TextEditingController(text: accountModel.username);
    emailController = TextEditingController(text: accountModel.email);
    addressController = TextEditingController(text: accountModel.address);
    _loadUserData();  // Tải dữ liệu khi khởi tạo màn hình
  }


  // Hàm load ảnh lưu cục bộ
  Future<void> _loadImage() async {
    final prefs = await SharedPreferences.getInstance();
    final imagePath = prefs.getString('imagePath'); // Lấy đường dẫn ảnh
    if (imagePath != null) {
      setState(() {
        _image = XFile(imagePath); // Chuyển đường dẫn thành XFile
      });
    }
  }

  Future<void> _onProfileTapped() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _image = image;
        Provider.of<AccountModel>(context, listen: false)
            .updateImage(image);
      });
      // Lưu đường dẫn ảnh vào SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('imagePath', image.path);
    }
  }


  // Hàm để tải dữ liệu từ SharedPreferences
  _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      sexController = prefs.getString('sex') ?? '';
      numberPhoneController.text = prefs.getString('numberPhone') ?? '';
    });
  }

  // Hàm để lưu dữ liệu vào SharedPreferences
  _saveUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('numberPhone', numberPhoneController.text);
  }

  //Lưu giới tính trong bộ nhớ cục bộ
  _saveSexData(String sex) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('sex', sexController);
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: true,
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
                                color: Colors.grey,
                                image: _image != null
                                  ? DecorationImage(
                                    image: FileImage(File(_image!.path)), // Sử dụng FileImage để hiển thị ảnh
                                    fit: BoxFit.cover,
                                  )
                                  : null,
                                ),
                                child: _image == null
                                 ? Center(
                                    child: Icon(
                                    Icons.person_2_rounded,
                                    color: Colors.black12,
                                    size: 60,
                                  ),
                                )
                                : null,
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: GestureDetector(
                              onTap: () {
                                print("Thay ảnh đại diện");
                                _onProfileTapped();
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
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Giới tính", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                const SizedBox(height: 5),
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  width: screenWidth,
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton2 (
                                      isExpanded: true,
                                      dropdownStyleData:const DropdownStyleData(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                          ),
                                        maxHeight: 200,
                                      ),
                                      value: sexController == 'Chọn giới tính của bạn' ? null : sexController,
                                      hint: Text(sexController),
                                      iconStyleData: IconStyleData(
                                        icon: Icon(Icons.arrow_drop_down), // Biểu tượng mũi tên
                                        iconSize: 30,
                                      ),
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          sexController = newValue!;
                                        });
                                        _saveSexData(newValue!);
                                      },
                                      items: sex.map<DropdownMenuItem<String>>((String sex) {
                                        return DropdownMenuItem<String>(
                                          value: sex,
                                          child: Text(sex),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
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
                          onTap:  () async {
                           if (!RegExp(r'^[a-zA-Z0-9._%+-]+@gmail\.com$').hasMatch(emailController.text)) {
                              Notification = "Nhập sai gmail rồi";
                              colorNotification = Colors.red;
                            } else if (!RegExp(r'^[0-9]+$').hasMatch(numberPhoneController.text)) {
                              Notification = "Nhập sai số điện thoại rồi";
                              colorNotification = Colors.red;
                            } else if (numberPhoneController.text.length != 10) {
                              Notification = "Nhập sai số điện thoại rồi";
                              colorNotification = Colors.red;
                            } else {
                              // Nếu tất cả đều hợp lệ, lưu dữ liệu
                              var accountModel = Provider.of<AccountModel>(context, listen: false);
                              Notification = "Lưu thông tin thành công";
                              colorNotification = Colors.blue;
                              // Cập nhật dữ liệu lên database
                              await updateUser(accountModel.idUser,usernameController.text,emailController.text,addressController.text,accountModel.token_access);
                              //Tạo 1 biến User
                              User updatedUser = User(
                                idUser: accountModel.idUser,
                                username: usernameController.text,
                                email: emailController.text,
                                address: addressController.text,
                                password: accountModel.password, // Giữ nguyên mật khẩu cũ
                                role: accountModel.role,  //  Giữ nguyên vai trò
                              );
                              //Cập nhật biến User mới vừa đẩy lên database
                              accountModel.setUser(updatedUser);

                              _saveUserData();
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
