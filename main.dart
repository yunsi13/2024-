import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _locationMessage = "";  // 사용자에게 위치 정보를 보여줄 문자열 변수

  void _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // 위치 서비스 활성화 여부 확인
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        _locationMessage = "위치 서비스가 비활성화되어 있습니다.";
      });
      return;
    }

    // 위치 권한 확인 및 요청
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          _locationMessage = "위치 권한이 거부되었습니다.";
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        _locationMessage = "위치 권한이 영구적으로 거부되었습니다. 설정에서 변경해주세요.";
      });
      return;
    }

    // 실제 위치 정보 가져오기
    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      _locationMessage = "위치: ${position.latitude}, ${position.longitude}";
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Flutter 위치 추적 예제'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(_locationMessage),
              TextButton(
                onPressed: _getCurrentLocation,
                child: Text('현재 위치 가져오기'),
                style: TextButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: Colors.grey,
                  disabledForegroundColor: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
