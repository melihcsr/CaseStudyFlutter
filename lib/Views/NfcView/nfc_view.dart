import 'package:case_study/ViewModels/nfcViewModel.dart';
import 'package:case_study/Views/HomeView/home_view.dart';
import 'package:case_study/Views/NfcView/nfc_view_components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nfc_manager/nfc_manager.dart';

class NfcView extends ConsumerStatefulWidget {
  const NfcView({super.key});

  @override
  ConsumerState<NfcView> createState() => _NfcViewState();
}

class _NfcViewState extends ConsumerState<NfcView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(nfcViewModelProvider).startNFCReading(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(255, 177, 104, 1),
        leading: NfcAppbarLeading(),
        title: NfcAppbarTitle(),
      ),
      body: Column(
        children: [
          SizedBox(height: 120),
          Image.asset(
            "assets/nfc.png",
            width: MediaQuery.of(context).size.width / 1.2,
          ),
        ],
      ),
    );
  }
}
