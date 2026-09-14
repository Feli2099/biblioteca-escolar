import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class TelaScannerIsbn extends StatefulWidget {
  const TelaScannerIsbn({super.key});

  @override
  State<TelaScannerIsbn> createState() {
    return _TelaScannerIsbnState();
  }
}

class _TelaScannerIsbnState extends State<TelaScannerIsbn> {
  bool _codigoProcessado = false;

  @override
  Widget build(BuildContext contextTelaScanner) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Escanear ISBN'),
      ),
      body: MobileScanner(
        onDetect: (captura) {
          if (_codigoProcessado) {
            return;
          }

          final codigo = captura.barcodes.first.rawValue;

          if (codigo == null) {
            return;
          }

          _codigoProcessado = true;
          
          Navigator.pop(
            contextTelaScanner,
            codigo,
          );
        },
      ),
    );
  }
}
