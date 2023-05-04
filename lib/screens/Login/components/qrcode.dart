// import 'package:flutter/material.dart';
// import 'package:qr_code_scanner/qr_code_scanner.dart';

// class ScanQRCodeScreen extends StatefulWidget {
//   @override
//   _ScanQRCodeScreenState createState() => _ScanQRCodeScreenState();
// }

// class _ScanQRCodeScreenState extends State<ScanQRCodeScreen> {
//   final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
//   late QRViewController controller;
//   bool _isScanning = false;

//   @override
//   void dispose() {
//     controller?.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Scan QR Code'),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             flex: 5,
//             child: QRView(
//               key: qrKey,
//               onQRViewCreated: _onQRViewCreated,
//             ),
//           ),
//           Expanded(
//             flex: 1,
//             child: Center(
//               child: Text(_isScanning ? 'Scanning...' : 'Scan a QR code'),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   void _onQRViewCreated(QRViewController controller) {
//     setState(() {
//       this.controller = controller;
//       _isScanning = true;
//     });
//     controller.scannedDataStream.listen((scanData) {
//       // Handle scanned data here
//       print('Scanned data: $scanData');
//       setState(() {
//         _isScanning = false;
//       });
//       Navigator.pop(context, scanData);
//     });
//   }
// }
