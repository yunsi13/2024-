import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'chatbot_screen.dart';

// 앱의 메인 진입점
Future<void> main() async {
  await dotenv.load(fileName: ".env"); // 환경 변수 로드
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recycle Helper Application',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'NanumSquareRoundR', // 폰트 적용
      ),
      home: const ChatbotScreen(), // 초기 화면으로 ChatbotScreen 설정
    );
  }
}
