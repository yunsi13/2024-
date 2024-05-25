import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'services/database_service.dart';
import 'location_service.dart';

class ChatbotService {
  final DatabaseService databaseService = DatabaseService();
  final LocationService locationService = LocationService();
  List<Map<String, String>> conversationHistory = [];

  Future<String> sendMessage(String message) async {
    // 위치 정보 요청 처리
    if (message.toLowerCase().contains('내 위치 정보')) {
      final position = await locationService.getCurrentLocation();
      if (position != null) {
        return '위도: ${position.latitude}, 경도: ${position.longitude}';
      } else {
        return '제가 사용자의 위치 정보에 접근할 수 있는 권한이 없어, 사용자의 위치 정보를 알 수 없습니다.';
      }
    }

    // 바코드인지 확인하는 로직 추가
    final int? barcode = int.tryParse(message);

    if (barcode != null) {
      // 바코드 번호로 데이터베이스에서 정보를 조회
      final productInfo = await databaseService.getProductInfo(barcode);
      if (productInfo != null) {
        // 제품 정보 반환
        final product = productInfo['제품명'];
        final material1 = productInfo['재질정보1'];
        final material2 = productInfo['재질정보2'];

        return '제품명: $product\n재질정보1: $material1\n재질정보2: $material2';
      } else {
        return '해당 바코드에 대한 정보를 찾을 수 없습니다.';
      }
    }

    final apiKey = dotenv.env['CHAT_GPT_API_KEY'];
    final url = Uri.parse('https://api.openai.com/v1/chat/completions');

    // 대화 내역에 현재 메시지를 추가합니다.
    conversationHistory.add({'role': 'user', 'content': message});

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: jsonEncode({
        'model': 'gpt-3.5-turbo-0301',
        'messages': [
          {'role': 'system', 'content': 'You are a helpful assistant.'},
          ...conversationHistory,
        ],
      }),
      encoding: Encoding.getByName('utf-8'), // 인코딩 설정 추가
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes)); // UTF-8 디코딩
      final String responseContent = data['choices'][0]['message']['content'].trim();

      // 대화 내역에 모델의 응답을 추가합니다.
      conversationHistory.add({'role': 'assistant', 'content': responseContent});

      return responseContent;
    } else {
      throw Exception('Failed to load chatbot response');
    }
  }
}
