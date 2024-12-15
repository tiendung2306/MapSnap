import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Model/Token_2.dart';
import 'accountModel.dart';

Timer? refreshTimer;

void startAutoRefreshToken(BuildContext context,DateTime token_access_expires, String token_refresh, String idUser ) {
  // Tính toán thời gian còn lại trước khi token hết hạn
  final DateTime now = DateTime.now();
  final Duration timeLeft = token_access_expires.difference(now);

  // Đặt thời gian làm mới trước khi hết hạn 10 giây
  const bufferTime = Duration(seconds: 10);
  Duration refreshDuration = timeLeft - bufferTime;

  // Đảm bảo thời gian làm mới không âm
  if (refreshDuration.isNegative) {
    refreshDuration = Duration.zero;
  }

  print('Token sẽ được làm mới sau: ${refreshDuration.inSeconds} giây');

  refreshTimer?.cancel(); // Hủy bỏ timer cũ nếu có
  refreshTimer = Timer(refreshDuration, () async {
    await refreshTokenFunction(idUser, token_refresh, context);
  });
}

Future<void> refreshTokenFunction(String userId, String Tokenrefresh, BuildContext context) async {
  Token? newToken = await refreshToken(userId, Tokenrefresh, context);
  final prefs = await SharedPreferences.getInstance();
  if (newToken != null) {
    print("Token đã được làm mới thành công!");
    await prefs.setString('token', jsonEncode(newToken.toJson()));
    startAutoRefreshToken(context, newToken.token_access_expires, newToken.token_refresh, userId); // Tự động làm mới lại với token mới
  } else {
    await prefs.setBool('isLoggedIn', false);
    print("Không thể làm mới token.");
  }
}


Future<Token?> refreshToken(String userId, String refreshToken, BuildContext context) async {
  final url = Uri.parse('http://10.0.2.2:3000/v1/auth/refresh-tokens');
  final response = await http.post(
    url,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'refreshToken': refreshToken,
    }),
  );
  if (response.statusCode == 200) {
    var data = jsonDecode(response.body);
    Token newToken = Token(
      token_access: data['access']['token'] ?? 'NoTokenAccess',
      token_access_expires: DateTime.parse(data['access']['expires']),
      token_refresh: data['refresh']['token'] ?? 'NoTokenRefresh',
      token_refresh_expires: DateTime.parse(data['refresh']['expires']),
      idUser: userId,
    );
    // Cập nhật accountModel với token mới
    var accountModel = Provider.of<AccountModel>(context, listen: false);
    accountModel.setToken(newToken);
    print('Token mới đã được cập nhật vào accountModel.');
    return newToken;
  } else {
    print('Lỗi: ${response.statusCode}');
  }
  return null;
}
