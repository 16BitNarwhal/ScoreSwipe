// import 'dart:ffi';
// import 'dart:io';
// import '../data/file_datasource.dart';
// import 'score_model.dart';
// import 'package:file_picker/file_picker.dart';

// // deals with score data
// class LocalScoreRepository {
//   static Future<List<ScoreModel>> listAllScores() async {
//     List<File> files = await LocalFileDatasource.listAllFiles("pdf");
//     List<ScoreModel> scores = [];
//     for (File file in files) {
//       ScoreModel score = await loadScoreFromPath(file.path);
//       scores.add(score);
//     }
//     return scores;
//   }

//   static Future<ScoreModel> loadScoreFromPath(String path) async {
//     File metadata =
//         await LocalFileDatasource.loadFile("${path.split("/").last}.metadata");
//     String metadataString = await metadata.readAsString();
//     return ScoreModel.fromJson(metadataString);
//   }

//   static Future<List<ScoreModel>> addScoresFromFilePicker() async {
//     FilePickerResult? result = await FilePicker.platform.pickFiles(
//         type: FileType.custom, allowedExtensions: ['pdf'], allowMultiple: true);
//     if (result == null || result.files.isEmpty) return [];

//     List<ScoreModel> scores = [];
//     List<Future<void>> asyncTasks = [];
//     for (PlatformFile file in result.files) {
//       if (file.path == null) continue;
//       ScoreModel score = ScoreModel(
//           id: file.path!.split("/").last,
//           title: file.path!.split("/").last,
//           genres: [],
//           isFavorite: false,
//           lastOpened: DateTime.now(),
//           uploaded: DateTime.now());
//       scores.add(score);
//       asyncTasks.add(saveScore(score));
//     }
//     await Future.wait(asyncTasks);
//     return scores;
//   }

//   static Future<void> saveScore(ScoreModel score) async {
//     await LocalFileDatasource.saveString(
//         score.toJson(), "${score.id}.metadata");
//   }

//   static Future<void> deleteScore(ScoreModel score) async {
//     File metadata = await LocalFileDatasource.loadFile("${score.id}.metadata");
//     await LocalFileDatasource.deleteFile(metadata);
//     File pdf = await LocalFileDatasource.loadFile("${score.id}.pdf");
//     await LocalFileDatasource.deleteFile(pdf);
//   }

//   static Future<void> updateScore(ScoreModel updatedScore) async {
//     await deleteScore(updatedScore);
//     await saveScore(updatedScore);
//   }
// }
