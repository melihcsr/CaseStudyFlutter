import 'package:case_study/ViewModels/homeViewModel.dart';
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
        title: Text(
          "Katılımcı Listesi",
          style: GoogleFonts.inter(
              fontSize: 18.sp,
              color: Colors.white,
              fontWeight: FontWeight.w700),
        ),
      ),
      body: userModelAsyncValue.when(
        data: (userModel) {
          return ListView.builder(
            itemCount: userModel.data.length,
            itemBuilder: (context, index) {
              final user = userModel.data[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(user.avatar),
                ),
                title: Text('${user.firstName} ${user.lastName}'),
                subtitle: Text(user.email),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const NfcView()));
        },
        backgroundColor: Color.fromRGBO(255, 177, 104, 1),
        child: Icon(Icons.nfc, color: Colors.white),
      ),
    );
  }
}
