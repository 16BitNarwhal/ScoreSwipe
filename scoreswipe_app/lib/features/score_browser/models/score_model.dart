import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:uuid/uuid.dart';
import 'package:pdf_render/pdf_render.dart';
import 'dart:convert';

import 'package:logger/logger.dart';

class ScoreModel {
  final String id;
  String scoreName;
  bool isFavorite;
  DateTime lastOpened;
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
      'lastOpened': lastOpened.microsecondsSinceEpoch,
      'uploaded': uploaded.microsecondsSinceEpoch,
      'pdfFile': pdfFile,
      'thumbnailImage': thumbnailImage,
    };
  }

  factory ScoreModel.fromMap(Map<String, dynamic> map) {
    Logger().d('ScoreModel.fromMap: $map');
    try {
      return ScoreModel(
        id: map['id'] as String,
        scoreName: map['scoreName'] as String,
        isFavorite: map['isFavorited'] == 1 ? true : false,
        lastOpened: DateTime.fromMicrosecondsSinceEpoch(map['lastOpened']),
        uploaded: DateTime.fromMicrosecondsSinceEpoch(map['uploaded']),
        pdfFile: map['pdfFile'] as String,
        thumbnailImage: map['thumbnailImage'] as String,
      );
    } catch (error) {
      Logger().e('ScoreModel.fromMap: $error');
      rethrow;
    }
  }

  // TODO: move this to a separate class
  Future<String> createThumbnailImage() async {
    PdfDocument doc = await PdfDocument.openData(base64Decode(pdfFile));
    PdfPage page = await doc.getPage(1);
    PdfPageImage pdfImage = await page.render();
    doc.dispose();
    Image image = await pdfImage.createImageDetached();
    ByteData? imgBytes = await image.toByteData(format: ImageByteFormat.png);

    if (imgBytes == null) {
      throw Exception('Could not create thumbnail image');
    }

    thumbnailImage = base64Encode(imgBytes.buffer.asUint8List());
    return thumbnailImage!;
  }

  Uint8List getThumbnailImage() {
    return Uint8List.fromList(base64Decode(thumbnailImage!));
  }

  @override
  String toString() {
    return 'ScoreModel(id: $id, scoreName: $scoreName, isFavorited: $isFavorite, lastOpened: $lastOpened, uploaded: $uploaded\npdfFile: $pdfFile\nthumbnailImage: $thumbnailImage)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ScoreModel &&
        other.id == id &&
        other.scoreName == scoreName &&
        other.isFavorite == isFavorite &&
        other.lastOpened.difference(lastOpened).inSeconds < 1 &&
        other.uploaded.difference(uploaded).inSeconds < 1 &&
        other.pdfFile == pdfFile &&
        other.thumbnailImage == thumbnailImage;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        scoreName.hashCode ^
        isFavorite.hashCode ^
        lastOpened.hashCode ^
        uploaded.hashCode;
  }
}
