import 'dart:async'; // Import gerekebilir
import 'package:case_study/Service/api_services.dart';
import 'package:case_study/Views/HomeView/home_view.dart';
import 'package:case_study/Views/LoginView/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Riverpod importu
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // WidgetsBinding başlat

  // Token'ı SecureStorage'dan al
  final token = await SecureStorage.getToken();

  runApp(
    ProviderScope(
      child: MyApp(startingPage: LoginPage()),
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
        title: 'Flutter NFC Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: startingPage,
      ),
    );
  }
}

class NfcBottomSheetPage extends StatefulWidget {
  @override
  _NfcBottomSheetPageState createState() => _NfcBottomSheetPageState();
}

class _NfcBottomSheetPageState extends State<NfcBottomSheetPage> {
  static const platform = MethodChannel('com.example/nfc');
  String _nfcData = 'NFC verisi bekleniyor...';
  bool _isScanning = false;

  void _startNfcScan() async {
    setState(() {
      _isScanning = true;
      _nfcData = 'NFC taraması başlatıldı...';
    });

    print('NFC taramasını başlatma işlemi başladı.');

    try {
      print('Native NFC scan method çağrılıyor...');
      final String result = await platform.invokeMethod('startNfcScan');
      print('NFC tarama sonucu alındı: $result');
      setState(() {
        _nfcData = 'NFC Tag Verisi: $result';
      });
    } on PlatformException catch (e) {
      print('NFC tarama hatası: ${e.message}');
      setState(() {
        _nfcData = 'NFC tarama hatası: ${e.message}';
      });
    } finally {
      print('NFC tarama işlemi tamamlandı.');
      setState(() {
        _isScanning = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('NFC Tarama'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: _isScanning ? null : _startNfcScan,
          child: Text('NFC Taramasını Başlat'),
        ),
      ),
    );
  }
}
