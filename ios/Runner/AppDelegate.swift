import Flutter
import UIKit
import CoreNFC

@main
@objc class AppDelegate: FlutterAppDelegate, NFCNDEFReaderSessionDelegate {
    private var result: FlutterResult?

    override func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
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

        let session = NFCNDEFReaderSession(delegate: self, queue: nil, invalidateAfterFirstRead: true)
        session.alertMessage = "Lütfen bir NFC etiketi taratın."
        session.begin()
    }

    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        guard let result = self.result else { return }

        var nfcData = ""
        for message in messages {
            for record in message.records {
                if let payloadString = String(data: record.payload, encoding: .utf8) {
                    nfcData += payloadString
                }
            }
        }
        result(nfcData)
        self.result = nil
    }

    func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
        print("NFC session invalidated with error: \(error.localizedDescription)")
        result?(FlutterMethodNotImplemented) // Hata mesajı yerine FlutterMethodNotImplemented kullan
        self.result = nil
    }
}

