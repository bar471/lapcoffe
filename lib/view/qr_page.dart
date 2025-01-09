import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../controllers/qr_controller.dart';

class QRGeneratorView extends StatefulWidget {
  const QRGeneratorView({Key? key}) : super(key: key);

  @override
  State<QRGeneratorView> createState() => _QRGeneratorViewState();
}

class _QRGeneratorViewState extends State<QRGeneratorView> {
  final QRController _qrController = QRController();
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _textController.text = _qrController.qrData; // Default data
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
            'QR Code',
            style: TextStyle(color: Colors.white), // Set text color to white
          ),
          backgroundColor: const Color(0xFF6F4E37),
          iconTheme: IconThemeData(color: Colors.white)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _textController,
              decoration: const InputDecoration(
                labelText: 'Enter text or URL',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _qrController.setQRData(value);
                });
              },
            ),
            const SizedBox(height: 20),
            // Menampilkan QR Code
            QrImageView(
              data: _qrController.qrData,
              version: QrVersions.auto,
              size: 200.0,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6F4E37),
              ),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('QR Code Generated!')),
                );
              },
              child: const Text(
                'Generate',
                style:
                    TextStyle(color: Colors.white), // Set text color to white
              ),
            ),
          ],
        ),
      ),
    );
  }
}
