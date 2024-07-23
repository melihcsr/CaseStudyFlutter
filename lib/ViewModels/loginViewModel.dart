import 'dart:convert';
import 'package:case_study/Service/api_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import "package:http/http.dart" as http;

final loginViewModelProvider =
    StateNotifierProvider<LoginViewModel, AsyncValue<Map<String, dynamic>>>(
  (ref) => LoginViewModel(),
);

final passwordVisibilityProvider =
    StateNotifierProvider<PasswordVisibilityNotifier, bool>(
  (ref) => PasswordVisibilityNotifier(),
);

class PasswordVisibilityNotifier extends StateNotifier<bool> {
  PasswordVisibilityNotifier() : super(true); // Başlangıçta şifre gizlenmiş

  void toggleVisibility() {
    state = !state; // Şifrenin gizlenme durumunu değiştirir
  }
}

class LoginViewModel extends StateNotifier<AsyncValue<Map<String, dynamic>>> {
  LoginViewModel() : super(const AsyncData({}));

  Future<void> login(String email, String password) async {
    state = const AsyncLoading();
    try {
      final response = await http.post(
        Uri.parse('https://reqres.in/api/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final token = responseData['token'];

        // Token'ı güvenli bir şekilde sakla
        await SecureStorage.saveToken(token);

        // Başarı durumunda state güncellemesi
        state = AsyncData(responseData);
      } else {
        // API'den dönen hata mesajını işleyin
        final responseData = json.decode(response.body);
        final errorMessage = responseData['error'] ?? 'Failed to login';

        // Hata durumunda state güncellemesi
        state = AsyncError(errorMessage, StackTrace.current);
      }
    } catch (e) {
      // Genel hata durumunda state güncellemesi
      state = AsyncError('An unexpected error occurred', StackTrace.current);
    }
  }
}
