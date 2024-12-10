class Token {
  String token_access;
  DateTime token_access_expires;
  String token_refresh;
  DateTime token_refresh_expires;
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
      token_access_expires: DateTime.parse(json['tokens']['access']['expires']),
      token_refresh: json['tokens']['refresh']['token'] ?? 'NoTokenRefresh',
      token_refresh_expires: DateTime.parse(json['tokens']['refresh']['expires']),
      idUser: json['user']['id'] ?? 'NoID',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tokens': {
        'access': {
          'token': token_access,
          'expires': token_access_expires.toIso8601String(),
        },
        'refresh': {
          'token': token_refresh,
          'expires': token_refresh_expires.toIso8601String(),
        },
      },
      'user': {
        'id': idUser,
      },
    };
  }
}