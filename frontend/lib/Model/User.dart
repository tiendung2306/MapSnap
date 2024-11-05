import 'Token.dart';

class User {
  final String id;
  final String email;
  final String username;
  final String role;
  final Token accessToken;
  final Token refreshToken;

  User({
    required this.id,
    required this.email,
    required this.username,
    required this.role,
    required this.accessToken,
    required this.refreshToken
  });

  Map<String, dynamic> toJson() {
    return {
      'id' :  id,
      'email' :  email,
      'username' :  username,
      'role' :  role,
      'accessToken' :  accessToken.toJson(),
      'refreshToken' : refreshToken.toJson()
    };
  }

  // Chuyển đổi từ Map (decode JSON) sang User
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        id: json['user']['id'],
        email: json['user']['email'],
        username: json['user']['username'],
        role: json['user']['role'],
        accessToken: Token.fromJson(json['tokens']['access']),
        refreshToken: Token.fromJson(json['tokens']['refresh'])
    );
  }
}

