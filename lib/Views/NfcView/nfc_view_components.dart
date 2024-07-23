import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class NfcAppbarTitle extends StatelessWidget {
  const NfcAppbarTitle({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      "Scan Your NFC",
      style: GoogleFonts.inter(
        fontSize: 18.sp,
        color: Colors.white,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class NfcAppbarLeading extends StatelessWidget {
  const NfcAppbarLeading({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Icon(
        Icons.chevron_left,
        color: Colors.white,
        size: 40,
      ),
    );
  }
}
