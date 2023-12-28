// import 'package:flutter_test/flutter_test.dart';
// import 'package:uuid/uuid.dart';
// import 'package:score_swipe/features/score_browser/data/local_score_datasource.dart';
// import 'package:score_swipe/features/score_browser/models/score_model.dart';
// import 'dart:typed_data';
// import 'dart:io';

// void main() {
//   group('LocalScoreDataSource', () {
//     setUp(() async {
//       await LocalScoreDataSource.openDatabase();
//     });

//     tearDown(() async {
//       await LocalScoreDataSource.closeDatabase();
//     });
//   });

//   test('insertScore should insert a score into the database', () async {
//     await LocalScoreDataSource.openDatabase();
//     final score = ScoreModel(
//       id: const Uuid().v4(),
//       scoreName: 'Test Score',
//       isFavorite: true,
//       lastOpened: DateTime.now(),
//       uploaded: DateTime.now(),
//       pdfFile: File(''),
//       thumbnailImage: ByteData(0),
//     );

//     LocalScoreDataSource.insertScore(score);

//     final result = await LocalScoreDataSource.getScore(score.id.toString());
//     expect(result, score);
//   });

//   test('updateScore should update a score in the database', () async {
//     final score = ScoreModel(
//       id: const Uuid().v4(),
//       scoreName: 'Test Score',
//       isFavorite: true,
//       lastOpened: DateTime.now(),
//       uploaded: DateTime.now(),
//       pdfFile: File(''),
//       thumbnailImage: ByteData(0),
//     );

//     await LocalScoreDataSource.insertScore(score);

//     final updatedScore = ScoreModel(
//       id: score.id,
//       scoreName: 'Updated Score',
//       isFavorite: false,
//       lastOpened: DateTime.now(),
//       uploaded: DateTime.now(),
//       pdfFile: File(''),
//       thumbnailImage: ByteData(0),
//     );

//     await LocalScoreDataSource.updateScore(updatedScore);

//     final result = await LocalScoreDataSource.getScore(score.id.toString());
//     expect(result, updatedScore);
//   });

//   test('deleteScore should delete a score from the database', () async {
//     final score = ScoreModel(
//       id: const Uuid().v4(),
//       scoreName: 'Test Score',
//       isFavorite: true,
//       lastOpened: DateTime.now(),
//       uploaded: DateTime.now(),
//       pdfFile: File(''),
//       thumbnailImage: ByteData(0),
//     );

//     await LocalScoreDataSource.insertScore(score);

//     await LocalScoreDataSource.deleteScore(score.id.toString());

//     final result = await LocalScoreDataSource.getScore(score.id.toString());
//     expect(result, null);
//   });

//   test('getAllScores should return all scores from the database', () async {
//     final score1 = ScoreModel(
//       id: const Uuid().v4(),
//       scoreName: 'Test Score 1',
//       isFavorite: true,
//       lastOpened: DateTime.now(),
//       uploaded: DateTime.now(),
//       pdfFile: File(''),
//       thumbnailImage: ByteData(0),
//     );

//     final score2 = ScoreModel(
//       id: const Uuid().v4(),
//       scoreName: 'Test Score 2',
//       isFavorite: true,
//       lastOpened: DateTime.now(),
//       uploaded: DateTime.now(),
//       pdfFile: File(''),
//       thumbnailImage: ByteData(0),
//     );

//     await LocalScoreDataSource.insertScore(score1);
//     await LocalScoreDataSource.insertScore(score2);

//     final result = await LocalScoreDataSource.getAllScores();
//     expect(result, [score1, score2]);
//   });
// }
