import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';

class DatabaseService {
  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String dbPath = await getDatabasesPath();
    String path = join(dbPath, 'recycle_data.db');

    // assets 폴더에서 데이터베이스 파일을 복사합니다.
    if (!await databaseExists(path)) {
      try {
        await Directory(dirname(path)).create(recursive: true);
        ByteData data = await rootBundle.load('assets/recycle_data.db');
        List<int> bytes =
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
        await File(path).writeAsBytes(bytes, flush: true);
      } catch (e) {
        print('Error copying database: $e');
      }
    }

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        // 데이터베이스를 처음 생성할 때 테이블을 만들지 않습니다.
        // 데이터베이스 파일을 미리 준비해 놓았기 때문에 생략합니다.
      },
      onOpen: (db) async {
        // 데이터베이스가 열릴 때 호출됩니다.
      },
    );
  }

  Future<Map<String, dynamic>?> getProductInfo(int barcode) async {
    final db = await database;
    final List<Map<String, dynamic>> results = await db.rawQuery(
      'SELECT * FROM Recycle_Data WHERE 바코드번호 = ?',
      [barcode],
    );

    if (results.isNotEmpty) {
      return results.first;
    } else {
      return null;
    }
  }
}
