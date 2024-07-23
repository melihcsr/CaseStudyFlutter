import 'package:case_study/Service/api_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

final loginViewModelProvider =
    StateNotifierProvider<LoginViewModel, AsyncValue<Map<String, dynamic>>>(
  (ref) => LoginViewModel(ref),
);

final passwordVisibilityProvider =
    StateNotifierProvider<PasswordVisibilityNotifier, bool>(
  (ref) => PasswordVisibilityNotifier(),
);

final tokenProvider = StateProvider<String?>((ref) => null);

class PasswordVisibilityNotifier extends StateNotifier<bool> {
  PasswordVisibilityNotifier() : super(true);

  void toggleVisibility() {
    state = !state;
  }
}

class LoginViewModel extends StateNotifier<AsyncValue<Map<String, dynamic>>> {
  LoginViewModel(this.ref) : super(const AsyncData({}));

  final Ref ref;

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

        await SecureStorage.saveToken(token);

        ref.read(tokenProvider.notifier).state = token;

        state = AsyncData(responseData);
      } else {
        final responseData = json.decode(response.body);
        final errorMessage = responseData['error'] ?? 'Failed to login';
        state = AsyncError(errorMessage, StackTrace.current);
      }
    } catch (e) {
      state = AsyncError('An unexpected error occurred', StackTrace.current);
    }
  }
}
