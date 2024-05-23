import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _data = 'Loading...';

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    var url = 'http://10.0.2.2:5000/get_variable';  // 서버 IP 주소 변경
    var response = await http.get(Uri.parse(url)); //HTTP 요청을 통해 데이터를 가져오는 부분
    var decoded = jsonDecode(response.body);

    setState(() {
      _data = decoded['value'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fetch Data from Python'),
      ),
      body: Center(
        child: Text(_data),
      ),
    );
  }
}
