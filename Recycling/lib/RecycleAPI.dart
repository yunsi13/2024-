import 'package:flutter/material.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RecycleAPI extends StatelessWidget {
  Future<void> scanBarcode(BuildContext context) async {
    try {
      final result = await BarcodeScanner.scan();
      print('Barcode result: ${result.rawContent}');

      // 바코드 스캔 결과를 API와 연동하여 처리
      try {
        final productInfo = await fetchProductInfo(result.rawContent);
        print('Product info: $productInfo');

        // 스캔 결과와 제품 정보를 다이얼로그로 표시
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('바코드 스캔 결과'),
              content: Text('스캔 결과: ${result.rawContent}\n제품 정보: ${productInfo['PRDT_NM']}'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('닫기'),
                ),
              ],
            );
          },
        );
      } catch (e) {
        print('Error while fetching product info: $e');
        // 여기에 사용자에게 오류 메시지를 표시하는 코드를 추가.
      }
    } catch (e) {
      print('Error while scanning barcode: $e');
      // 여기에 사용자에게 오류 메시지를 표시하는 코드를 추가.
    }
  }

  Future<Map<String, dynamic>> fetchProductInfo(String barcode) async {
    try {
      final response = await http.get(Uri.parse('http://openapi.foodsafetykorea.go.kr/api/f9cbd2290052452f9be0/I2570/json/1/5/BRCD_NO=$barcode'));

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        return jsonResponse['I2570']['row'][0]; // Assuming the product info is in the first row of the response
      } else {
        throw Exception('Failed to load product info');
      }
    } catch (e) {
      print('Error while fetching product info: $e');
      throw e;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recycle'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // 바코드 스캔 실행
            scanBarcode(context);
          },
          child: Text('바코드 스캐너'),
        ),
      ),
    );
  }
}
