import 'dart:convert';

import 'package:case_study/Service/api_services.dart';
import 'package:case_study/Views/HomeView/home_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import "package:http/http.dart" as http;

final loginViewModelProvider =
    StateNotifierProvider<LoginViewModel, AsyncValue<Map<String, dynamic>>>(
  (ref) => LoginViewModel(),
);

class LoginViewModel extends StateNotifier<AsyncValue<Map<String, dynamic>>> {
  LoginViewModel() : super(const AsyncData({}));

  Future<void> login(
      String email, String password, BuildContext context) async {
    state = const AsyncLoading();
    try {
      // API çağrısı
      final response = await http.post(
        Uri.parse('https://reqres.in/api/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final token = responseData['token'];
        print("burdayim");

        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const HomeView()));

        // Token'ı güvenli bir şekilde sakla
        await SecureStorage.saveToken(token);

        // Başarı durumunda state güncellemesi
        state = AsyncData(responseData);
      } else {
        throw Exception('Failed to login');
      }
    } catch (e) {
      // Hata durumunda state güncellemesi
    }
  }
}
