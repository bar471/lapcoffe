import '../models/qr_model.dart';

class QRController {
  QRModel _qrModel = QRModel(data: "https://example.com");

  // Mendapatkan data QR Code
  String get qrData => _qrModel.data;

  // Mengatur data QR Code
  void setQRData(String newData) {
    _qrModel = QRModel(data: newData);
  }
}
