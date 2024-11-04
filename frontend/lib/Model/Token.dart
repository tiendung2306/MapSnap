class Token {
  String token;
  String expires;

  Token({required this.token,required this.expires});

  Map<String, dynamic> toJson() {
    return {
      'token' :  token,
      'expires' :  expires,
    };
  }


  // Chuyển đổi từ Map (decode JSON) sang Token
  factory Token.fromJson(Map<String, dynamic> json) {
    return Token(
        token: json['token'],
        expires: json['expires'],
    );
  }
}