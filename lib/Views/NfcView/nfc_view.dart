import 'package:case_study/Views/HomeView/home_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nfc_manager/nfc_manager.dart';

class NfcView extends StatefulWidget {
  const NfcView({super.key});

  @override
  State<NfcView> createState() => _NfcViewState();
}

class _NfcViewState extends State<NfcView> {
  @override
  void initState() {
    // TODO: implement initState

    _startNFCReading(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(255, 177, 104, 1),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.chevron_left,
            color: Colors.white,
            size: 40,
          ),
        ),
        title: Text(
          "Scan Your NFC",
          style: GoogleFonts.inter(
              fontSize: 18.sp,
              color: Colors.white,
              fontWeight: FontWeight.w700),
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 120),
          Image.asset(
            "assets/nfc.png",
            width: MediaQuery.of(context).size.width / 1.2,
          )
        ],
      ),
    );
  }

  void _startNFCReading(BuildContext context) async {
    try {
      bool isAvailable = await NfcManager.instance.isAvailable();

      // We first check if NFC is available on the device.
      if (isAvailable) {
        // If NFC is available, start an NFC session and listen for NFC tags to be discovered.
        NfcManager.instance.startSession(
          pollingOptions: {
            NfcPollingOption.iso14443,
            NfcPollingOption.iso15693
          },
          onDiscovered: (NfcTag tag) async {
            // Process NFC tag. When an NFC tag is discovered, show its data in a popup dialog.
            String tagData = tag.data.toString();
            debugPrint('NFC Tag Detected: $tagData');

            // Show dialog with tag data
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('NFC Tag Detected'),
                  content: Text(tagData),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => HomeView()),
                          (Route<dynamic> route) => false,
                        );
                      },
                      child: Text('OK'),
                    ),
                  ],
                );
              },
            );

            // Stop the NFC session
            NfcManager.instance.stopSession();
          },
        );
      } else {
        debugPrint('NFC not available.');
      }
    } catch (e) {
      debugPrint('Error reading NFC: $e');
    }
  }
}
