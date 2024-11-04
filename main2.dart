import 'dart:async';
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
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  color: Colors.teal.withOpacity(0.2),
                  onTap: () {
                    print("지도 버튼 클릭됨");
                  },
                  size: 420, // 버튼 크기
                  height: 250, // 버튼 크기
                  imageWidth: 100, // 이미지 너비
                  imageHeight: 100, // 이미지 높이
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
    List<String> tips = [
      "재활용 가능 품목은 깨끗하게 씻어서 배출해야 더욱 효과적입니다.",
      "음식물쓰레기는 물기를 제거하고 전용 용기에 담아 배출해야 악취 발생을 줄일 수 있습니다.",
      "소각 쓰레기는 다른 폐기물과 섞이지 않도록 꼼꼼하게 분리 배출해야 합니다.",
      "재활용 가능 품목이더라도 깨진 유리, 헌옷, 폐식용유 등은 별도로 배출해야 합니다.",
      "뚜껑은 플라스틱, 용기는 플라스틱으로 분류해야 합니다.",
      "깨진 유리는 신문지에 싸서 버리세요.",
    ];

    // Index to keep track of the current tip
    int currentTipIndex = 0;

    // A controller to update the UI periodically
    ValueNotifier<String> currentTip = ValueNotifier(tips[currentTipIndex]);

    // Start a timer to update the tip every 10 seconds
    Timer.periodic(Duration(seconds: 10), (Timer timer) {
      currentTipIndex = (currentTipIndex + 1) % tips.length;
      currentTip.value = tips[currentTipIndex];
    });

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
          child: Row(
            children: [
              Icon(Icons.lightbulb_outline, color: Colors.green, size: 24),
              SizedBox(width: 10), // 아이콘과 텍스트 간격
              Expanded(
                child: ValueListenableBuilder<String>(
                  valueListenable: currentTip,
                  builder: (context, value, child) {
                    return Text(
                      value,
                      style: TextStyle(fontSize: 16, color: Colors.black),
                      textAlign: TextAlign.left,
                    );
                  },
                ),
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
    double imageWidth = 160,
    double imageHeight = 160,
    TextStyle? style, // 스타일 매개변수 추가
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
                    fit: BoxFit.cover,
                    width: imageWidth,
                    height: imageHeight,
                  ),
                  SizedBox(height: 8),
                  Text(
                    label,
                    style: style ?? TextStyle(fontSize: 16, fontWeight: FontWeight.bold), // 스타일 적용
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
              width: 150,
              height: 400,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.camera_alt, size: 100, color: Colors.black),
                  SizedBox(height: 8),
                  Text(
                    "카메라",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
              width: 150,
              height: 400,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.qr_code, size: 100, color: Colors.black),
                  SizedBox(height: 8),
                  Text(
                    "바코드",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
