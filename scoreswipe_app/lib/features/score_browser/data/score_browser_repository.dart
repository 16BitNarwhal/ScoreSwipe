import 'dart:io';
import 'local_file_datasource.dart';
import '../models/score_model.dart';

abstract class ScoreRepository {
  Future<List<ScoreModel>> listAllScores();
  Future<ScoreModel> loadScore(String id);
  Future<void> saveScore(ScoreModel score);
  Future<void> deleteScore(ScoreModel score);
  Future<void> updateScore(ScoreModel score);
  Future<void> pickAndAddScores();
  Future<void> addScores(List<File> files);
}

class LocalScoreRepository implements ScoreRepository {
  LocalScoreRepository();

  @override
  Future<List<ScoreModel>> listAllScores() async {
    List<File> files = await LocalFileDatasource.listAllFiles("pdf");
    List<ScoreModel> scores = [];
    for (File file in files) {
      ScoreModel score = await loadScore(file.path);
      scores.add(score);
    }
    return scores;
  }

  @override
  Future<ScoreModel> loadScore(String id) async {
    File metadata =
        await LocalFileDatasource.loadFile("${id.split("/").last}.metadata");
    String metadataString = await metadata.readAsString();
    return ScoreModel.fromJson(metadataString);
  }

  @override
  Future<void> saveScore(ScoreModel score) async {
    await LocalFileDatasource.saveString(
        score.toJson(), "${score.id}.metadata");
  }

  @override
  Future<void> deleteScore(ScoreModel score) async {
    File metadata = await LocalFileDatasource.loadFile("$score.id.metadata");
    await LocalFileDatasource.deleteFile(metadata);
    File pdf = await LocalFileDatasource.loadFile("${score.id}.pdf");
    await LocalFileDatasource.deleteFile(pdf);
  }

  @override
  Future<void> updateScore(ScoreModel updatedScore) async {
    await deleteScore(updatedScore);
    await saveScore(updatedScore);
  }

  @override
  Future<void> pickAndAddScores() async {
    List<File>? files = await LocalFileDatasource.pickMultipleFiles();
    if (files == null) return;
    await addScores(files);
  }

  @override
  Future<void> addScores(List<File> files) async {
    for (File file in files) {
      ScoreModel score = ScoreModel(
          id: file.path.split("/").last,
          title: file.path.split("/").last,
          genres: [],
          isFavorite: false,
          lastOpened: DateTime.now(),
          uploaded: DateTime.now());
      await saveScore(score);
    }
  }
}
