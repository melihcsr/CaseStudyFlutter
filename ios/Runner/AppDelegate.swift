import Flutter
import UIKit
import CoreNFC

@main
@objc class AppDelegate: FlutterAppDelegate, NFCNDEFReaderSessionDelegate {
    private var nfcSession: NFCNDEFReaderSession?
    private var result: FlutterResult?

    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)

        let controller = window?.rootViewController as! FlutterViewController
        let nfcChannel = FlutterMethodChannel(name: "com.example/nfc", binaryMessenger: controller.binaryMessenger)

        nfcChannel.setMethodCallHandler { [weak self] (call, result) in
            guard call.method == "startNfcScan" else {
                result(FlutterMethodNotImplemented)
                return
            }
            self?.result = result
            self?.startNfcSession()
        }

        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    private func startNfcSession() {
        guard NFCNDEFReaderSession.readingAvailable else {
            result?("NFC tarayıcı desteklenmiyor")
            return
        }

        nfcSession = NFCNDEFReaderSession(delegate: self, queue: nil, invalidateAfterFirstRead: true)
        nfcSession?.alertMessage = "Lütfen bir NFC etiketi taratın."
        nfcSession?.begin()
        print("NFC tarayıcı başlatıldı.")
    }

    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        print("NFC etiketi bulundu.")
        guard let result = self.result else { return }

        var nfcData = ""
        for message in messages {
            for record in message.records {
                if let payloadString = String(data: record.payload, encoding: .utf8) {
                    nfcData += payloadString
                    print("NFC verisi: \(payloadString)")
                }
            }
        }
        result(nfcData)
        self.result = nil
    }

    func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
        print("NFC tarama hatası: \(error.localizedDescription)")
        guard let result = self.result else { return }
        result(FlutterError(code: "NFC_ERROR", message: error.localizedDescription, details: nil))
        self.result = nil
    }
}


