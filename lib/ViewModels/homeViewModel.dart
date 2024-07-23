import 'package:case_study/Models/UserModel.dart';
import 'package:case_study/Service/api_services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Define a StateNotifier for managing user data
class HomeViewModel extends StateNotifier<AsyncValue<UserModel>> {
  final ApiService _apiService;

  HomeViewModel(this._apiService) : super(const AsyncValue.loading()) {
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      final userData = await _apiService.fetchUserData(page: 2);
      state = AsyncValue.data(userData);
    } catch (e) {}
  }
}

final apiServiceProvider = Provider<ApiService>((ref) {
  return ApiService();
});

final homeViewModelProvider =
    StateNotifierProvider<HomeViewModel, AsyncValue<UserModel>>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return HomeViewModel(apiService);
});
