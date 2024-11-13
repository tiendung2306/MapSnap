class User {
  String idUser;
  String username;
  String email;
  String role;
  String address;
  String avatar;
  String numberPhone;

  //Cập nhật constructor để avatar có giá trị mặc định
  User({
    required this.username,
    required this.email,
    required this.role,
    required this.address,
    required this.idUser,
    required this.avatar,
    required this.numberPhone,
  });


  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json['username'] ?? 'NoUsername',
      email: json['email'] ?? 'NoEmail',
      role: json['role'] ?? 'NoRole',
      address: json['address'] ?? 'NoAddress',
      idUser: json['id'] ?? 'NoID',
      avatar: json['avatar'] ?? "",
      numberPhone: json['phoneNumber'] ?? 'ghghgh',
    );
  }
}