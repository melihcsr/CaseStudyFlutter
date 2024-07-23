import 'package:case_study/Models/UserModel.dart';
import 'package:case_study/ViewModels/homeViewModel.dart';
import 'package:case_study/Views/HomeView/home_view_components.dart';
import 'package:case_study/Views/NfcView/nfc_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';
import 'package:nfc_manager/nfc_manager.dart';

class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userModelAsyncValue = ref.watch(homeViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(255, 177, 104, 1),
        title: AppbarTitle(),
      ),
      body: userModelAsyncValue.when(
        data: (userModel) {
          return ListView.builder(
            itemCount: userModel.data.length,
            itemBuilder: (context, index) {
              final user = userModel.data[index];
              return Padding(
                padding: EdgeInsets.only(top: index == 0 ? 16 : 8),
                child: ListViewItem(user: user),
              );
            },
          );
        },
        loading: () => Center(
            child: CircularProgressIndicator(
          color: Color.fromRGBO(255, 177, 104, 1),
        )),
        error: (error, stackTrace) => Center(child: Text('Error: $error')),
      ),
      floatingActionButton: FloatingButton(),
    );
  }
}
