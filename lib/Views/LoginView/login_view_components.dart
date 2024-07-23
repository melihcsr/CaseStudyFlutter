import 'package:case_study/ViewModels/loginViewModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

SizedBox backgroundPhoto(BuildContext context) {
  return SizedBox(
    width: MediaQuery.of(context).size.width,
    child: Image.asset(
      "assets/login.png",
      fit: BoxFit.cover,
      height: MediaQuery.of(context).size.height / 4,
    ),
  );
}

Text welcomeText() {
  return Text(
    "Welcome 👋 ",
    style: GoogleFonts.inter(
        fontSize: 24.sp,
        fontWeight: FontWeight.w700,
        color: const Color.fromRGBO(71, 84, 103, 1)),
  );
}

Text subtitleText() {
  return Text("Please enter your employee login information.",
      style: GoogleFonts.inter(
          fontSize: 13.sp,
          fontWeight: FontWeight.w500,
          color: const Color.fromRGBO(71, 84, 103, 0.7)));
}

class LoginTextFormField extends ConsumerWidget {
  final String leadingIcon;
  final bool obscureText;
  final TextEditingController controller;
  final String? Function(String?) validator;

  LoginTextFormField({
    super.key,
    required this.leadingIcon,
    required this.obscureText,
    required this.controller,
    required this.validator,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPasswordObscured = ref.watch(passwordVisibilityProvider);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: SizedBox(
        height: 80.h,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              obscureText: isPasswordObscured && obscureText,
              controller: controller,
              validator: validator,
              decoration: InputDecoration(
                prefixIcon: InkWell(
                  child: Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: SvgPicture.asset(
                      'assets/$leadingIcon.svg',
                      width: 24.w,
                      height: 24.w,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                suffixIcon: obscureText
                    ? GestureDetector(
                        onTap: () {
                          ref
                              .read(passwordVisibilityProvider.notifier)
                              .toggleVisibility();
                        },
                        child: Image.asset(
                          "assets/eye.png",
                          width: 24.w,
                          height: 24.w,
                        ),
                      )
                    : const SizedBox(),
                hintText: obscureText ? "Password" : "Username",
                hintStyle: GoogleFonts.inter(
                  color: const Color.fromRGBO(71, 84, 103, 0.7),
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  borderSide: BorderSide(
                    width: 1.w,
                    color: const Color.fromRGBO(234, 236, 240, 1),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  borderSide: BorderSide(
                    width: 1.w,
                    color: const Color.fromRGBO(234, 236, 240, 1),
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  borderSide: BorderSide(
                    width: 1.w,
                    color: Colors.red,
                  ),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  borderSide: BorderSide(
                    width: 1.w,
                    color: Colors.red,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String? _validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Username cannot be empty';
    }

    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password cannot be empty';
    }

    return null;
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {}
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          LoginTextFormField(
            leadingIcon: 'username_icon',
            obscureText: false,
            controller: _usernameController,
            validator: _validateUsername,
          ),
          LoginTextFormField(
            leadingIcon: 'password_icon',
            obscureText: true,
            controller: _passwordController,
            validator: _validatePassword,
          ),
          ElevatedButton(
            onPressed: _submitForm,
            child: const Text('Login'),
          ),
        ],
      ),
    );
  }
}

Align forgotYourPassword(BuildContext context) {
  return Align(
    alignment: Alignment.centerRight,
    child: Padding(
      padding: EdgeInsets.only(right: 16.w, top: 8.h),
      child: GestureDetector(
        onTap: () {
          ;
        },
        child: Text(
          "Forgot password?",
          style: GoogleFonts.inter(
              color: const Color.fromRGBO(255, 171, 110, 1),
              fontSize: 12.sp,
              fontWeight: FontWeight.w600),
        ),
      ),
    ),
  );
}

Row logoRow() {
  return Row(
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      SvgPicture.asset(
        'assets/login-circle.svg',
        fit: BoxFit.contain,
      ),
      SizedBox(width: 4.w),
      Text(
        "izin",
        style: GoogleFonts.inter(
            fontSize: 32.sp, fontWeight: FontWeight.w800, color: Colors.white),
      ),
      Text(
        "cepte",
        style: GoogleFonts.inter(
            fontSize: 32.sp, fontWeight: FontWeight.w400, color: Colors.white),
      ),
    ],
  );
}
