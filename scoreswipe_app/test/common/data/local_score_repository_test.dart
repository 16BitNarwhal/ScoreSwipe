import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:score_swipe/common/data/local_score_repository.dart';
import 'package:score_swipe/common/models/score_model.dart';
import 'dart:io';

/// Initialize sqflite for test.
void sqfliteTestInit() async {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
  String path = await databaseFactoryFfi.getDatabasesPath();
  await databaseFactoryFfi.deleteDatabase('$path/scores.db');
}

void mockPath() {
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(
          const MethodChannel('plugins.flutter.io/path_provider'),
          (MethodCall methodCall) async {
    return '.';
  });
}

// TODO:
void mockIO() {
  // will need to mock the actual file system
  // todo this, I need to make my own impl of the file system,
  // use it in my app, and then mock it here
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(
          const MethodChannel('plugins.flutter.io/dart:io'),
          (MethodCall methodCall) async {
    return null;
  });
}

void main() {
  // TestWidgetsFlutterBinding.ensureInitialized();

  // setUpAll(() {
  //   sqfliteTestInit();
  //   mockPath();
  //   mockIO();
  // });

  // group('LocalScoreRepository', () {
  //   tearDown(() {
  //     LocalScoreRepository.close();
  //   });

  //   test('should insert images into the database', () async {
  //     List<File> images = [
  //       File('test/assets/test_image.png'),
  //       File('test/assets/test_image.png'),
  //       File('test/assets/test_image.png'),
  //     ];

  //     ScoreModel score = await LocalScoreRepository.insertScoreFromImages(
  //         images,
  //         scoreName: 'test_score');

  //     ScoreModel? retrievedScore =
  //         await LocalScoreRepository.getScore(score.id);

  //     expect(score, retrievedScore);
  //   });

  //   test('should update a score in the database', () async {
  //     List<File> images = [
  //       File('test/assets/test_image.png'),
  //       File('test/assets/test_image.png'),
  //       File('test/assets/test_image.png'),
  //     ];

  //     ScoreModel score = await LocalScoreRepository.insertScoreFromImages(
  //         images,
  //         scoreName: 'test_score');

  //     ScoreModel updatedScore = score.copyWith(scoreName: 'Updated Score');
  //     await LocalScoreRepository.updateScore(updatedScore);

  //     ScoreModel? retrievedScore =
  //         await LocalScoreRepository.getScore(score.id);

  //     expect(retrievedScore, updatedScore);
  //   });

  //   test('should delete a score from the database', () async {
  //     List<File> images = [
  //       File('test/assets/test_image.png'),
  //       File('test/assets/test_image.png'),
  //       File('test/assets/test_image.png'),
  //     ];

  //     ScoreModel score = await LocalScoreRepository.insertScoreFromImages(
  //         images,
  //         scoreName: 'test_score');

  //     await LocalScoreRepository.deleteScore(score.id);

  //     ScoreModel? retrievedScore =
  //         await LocalScoreRepository.getScore(score.id);

  //     expect(retrievedScore, null);
  //   });

  //   test('should retrieve all scores', () async {
  //     // clear scores first
  //     List<ScoreModel> deletedScores =
  //         await LocalScoreRepository.getAllScores();
  //     for (ScoreModel score in deletedScores) {
  //       await LocalScoreRepository.deleteScore(score.id);
  //     }

  //     List<File> images = [
  //       File('test/assets/test_image.png'),
  //       File('test/assets/test_image.png'),
  //       File('test/assets/test_image.png'),
  //     ];

  //     List<ScoreModel> scores = [];
  //     for (int i = 0; i < 3; i++) {
  //       ScoreModel score = await LocalScoreRepository.insertScoreFromImages(
  //           images,
  //           scoreName: 'test_score $i');
  //       scores.add(score);
  //     }

  //     List<ScoreModel> retrievedScores =
  //         await LocalScoreRepository.getAllScores();

  //     expect(retrievedScores, scores);

  //     for (ScoreModel score in scores) {
  //       await LocalScoreRepository.deleteScore(score.id);
  //     }
  //   });
  // });
}
