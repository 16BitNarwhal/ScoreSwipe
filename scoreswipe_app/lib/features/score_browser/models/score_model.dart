import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:uuid/uuid.dart';
import 'package:pdf_render/pdf_render.dart';
import 'package:image/image.dart' as imglib;
import 'dart:convert';

import 'package:logger/logger.dart';

class ScoreModel {
  final String id;
  final String scoreName;
  final bool isFavorite;
  final DateTime lastOpened;
  final DateTime uploaded;
  final String pdfFile;
  String? thumbnailImage;

  ScoreModel(
      {required this.id,
      required this.scoreName,
      required this.isFavorite,
      required this.lastOpened,
      required this.uploaded,
      required this.pdfFile,
      this.thumbnailImage});

  factory ScoreModel.fromPdfFile(File pdfFile) {
    // create thumbnail image file from first page of pdf

    return ScoreModel(
      id: const Uuid().v4(),
      scoreName: pdfFile.path.split('/').last,
      isFavorite: false,
      lastOpened: DateTime.now(),
      uploaded: DateTime.now(),
      pdfFile: base64Encode(pdfFile.readAsBytesSync()),
      thumbnailImage: "",
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'scoreName': scoreName,
      'isFavorited': isFavorite ? 1 : 0,
      'lastOpened': lastOpened.millisecondsSinceEpoch,
      'uploaded': uploaded.millisecondsSinceEpoch,
      'pdfFile': pdfFile,
      'thumbnailImage': thumbnailImage,
    };
  }

  factory ScoreModel.fromMap(Map<String, dynamic> map) {
    try {
      map.forEach((key, value) {
        Logger().wtf('$key: ${value.runtimeType}');
      });
      return ScoreModel(
        id: map['id'] as String,
        scoreName: map['scoreName'] as String,
        isFavorite: map['isFavorited'] == 1 ? true : false,
        lastOpened: DateTime.fromMillisecondsSinceEpoch(map['lastOpened']),
        uploaded: DateTime.fromMillisecondsSinceEpoch(map['uploaded']),
        pdfFile: map['pdfFile'] as String,
        thumbnailImage: map['thumbnailImage'] as String,
      );
    } catch (error) {
      Logger().e('ScoreModel.fromMap: $error');
      rethrow;
    }
  }

  // TODO: move this to a separate class
  Future<void> createThumbnailImage() async {
    // PdfDocument doc = await PdfDocument.openFile(pdfFile.path);
    // PdfPage page = await doc.getPage(1);
    // PdfPageImage pdfImage = await page.render();
    // doc.dispose();
    // Image image = await pdfImage.createImageDetached();
    // ByteData? imgBytes = await image.toByteData(format: ImageByteFormat.png);

    // if (imgBytes == null) {
    //   throw Exception('Could not create thumbnail image');
    // }

    // thumbnailImage = imgBytes;
  }

  @override
  String toString() {
    return 'ScoreModel(id: $id, scoreName: $scoreName, isFavorited: $isFavorite, lastOpened: $lastOpened, uploaded: $uploaded)';
  }
}
