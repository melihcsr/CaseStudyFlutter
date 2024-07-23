import 'package:flutter/material.dart';
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';

class NfcAuthPage extends StatefulWidget {
  @override
  _NfcAuthPageState createState() => _NfcAuthPageState();
}

class _NfcAuthPageState extends State<NfcAuthPage> {
  String _nfcData = 'NFC verisi bekleniyor...';

  @override
  void initState() {
    super.initState();
    _startNfcScan();
  }

  void _startNfcScan() async {
    try {
      // NFC taramasını başlat
      final tag = await FlutterNfcKit.poll();

      // Tag verilerini al
      setState(() {
        _nfcData = tag.id ?? 'NFC Tag ID bulunamadı';
      });

      // Kimlik doğrulama işlemlerini burada yapabilirsiniz
      // Örneğin, _nfcData'yı sunucunuza gönderebilir ve doğrulayabilirsiniz.
    } catch (e) {
      setState(() {
        _nfcData = 'NFC tarama hatası: $e';
        print(_nfcData);
      });
    } finally {
      // Tarama işlemini sonlandır
      await FlutterNfcKit.finish();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('NFC Kimlik Doğrulama'),
      ),
      body: Center(
        child: Text(
          _nfcData,
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
