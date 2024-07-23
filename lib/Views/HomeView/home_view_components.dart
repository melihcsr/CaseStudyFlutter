import 'package:case_study/Models/UserModel.dart';
import 'package:case_study/Views/NfcView/nfc_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class FloatingButton extends StatelessWidget {
  const FloatingButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () async {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const NfcView()));
      },
      backgroundColor: Color.fromRGBO(255, 177, 104, 1),
      child: Icon(Icons.nfc, color: Colors.white),
    );
  }
}

class ListViewItem extends StatelessWidget {
  const ListViewItem({
    super.key,
    required this.user,
  });

  final User user;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(user.avatar),
      ),
      title: Text('${user.firstName} ${user.lastName}'),
      subtitle: Text(user.email),
    );
  }
}

class AppbarTitle extends StatelessWidget {
  const AppbarTitle({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      "Katılımcı Listesi",
      style: GoogleFonts.inter(
          fontSize: 18.sp, color: Colors.white, fontWeight: FontWeight.w700),
    );
  }
}
