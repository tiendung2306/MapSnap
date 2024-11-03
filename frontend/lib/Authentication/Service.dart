import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class AuthService {
  final _storage = FlutterSecureStorage();
  final _baseUrl = 'http://localhost:3000/v1';

  Future<void> saveTokens(String accessToken, String refreshToken) async {
    await _storage.write(key: 'access_token', value: accessToken);
    await _storage.write(key: 'refresh_token', value: refreshToken);
  }

  Future<String?> getAccessToken() async {
    return await _storage.read(key: 'access_token');
  }

  Future<String?> getRefreshToken() async {
    return await _storage.read(key: 'refresh_token');
  }

  Future<void> clearTokens() async {
    await _storage.deleteAll();
  }

  Future<bool> login(String username, String password) async {
    final url = Uri.parse('$_baseUrl/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'username': username, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      await saveTokens(data['access_token'], data['refresh_token']);
      return true;
    } else {
      return false;
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

  Future<http.Response> fetchProtectedData() async {
    String? accessToken = await getAccessToken();
    final url = Uri.parse('$_baseUrl/protected');
    var response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    if (response.statusCode == 401) {
      bool success = await refreshAccessToken();
      if (success) {
        accessToken = await getAccessToken();
        response = await http.get(
          url,
          headers: {'Authorization': 'Bearer $accessToken'},
        );
      } else {
        await clearTokens();
        throw Exception("Refresh token expired, please log in again");
      }
    }
    return response;
  }
}
