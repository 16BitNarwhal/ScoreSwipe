import 'package:flutter_test/flutter_test.dart';
import 'package:pdfplayer/features/score_browser/data/local_score_datasource.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:pdfplayer/features/score_browser/models/score_model.dart';
import 'package:uuid/uuid.dart';
import 'package:sqflite/sqflite.dart';

/// Initialize sqflite for test.
void sqfliteTestInit() {
  // Initialize ffi implementation
  sqfliteFfiInit();
  // Set global factory
  databaseFactory = databaseFactoryFfi;
}

void main() {
  sqfliteTestInit();
  group('LocalScoreDataSource', () {
    setUp(() async {
      await LocalScoreDataSource.openDatabase();
    });

    tearDown(() async {
      await LocalScoreDataSource.closeDatabase();
    });
    test('insertScore should insert a score into the database', () async {
      await LocalScoreDataSource.openDatabase();

      final score = ScoreModel(
        id: const Uuid().v4(),
        scoreName: 'Test Score',
        isFavorite: true,
        lastOpened: DateTime.now(),
        uploaded: DateTime.now(),
        pdfFile: 'SOME PDF FILE',
        thumbnailImage: 'SOME THUMBNAIL',
      );

      LocalScoreDataSource.insertScore(score);

      final result = await LocalScoreDataSource.getScore(score.id.toString());
      expect(result, score);
    });
  });
}
