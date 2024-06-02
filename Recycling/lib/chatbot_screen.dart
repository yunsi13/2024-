import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'barcode_scanner_screen.dart';
import 'chatbot_service.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({Key? key}) : super(key: key);

  @override
  _ChatbotScreenState createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];
  bool _isLoading = false;
  final ChatbotService _chatbotService = ChatbotService();

  @override
  void initState() {
    super.initState();
    _requestLocationPermission(); // 위치 권한 요청
  }

  // 위치 권한 요청
  Future<void> _requestLocationPermission() async {
    await Permission.location.request();
  }

  // 메시지를 전송하고 응답을 받는 함수
  Future<void> _sendMessage(String message) async {
    if (message.isEmpty) return;

    setState(() {
      _messages.add({'type': 'user', 'message': message});
      _isLoading = true;
    });

    // 전송 후 입력란 초기화
    _controller.clear();

    try {
      String response = await _chatbotService.sendMessage(message);

      // 챗봇 응답을 대화 내역에 추가
      setState(() {
        _messages.add({'type': 'bot', 'message': response});
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _messages.add({'type': 'bot', 'message': 'Error: Failed to load chatbot response'});
        _isLoading = false;
      });
    }
  }

  // 바코드 스캔 함수
  Future<void> _scanBarcode() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const BarcodeScannerScreen()),
    );

    if (result != null) {
      _sendMessage(result);
    }
  }

  // 메시지 위젯 생성 함수
  Widget _buildMessage(Map<String, String> message) {
    bool isUser = message['type'] == 'user';
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        decoration: BoxDecoration(
          color: isUser ? Colors.blue[200] : Colors.grey[300],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(message['message'] ?? ''),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('재활용 도우미'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return Column(
                  crossAxisAlignment: _messages[index]['type'] == 'user'
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: [
                    if (_messages[index]['type'] == 'bot')
                      Text(
                        '재활용 도우미',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    _buildMessage(_messages[index]),
                  ],
                );
              },
            ),
          ),
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: '메세지를 입력하세요',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () => _sendMessage(_controller.text),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  // 이미지 인식 버튼 클릭 처리
                },
                child: const Text('이미지 인식'),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: _scanBarcode,
                child: const Text('바코드 스캔'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
