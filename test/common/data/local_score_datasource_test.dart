import 'package:flutter_test/flutter_test.dart';
import 'package:score_swipe/common/data/local_score_datasource.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

Future<void> sqfliteTestInit() async {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
  String path = await databaseFactoryFfi.getDatabasesPath();
  await databaseFactoryFfi.deleteDatabase('$path/scores.db');
}

void main() async {
  await sqfliteTestInit();

  group('LocalScoreDataSource', () {
    List<Map<String, dynamic>> scores = [];

    setUp(() async {
      await LocalScoreDataSource.openDatabase();
    });

    tearDown(() async {
      await LocalScoreDataSource.closeDatabase();
    });

    test('should insert and retrieve a score from the database', () async {
      Map<String, dynamic> score = {
        'id': 'abc1',
        'scoreName': 'Test Score',
        'isFavorited': 1,
        'lastOpened': 1000,
        'uploaded': 1000,
        'pdfFile': 'pdf_location.pdf',
        'thumbnailImage': 'image_location.png',
      };

      LocalScoreDataSource.insertScore(score);

      final result = await LocalScoreDataSource.getScore(score['id']);
      expect(result, score);

      scores.add(score);
    });

    test('updateScore should update the score in the database', () async {
      Map<String, dynamic> score = {
        'id': 'abc2',
        'scoreName': 'Test Score',
        'isFavorited': 1,
        'lastOpened': 1000,
        'uploaded': 1000,
        'pdfFile': 'pdf_location.pdf',
        'thumbnailImage': 'image_location.png',
      };
      await LocalScoreDataSource.insertScore(score);

      Map<String, dynamic> updatedScore = {
        'id': score['id'],
        'scoreName': 'Updated Score',
        'isFavorited': 0,
        'lastOpened': 2000,
        'uploaded': 2000,
        'pdfFile': 'updated_pdf_location.pdf',
        'thumbnailImage': 'updated_image_location.png',
      };
      await LocalScoreDataSource.updateScore(updatedScore, score['id']);

      final result = await LocalScoreDataSource.getScore(score['id']);
      expect(result, updatedScore);

      scores.add(updatedScore);
    });

    test('deleteScore should delete the score from the database', () async {
      Map<String, dynamic> score = {
        'id': 'abc3',
        'scoreName': 'Test Score',
        'isFavorited': 1,
        'lastOpened': 1000,
        'uploaded': 1000,
        'pdfFile': 'pdf_location.pdf',
        'thumbnailImage': 'image_location.png',
      };
      await LocalScoreDataSource.insertScore(score);

      await LocalScoreDataSource.deleteScore(score['id']);

      final result = await LocalScoreDataSource.getScore(score['id']);
      expect(result, null);
    });

    test('getAllScores should return all scores in the database', () async {
      final result = await LocalScoreDataSource.getAllScores();
      expect(result, scores);
    });
  });
}
