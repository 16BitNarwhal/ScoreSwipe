import 'dart:async';
import 'dart:typed_data';
import 'dart:io';
import '../models/score_model.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart';

import 'package:logger/logger.dart';

class LocalScoreDataSource {
  static sql.Database? db;

  static Future<void> openDatabase() async {
    if (db != null && db!.isOpen) return;
    String dbPath = join(await sql.getDatabasesPath(), 'scores.db');
    db = await sql.openDatabase(dbPath, onCreate: (db, version) {
      return db.execute(''' 
        CREATE TABLE IF NOT EXISTS scores(
          id TEXT PRIMARY KEY,
          scoreName TEXT NOT NULL,
          isFavorited INTEGER NOT NULL,
          lastOpened INTEGER NOT NULL,
          uploaded INTEGER NOT NULL,
          pdfFile STRING NOT NULL,
          thumbnailImage STRING NOT NULL
        )
      ''');
    }, version: 1);
  }

  static Future<void> closeDatabase() async {
    if (db != null && db!.isOpen) await db!.close();
  }

  static Future<void> insertScore(Map<String, dynamic> score) async {
    await openDatabase();
    await db!.insert(
      'scores',
      score,
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
  }

  static Future<void> updateScore(Map<String, dynamic> score, String id) async {
    await openDatabase();
    await db!.update(
      'scores',
      score,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  static Future<void> deleteScore(String id) async {
    await openDatabase();
    await db!.delete(
      'scores',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  static Future<Map<String, dynamic>?> getScore(String id) async {
    await openDatabase();
    final List<Map<String, dynamic>> maps =
        await db!.query('scores', where: 'id = ?', whereArgs: [id]);

    if (maps.isEmpty) {
      return null;
    }

    return maps.first;
  }

  static Future<List<Map<String, dynamic>>> getAllScores() async {
    await openDatabase();
    final List<Map<String, dynamic>> maps = await db!.query('scores');

    return maps;
  }
}
