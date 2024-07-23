import 'package:case_study/ViewModels/loginViewModel.dart';
import 'package:case_study/Views/HomeView/home_view.dart';
import 'package:case_study/Views/LoginView/login_view_components.dart';
import 'package:flutter/material.dart';
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
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final loginState = ref.watch(loginViewModelProvider);

    ref.listen<AsyncValue<Map<String, dynamic>>>(loginViewModelProvider,
        (previous, next) {
      if (next is AsyncData) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HomeView()),
        );
      } else if (next is AsyncError) {
        Alert(
          context: context,
          type: AlertType.error,
          title: "Login Error",
          desc: next.error.toString(),
          buttons: [
            DialogButton(
              child: Text(
                "OK",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () => Navigator.pop(context),
              width: 120,
            )
          ],
        ).show();
      }
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Form(
            key: _formKey,
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    backgroundPhoto(context),
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
            final email = "eve.holt@reqres.in";
            final password = "cityslicka";
            ref
                .read(loginViewModelProvider.notifier)
                .login(email, password, context);
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
                      "Giriş yap ->",
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
