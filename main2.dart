import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('졸작'),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              buildTipSection(),
              SizedBox(height: 20), // Tip과 지도 간격
              Center(
                child: buildAnimatedImageButton(
                  imagePath: 'assets/images/map.png',
                  label: "지도",
                  color: Colors.teal.withOpacity(0.2),
                  onTap: () {
                    print("지도 버튼 클릭됨");
                  },
                  size: 420, // 버튼 크기
                  height: 250, // 버튼 크기
                  imageWidth: 180, // 이미지 너비
                  imageHeight: 180, // 이미지 높이
                ),
              ),
              SizedBox(height: 20), // 지도와 카메라/바코드 간격
              Expanded(
                flex: 2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: buildAnimatedCameraButton(),
                    ),
                    SizedBox(width: 20), // 카메라와 바코드 간격
                    Expanded(
                      child: buildAnimatedBarcodeButton(),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20), // 카메라/바코드와 서비스 안내 간격
              buildServiceSection(),
              SizedBox(height: 20), // 서비스 안내와 하단 여백
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTipSection() {
    return Container(
      margin: EdgeInsets.only(top: 16.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () {
          print("Tip 섹션 클릭됨");
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.lightbulb_outline, color: Colors.green),
              SizedBox(width: 5),
              Text(
                "Tip",
                style: TextStyle(fontSize: 20, color: Colors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildAnimatedImageButton({
    required String imagePath,
    required String label,
    required Color color,
    required VoidCallback onTap,
    double size = 160,
    double height = 160,
    double imageWidth = 160, // 이미지 너비 추가
    double imageHeight = 160, // 이미지 높이 추가
  }) {
    return StatefulBuilder(
      builder: (context, setState) {
        bool isPressed = false;

        return InkWell(
          onTap: onTap,
          onTapDown: (_) {
            setState(() {
              isPressed = true;
            });
          },
          onTapUp: (_) {
            setState(() {
              isPressed = false;
            });
          },
          onTapCancel: () {
            setState(() {
              isPressed = false;
            });
          },
          child: AnimatedScale(
            scale: isPressed ? 0.9 : 1.0,
            duration: Duration(milliseconds: 100),
            child: Container(
              width: size,
              height: height,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    imagePath,
                    fit: BoxFit.contain,
                    width: imageWidth, // 이미지 너비 설정
                    height: imageHeight, // 이미지 높이 설정
                  ),
                  Text(
                    label,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildAnimatedCameraButton() {
    return StatefulBuilder(
      builder: (context, setState) {
        bool isPressed = false;

        return InkWell(
          onTap: () {
            print("카메라 버튼 클릭됨");
          },
          onTapDown: (_) {
            setState(() {
              isPressed = true;
            });
          },
          onTapUp: (_) {
            setState(() {
              isPressed = false;
            });
          },
          onTapCancel: () {
            setState(() {
              isPressed = false;
            });
          },
          child: AnimatedScale(
            scale: isPressed ? 0.9 : 1.0,
            duration: Duration(milliseconds: 100),
            child: Container(
              width: 150, // 버튼 너비
              height: 400, // 버튼 높이
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.camera_alt, size: 150, color: Colors.black),
                  SizedBox(height: 8),
                  Text(
                    "카메라",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildAnimatedBarcodeButton() {
    return StatefulBuilder(
      builder: (context, setState) {
        bool isPressed = false;

        return InkWell(
          onTap: () {
            print("바코드 버튼 클릭됨");
          },
          onTapDown: (_) {
            setState(() {
              isPressed = true;
            });
          },
          onTapUp: (_) {
            setState(() {
              isPressed = false;
            });
          },
          onTapCancel: () {
            setState(() {
              isPressed = false;
            });
          },
          child: AnimatedScale(
            scale: isPressed ? 0.9 : 1.0,
            duration: Duration(milliseconds: 100),
            child: Container(
              width: 150, // 버튼 너비
              height: 400, // 버튼 높이
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.qr_code, size: 150, color: Colors.black),
                  SizedBox(height: 8),
                  Text(
                    "바코드",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildServiceSection() {
    return Container(
      margin: EdgeInsets.only(bottom: 16.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () {
          print("서비스 안내 섹션 클릭됨");
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.info, color: Colors.orange),
              SizedBox(width: 5),
              Text(
                "서비스 안내",
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
