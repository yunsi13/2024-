import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'services/database_service.dart';
import 'location_service.dart';
import 'package:geocoding/geocoding.dart';

class ChatbotService {
  final DatabaseService databaseService = DatabaseService();
  final LocationService locationService = LocationService();
  List<Map<String, String>> conversationHistory = [];

  // 메시지를 처리하고 응답을 반환하는 함수
  Future<String> sendMessage(String message) async {
    final int? barcode = int.tryParse(message);

    if (barcode != null) {
      final productInfo = await databaseService.getProductInfo(barcode);
      if (productInfo != null) {
        final product = productInfo['제품명'];
        final material1 = productInfo['재질정보1'];
        final material2 = productInfo['재질정보2'];

        final location = await _getLocation();

        final productInfoMessage = '제품명: $product\n재질정보1: $material1\n재질정보2: $material2\n';
        conversationHistory.add({'role': 'user', 'content': message});
        conversationHistory.add({'role': 'assistant', 'content': productInfoMessage});

        final recyclingInfoMessage = await _getRecyclingInfo(product, material1, material2, location);

        final response = '$productInfoMessage\n$recyclingInfoMessage';
        conversationHistory.add({'role': 'assistant', 'content': recyclingInfoMessage});

        return response;
      } else {
        return '해당 바코드에 대한 정보를 찾을 수 없습니다.';
      }
    }

    return await _sendToChatGPT(message);
  }

  // 재질 정보를 기반으로 재활용 방법을 요청하는 함수
  Future<String> _getRecyclingInfo(String product, String material1, String? material2, String location) async {
    final apiKey = dotenv.env['CHAT_GPT_API_KEY'];
    final url = Uri.parse('https://api.openai.com/v1/chat/completions');

    String recyclingQuery = '$location에서 재질 $material1을(를) 재활용하는 방법을 알려줘.';
    if (material2 != null && material2.isNotEmpty) {
      recyclingQuery += ' 또한, $location에서 재질 $material2을(를) 재활용하는 방법을 알려줘.';
    }

    conversationHistory.add({'role': 'user', 'content': recyclingQuery});

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: jsonEncode({
        'model': 'gpt-3.5-turbo-0301',
        'messages': [
          {"role": "system", "content": "너는 분리수거 방법을 알려주는 서비스야."},
          {"role": "system", "content": "제품정보는 {제품명}, 재질정보는 {재질정보1}, {재질정보2} 이다."},
          ...conversationHistory,
        ],
      }),
      encoding: Encoding.getByName('utf-8'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      final String responseContent = data['choices'][0]['message']['content'].trim();
      return responseContent;
    } else {
      throw Exception('Failed to load recycling info from chatbot');
    }
  }

  // 일반 메시지를 ChatGPT로 보내는 함수
  Future<String> _sendToChatGPT(String message) async {
    final apiKey = dotenv.env['CHAT_GPT_API_KEY'];
    final url = Uri.parse('https://api.openai.com/v1/chat/completions');

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
          {"role": "system", "content": "너는 분리수거 방법을 알려주는 서비스야."},
          {"role": "system", "content": "제품정보는 {제품명}, 재질정보는 {재질정보1}, {재질정보2} 이다."},
          ...conversationHistory,
        ],
      }),
      encoding: Encoding.getByName('utf-8'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      final String responseContent = data['choices'][0]['message']['content'].trim();
      conversationHistory.add({'role': 'assistant', 'content': responseContent});
      return responseContent;
    } else {
      throw Exception('Failed to load chatbot response');
    }
  }

  // 현재 위치를 가져오는 함수
  Future<String> _getLocation() async {
    final position = await locationService.getCurrentLocation();
    if (position != null) {
      List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        return "${place.locality}${place.locality != null ? ', ' : ''}${place.administrativeArea}";
      }
    }
    return "사용자의 위치";
  }
}
