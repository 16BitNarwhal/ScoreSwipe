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
  String scoreName;
  bool isFavorite;
  DateTime lastOpened;
  final DateTime uploaded;
  final File pdfFile;
  final File thumbnailImage;

  ScoreModel(
      {required this.id,
      required this.scoreName,
      required this.isFavorite,
      required this.lastOpened,
      required this.uploaded,
      required this.pdfFile,
      required this.thumbnailImage});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'scoreName': scoreName,
      'isFavorited': isFavorite ? 1 : 0,
      'lastOpened': lastOpened.millisecondsSinceEpoch,
      'uploaded': uploaded.millisecondsSinceEpoch,
      'pdfFile': pdfFile.path,
      'thumbnailImage': thumbnailImage.path,
    };
  }

  ScoreModel copyWith({
    String? id,
    String? scoreName,
    bool? isFavorite,
    DateTime? lastOpened,
    DateTime? uploaded,
    File? pdfFile,
    File? thumbnailImage,
  }) {
    return ScoreModel(
      id: id ?? this.id,
      scoreName: scoreName ?? this.scoreName,
      isFavorite: isFavorite ?? this.isFavorite,
      lastOpened: lastOpened ?? this.lastOpened,
      uploaded: uploaded ?? this.uploaded,
      pdfFile: pdfFile ?? this.pdfFile,
      thumbnailImage: thumbnailImage ?? this.thumbnailImage,
    );
  }

  @override
  String toString() {
    return 'ScoreModel(id: $id, scoreName: $scoreName, isFavorited: $isFavorite, lastOpened: $lastOpened, uploaded: $uploaded)';
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
        other.pdfFile.path == pdfFile.path &&
        other.thumbnailImage.path == thumbnailImage.path;
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
