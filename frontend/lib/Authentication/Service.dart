import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:mapsnap_fe/Authentication/VerifyEmail.dart';
import 'package:mapsnap_fe/Model/User.dart';
import 'package:mapsnap_fe/Model/Token.dart';

class AuthService {
  final _storage = FlutterSecureStorage();
  final _baseUrl = 'http://localhost:3000/v1';

  Future<void> save(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  Future<String?> get(String key) async {
    return await _storage.read(key: key);
  }

  Future<void> saveUser(User user) async {
    String userJson = jsonEncode(user.toJson());
    await _storage.write(key: 'user', value: userJson);
  }


  Future<void> saveAccessTokens(Token accessToken) async {
    String accesstokenJson = jsonEncode(accessToken.toJson());
    await _storage.write(key: 'access_token', value: accesstokenJson);
  }

  Future<Token> getAccessToken() async {
    String tokenjson =  await _storage.read(key: 'access_token') ?? 'null';
    return Token.fromJson(jsonDecode(tokenjson));
  }

  Future<void> saveRefreshTokens(String refreshToken) async {
    await _storage.write(key: 'access_token', value: refreshToken);
  }

  Future<void> saveTokens(String accessToken, String refreshToken) async {
    await _storage.write(key: 'access_token', value: accessToken);
    await _storage.write(key: 'refresh_token', value: refreshToken);
  }

  Future<String?> getRefreshToken() async {
    return await _storage.read(key: 'refresh_token');
  }

  Future<void> clearTokens() async {
    await _storage.deleteAll();
  }
  Future<bool> refreshAccessToken() async {
    final refreshToken = await getRefreshToken();
    if (refreshToken == null) return false;

    final url = Uri.parse('$_baseUrl/refresh-token');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'refresh_token': refreshToken}),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      await saveTokens(data['access_token'], data['refresh_token']);
      return true;
    } else {
      return false;
    }
  }

  Future<Map<String, dynamic>>  Login(String email, String password) async {
    final url = Uri.parse('$_baseUrl/auth/login');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          "email": email,
          "password": password
        }
        ),
      );
      return {
        'statusCode': response.statusCode,
        'data': json.decode(response.body),
      };

    } catch (e) {
      print('Error: $e');
      return {
        'statusCode': null,
        'data': null,
      };
    }
  }

  Future<Map<String, dynamic>>  Register(String username, String email, String password) async {
    final url = Uri.parse('$_baseUrl/auth/register');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
              "username": username,
              "email": email,
              "password": password
            }
        ),
      );
      return {
        'statusCode': response.statusCode,
        'data': json.decode(response.body),
      };

    } catch (e) {
      print('Error: $e');
      return {
        'statusCode': null,
        'data': null,
      };
    }
  }

  Future<Map<String, dynamic>>  SendPinCode(String email) async {
    final url = Uri.parse('$_baseUrl/auth/forgot-password');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          "email": email,
        }
        ),
      );
      return {
        'statusCode': response.statusCode,
        'data': json.decode(response.body),
      };

    } catch (e) {
      print('Error: $e');
      return {
        'statusCode': null,
        'data': null,
      };
    }
  }

  Future<Map<String, dynamic>>  VerifyEmail(String pinCode, String resetPasswordToken) async {
    final url = Uri.parse('$_baseUrl/auth/verify-pin-code');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          "pinCode": pinCode,
          "resetPasswordToken": resetPasswordToken
        }),
      );
      return {
        'statusCode': response.statusCode,
        'data': response.statusCode == 200 ? null : json.decode(response.body),
      };

    } catch (e) {
      print('Error: $e');
      return {
        'statusCode': null,
        'data': null,
      };
    }
  }

  Future<Map<String, dynamic>>  ResetPassword(String newPassword, String resetPasswordToken) async {
    final url = Uri.parse('$_baseUrl/auth/reset-password').replace(queryParameters: {'token' : resetPasswordToken});

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          "password": newPassword,
        }),
      );
      return {
        'statusCode': response.statusCode,
        'data': response.statusCode == 204 ? null : json.decode(response.body),
      };

    } catch (e) {
      print('Error: $e');
      return {
        'statusCode': null,
        'data': null,
      };
    }
  }
  //
  // Future<http.Response> fetchProtectedData() async {
  //   String? accessToken = await getAccessToken();
  //   final url = Uri.parse('$_baseUrl/protected');
  //   var response = await http.get(
  //     url,
  //     headers: {'Authorization': 'Bearer $accessToken'},
  //   );
  //
  //   if (response.statusCode == 401) {
  //     bool success = await refreshAccessToken();
  //     if (success) {
  //       accessToken = await getAccessToken();
  //       response = await http.get(
  //         url,
  //         headers: {'Authorization': 'Bearer $accessToken'},
  //       );
  //     } else {
  //       await clearTokens();
  //       throw Exception("Refresh token expired, please log in again");
  //     }
  //   }
  //   return response;
  // }
}
