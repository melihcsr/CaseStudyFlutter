import 'dart:convert';
import 'package:case_study/Models/UserModel.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  static final _storage = FlutterSecureStorage();

  static Future<void> saveToken(String token) async {
    await _storage.write(key: 'auth_token', value: token);
  }

  static Future<String?> getToken() async {
    return await _storage.read(key: 'auth_token');
  }

  static Future<void> deleteToken() async {
    await _storage.delete(key: 'auth_token');
  }
}

class ApiService {
  final String _baseUrl = 'https://reqres.in/api/users';

  Future<UserModel> fetchUserData({int page = 1}) async {
    final response = await http.get(Uri.parse('$_baseUrl?page=$page'));

    if (response.statusCode == 200) {
      // If the server returns an OK response, parse the JSON
      return UserModel.fromJson(jsonDecode(response.body));
    } else {
      // If the server does not return an OK response, throw an exception
      throw Exception('Failed to load user data');
    }
  }
}
