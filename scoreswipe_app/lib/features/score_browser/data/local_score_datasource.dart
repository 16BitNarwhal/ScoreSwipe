import 'dart:async';
import 'dart:typed_data';
import 'dart:io';
import 'package:pdfplayer/features/score_browser/models/score_model.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart';

import 'package:logger/logger.dart';

class LocalScoreDataSource {
  static late sql.Database db;

  static Future<void> openDatabase() async {
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
          thumbnailImage STRING
        )
      ''');
    }, version: 1);
  }

  static Future<void> closeDatabase() async {
    db.close();
  }

  static Future<void> insertScore(ScoreModel score) async {
    await db.insert(
      'scores',
      score.toMap(),
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
  }

  static Future<void> updateScore(ScoreModel score) async {
    await db.update(
      'scores',
      score.toMap(),
      where: 'id = ?',
      whereArgs: [score.id],
    );
  }

  static Future<void> deleteScore(String id) async {
    Logger().wtf('Deleting score $id');
    await db.delete(
      'scores',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  static Future<ScoreModel?> getScore(String id) async {
    final List<Map<String, dynamic>> maps =
        await db.query('scores', where: 'id = ?', whereArgs: [id]);

    if (maps.isEmpty) {
      return null;
    }

    return ScoreModel.fromMap(maps.first);
  }

  static Future<List<ScoreModel>> getAllScores() async {
    final List<Map<String, dynamic>> maps = await db.query('scores');

    Logger().i(maps.length);

    return List.generate(maps.length, (i) {
      return ScoreModel.fromMap(maps[i]);
    });
  }
}
