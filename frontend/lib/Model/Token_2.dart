class Token {
  String token_access;
  String token_access_expires;
  String token_refresh;
  String token_refresh_expires;
  String idUser;

  Token({
    required this.token_access,
    required this.token_access_expires,
    required this.token_refresh,
    required this.token_refresh_expires,
    required this.idUser,
  });


  factory Token.fromJson(Map<String, dynamic> json) {
    return Token(
      token_access: json['tokens']['access']['token'] ?? 'NoTokenAccess',
      token_access_expires: json['tokens']['access']['expires'] ?? 'NoTokenAccessExpires',
      token_refresh: json['tokens']['refresh']['token'] ?? 'NoTokenRefresh',
      token_refresh_expires: json['tokens']['refresh']['expires'] ?? 'NoTokenRefreshExpires',
      idUser: json['user']['id'] ?? 'NoID',
    );
  }
}