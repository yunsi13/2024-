import 'package:flutter/material.dart';
import 'barcode_scanner.dart';

class RecyclePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recycle Page'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            CustomBarcodeScanner().scanBarcode(context);
          },
          child: Text('Scan Barcode'),
        ),
      ),
    );
  }
}
