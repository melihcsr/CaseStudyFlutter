import 'package:case_study/Views/HomeView/home_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nfc_manager/nfc_manager.dart';

class NfcViewModel extends ChangeNotifier {
  void startNFCReading(BuildContext context) async {
    try {
      bool isAvailable = await NfcManager.instance.isAvailable();

      if (isAvailable) {
        NfcManager.instance.startSession(
          pollingOptions: {
            NfcPollingOption.iso14443,
            NfcPollingOption.iso15693,
          },
          onDiscovered: (NfcTag tag) async {
            String tagData = tag.data.toString();
            debugPrint('NFC Tag Detected: $tagData');

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

final nfcViewModelProvider = ChangeNotifierProvider((ref) => NfcViewModel());
