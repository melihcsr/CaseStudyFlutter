import 'dart:async';
import 'package:case_study/Service/api_services.dart';
import 'package:case_study/Views/HomeView/home_view.dart';
import 'package:case_study/Views/LoginView/login_page.dart';
import 'package:case_study/Views/NfcView/nfc_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final token = await SecureStorage.getToken();

  runApp(
    ProviderScope(
      child: MyApp(startingPage: token != null ? LoginPage() : LoginPage()),
    ),
  );
}

class MyApp extends StatelessWidget {
  final Widget startingPage;

  const MyApp({super.key, required this.startingPage});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      child: MaterialApp(
        theme: ThemeData(),
        home: startingPage,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
