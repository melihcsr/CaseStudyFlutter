import 'dart:ui';

import 'package:case_study/ViewModels/loginViewModel.dart';
import 'package:case_study/Views/HomeView/home_view.dart';
import 'package:case_study/Views/LoginView/login_view_components.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loginState = ref.watch(loginViewModelProvider);

    ref.listen<AsyncValue<Map<String, dynamic>>>(loginViewModelProvider,
        (previous, next) {
      next.when(
        data: (data) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomeView()),
          );
        },
        loading: () {
          // İsteğe bağlı: Yükleniyor durumunda bir şeyler yapabilirsiniz
        },
        error: (error, stackTrace) {
          Alert(
            context: context,
            type: AlertType.error,
            title: "Login Error",
            style: AlertStyle(
                descStyle: GoogleFonts.manrope(
                    fontSize: 16.sp, fontWeight: FontWeight.w500),
                titleStyle: GoogleFonts.manrope(
                    color: Colors.red, fontWeight: FontWeight.bold)),
            desc: error.toString(),
            buttons: [
              DialogButton(
                child: Text(
                  "OK",
                  style: GoogleFonts.manrope(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold),
                ),
                onPressed: () => Navigator.pop(context),
                color: Color.fromRGBO(255, 177, 104, 1),
                width: 120,
              )
            ],
          ).show();
        },
      );
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Form(
              key: _formKey,
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 64),
                      backgroundPhoto(context),
                      SizedBox(height: MediaQuery.of(context).size.height / 10),
                      Padding(
                        padding: EdgeInsets.only(left: 16.w, top: 16.h),
                        child: welcomeText(),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 16.w, top: 4.h),
                        child: subtitleText(),
                      ),
                      SizedBox(height: 32.h),
                      LoginTextFormField(
                        leadingIcon: "mail-01",
                        obscureText: false,
                        controller: emailController,
                      ),
                      SizedBox(height: 12.h),
                      LoginTextFormField(
                        leadingIcon: "key-01",
                        obscureText: true,
                        controller: passwordController,
                      ),
                      forgotYourPassword(context),
                      SizedBox(height: 46.h),
                      Padding(
                        padding: EdgeInsets.only(bottom: 16.h),
                        child: loginButton(
                          context,
                          emailController,
                          passwordController,
                          loginState,
                        ),
                      ),
                    ],
                  ),
                  SafeArea(
                    child: Padding(
                      padding: EdgeInsets.only(top: 24.h),
                      child: Center(
                        child: logoRow(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Align loginButton(
      BuildContext context,
      TextEditingController emailController,
      TextEditingController passwordController,
      AsyncValue<Map<String, dynamic>> loginState) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: GestureDetector(
          onTap: () {
            final email = emailController.text;
            final password = passwordController.text;
            ref.read(loginViewModelProvider.notifier).login(email, password);
          },
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 52.h,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              gradient: LinearGradient(colors: [
                Color.fromRGBO(255, 177, 104, 1),
                Color.fromRGBO(255, 153, 123, 1)
              ]),
            ),
            child: Center(
              child: loginState is AsyncLoading
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text(
                      "Login ->",
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
