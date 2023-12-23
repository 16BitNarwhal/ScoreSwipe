import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:uuid/uuid.dart';

import '../models/score_model.dart';
import 'local_score_datasource.dart';

import 'package:logger/logger.dart';

class LocalScoreRepository {
  static Future<void> insertScoreFromImages(List<File> images,
      {String? scoreName}) async {
    pw.Document pdf = pw.Document();
    for (File image in images) {
      pdf.addPage(pw.Page(
        margin: pw.EdgeInsets.zero,
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Image(pw.MemoryImage(image.readAsBytesSync())),
          );
        },
      ));
    }

    Directory dir = await getApplicationDocumentsDirectory();

    File doc = File('${dir.path}/$scoreName.pdf');
    await doc.writeAsBytes(await pdf.save());

    File thumbnail = File('${dir.path}/$scoreName.png');
    await images.first.copy(thumbnail.path);

    ScoreModel score = ScoreModel(
      id: const Uuid().v4(),
      scoreName: scoreName!,
      isFavorite: false,
      lastOpened: DateTime.now(),
      uploaded: DateTime.now(),
      pdfFile: doc,
      thumbnailImage: thumbnail,
    );

    await LocalScoreDataSource.insertScore(score.toMap());
  }

  static Future<void> updateScore(ScoreModel score) async {
    await LocalScoreDataSource.updateScore(score.toMap(), score.id);
  }

  static Future<void> deleteScore(String id) async {
    ScoreModel? score = await getScore(id);
    if (score != null) {
      List<Future<void>> futures = [
        score.pdfFile.delete(),
        score.thumbnailImage.delete(),
        LocalScoreDataSource.deleteScore(id),
      ];
      await Future.wait(futures);
    }
  }

  static Future<ScoreModel?> getScore(String id) async {
    Map<String, dynamic>? map = await LocalScoreDataSource.getScore(id);

    if (map == null) return null;
    return scoreFromMap(map);
  }

  static Future<List<ScoreModel>> getAllScores() async {
    List<Map<String, dynamic>> scoreMaps =
        await LocalScoreDataSource.getAllScores();
    return List.generate(
        scoreMaps.length, (index) => scoreFromMap(scoreMaps[index]));
  }

  static ScoreModel scoreFromMap(Map<String, dynamic> map) {
    return ScoreModel(
      id: map['id'] as String,
      scoreName: map['scoreName'] as String,
      isFavorite: map['isFavorited'] == 1 ? true : false,
      lastOpened: DateTime.fromMillisecondsSinceEpoch(map['lastOpened']),
      uploaded: DateTime.fromMillisecondsSinceEpoch(map['uploaded']),
      pdfFile: File(map['pdfFile']),
      thumbnailImage: File(map['thumbnailImage']),
    );
  }
}
