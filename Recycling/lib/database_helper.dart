import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  static Database? _db;

  DatabaseHelper._internal();

  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await initDb();
    return _db!;
  }

  Future<Database> initDb() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'ramyun.db');

    var exists = await databaseExists(path);

    if (!exists) {
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}

      ByteData data = await rootBundle.load(join('assets', 'ramyun.db'));

      List<int> bytes =
      data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      await File(path).writeAsBytes(bytes, flush: true);
    }

    return await openDatabase(path);
  }

 /* Future<Map<String, dynamic>> getProductByBarcode(String barcode) async {
    Database db = await this.db;
    List<Map<String, dynamic>> result = await db.query(
      'product',
      where: 'barcode = ?',
      whereArgs: [barcode],
      limit: 1,
    );
    if (result.isNotEmpty) {
      var product = result.first;
      String materials = '';
      if (product['material1'] != null) materials += product['material1'];
      if (product['material2'] != null) materials += ', ' + product['material2'];
      if (product['material3'] != null) materials += ', ' + product['material3'];
      product['materials'] = materials;
      return product;
    } else {
      return {};
    }
  }*/

  Future<String> getProductByBarcode(String barcode) async {
    Database db = await this.db;
    List<Map<String, dynamic>> result = await db.query(
      'product',
      columns: ['material1'],
      where: 'barcode = ?',
      whereArgs: [barcode],
      limit: 1,
    );
    if (result.isNotEmpty) {
      return result.first['material1'] ?? '';
    } else {
      return '';
    }
  }


}
