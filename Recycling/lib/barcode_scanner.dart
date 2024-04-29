import 'package:flutter/material.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:recycling/database_helper.dart';
import 'package:recycling/product_details_screen.dart';

/*class CustomBarcodeScanner {
  Future<void> scanBarcode(BuildContext context) async {
    try {
      final result = await BarcodeScanner.scan();
      var product = await DatabaseHelper().getProductByBarcode(result.rawContent);
      if (product.isNotEmpty) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailsScreen(product: product),
          ),
        );
      } else {
        // 제품 정보가 없을 경우에 대한 처리
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Product Not Found'),
              content: Text('The scanned barcode does not match any product in the database.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      print('Error scanning barcode: $e');
      // 바코드 스캔 중 오류가 발생한 경우에 대한 처리
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('An error occurred while scanning the barcode. Please try again.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }
}*/

class CustomBarcodeScanner {
  Future<void> scanBarcode(BuildContext context) async {
    try {
      final result = await BarcodeScanner.scan();
      if (result.rawContent.isNotEmpty) {
        // 스캔된 바코드 번호를 화면에 표시합니다.
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Scanned Barcode'),
              content: Text(result.rawContent),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      } else {
        print('Empty Barcode Scanned');
      }
    } catch (e) {
      print('Error scanning barcode: $e');
      // 바코드 스캔 중 오류가 발생한 경우에 대한 처리
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('An error occurred while scanning the barcode. Please try again.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }
}

