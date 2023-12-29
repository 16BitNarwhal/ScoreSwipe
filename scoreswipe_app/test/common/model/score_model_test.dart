import 'package:flutter_test/flutter_test.dart';
import 'package:score_swipe/common/models/score_model.dart';
import 'dart:io';

void main() {
  group('ScoreModel', () {
    test('should return a valid ScoreModel', () {
      ScoreModel score = ScoreModel(
        id: 'abc1',
        scoreName: 'Test Score',
        isFavorite: true,
        lastOpened: DateTime.fromMillisecondsSinceEpoch(1000),
        uploaded: DateTime.fromMillisecondsSinceEpoch(1000),
        pdfFile: File('pdf_location.pdf'),
        thumbnailImage: File('image_location.png'),
      );

      expect(score.id, 'abc1');
      expect(score.scoreName, 'Test Score');
      expect(score.isFavorite, true);
      expect(score.lastOpened, DateTime.fromMillisecondsSinceEpoch(1000));
      expect(score.uploaded, DateTime.fromMillisecondsSinceEpoch(1000));
      expect(score.pdfFile.path, 'pdf_location.pdf');
      expect(score.thumbnailImage.path, 'image_location.png');
    });

    test('should create a valid map from ScoreModel', () {
      ScoreModel score = ScoreModel(
        id: 'abc1',
        scoreName: 'Test Score',
        isFavorite: true,
        lastOpened: DateTime.fromMillisecondsSinceEpoch(1000),
        uploaded: DateTime.fromMillisecondsSinceEpoch(1000),
        pdfFile: File('pdf_location.pdf'),
        thumbnailImage: File('image_location.png'),
      );

      Map<String, dynamic> scoreMap = score.toMap();

      expect(scoreMap['id'], 'abc1');
      expect(scoreMap['scoreName'], 'Test Score');
      expect(scoreMap['isFavorited'], 1);
      expect(scoreMap['lastOpened'], 1000);
      expect(scoreMap['uploaded'], 1000);
      expect(scoreMap['pdfFile'], 'pdf_location.pdf');
      expect(scoreMap['thumbnailImage'], 'image_location.png');
    });

    test('two scores should be equal if and only if they have same values', () {
      ScoreModel score1 = ScoreModel(
        id: 'abc1',
        scoreName: 'Test Score',
        isFavorite: true,
        lastOpened: DateTime.fromMillisecondsSinceEpoch(1000),
        uploaded: DateTime.fromMillisecondsSinceEpoch(1000),
        pdfFile: File('pdf_location.pdf'),
        thumbnailImage: File('image_location.png'),
      );

      ScoreModel score2 = ScoreModel(
        id: 'abc1',
        scoreName: 'Test Score',
        isFavorite: true,
        lastOpened: DateTime.fromMillisecondsSinceEpoch(1000),
        uploaded: DateTime.fromMillisecondsSinceEpoch(1000),
        pdfFile: File('pdf_location.pdf'),
        thumbnailImage: File('image_location.png'),
      );

      expect(score1 == score2, true);

      score2 = ScoreModel(
        id: 'abc2',
        scoreName: 'Test Score',
        isFavorite: true,
        lastOpened: DateTime.fromMillisecondsSinceEpoch(1000),
        uploaded: DateTime.fromMillisecondsSinceEpoch(1000),
        pdfFile: File('pdf_location.pdf'),
        thumbnailImage: File('image_location.png'),
      );
      expect(score1 == score2, false);

      score2 = ScoreModel(
        id: 'abc1',
        scoreName: 'Updated Score',
        isFavorite: true,
        lastOpened: DateTime.fromMillisecondsSinceEpoch(1000),
        uploaded: DateTime.fromMillisecondsSinceEpoch(1000),
        pdfFile: File('pdf_location.pdf'),
        thumbnailImage: File('image_location.png'),
      );
      expect(score1 == score2, false);

      score2 = ScoreModel(
        id: 'abc1',
        scoreName: 'Test Score',
        isFavorite: false,
        lastOpened: DateTime.fromMillisecondsSinceEpoch(1000),
        uploaded: DateTime.fromMillisecondsSinceEpoch(1000),
        pdfFile: File('pdf_location.pdf'),
        thumbnailImage: File('image_location.png'),
      );
      expect(score1 == score2, false);

      score2 = ScoreModel(
        id: 'abc1',
        scoreName: 'Test Score',
        isFavorite: true,
        lastOpened: DateTime.fromMillisecondsSinceEpoch(2000),
        uploaded: DateTime.fromMillisecondsSinceEpoch(1000),
        pdfFile: File('pdf_location.pdf'),
        thumbnailImage: File('image_location.png'),
      );
      expect(score1 == score2, false);

      score2 = ScoreModel(
        id: 'abc1',
        scoreName: 'Test Score',
        isFavorite: true,
        lastOpened: DateTime.fromMillisecondsSinceEpoch(1000),
        uploaded: DateTime.fromMillisecondsSinceEpoch(2000),
        pdfFile: File('pdf_location.pdf'),
        thumbnailImage: File('image_location.png'),
      );
      expect(score1 == score2, false);

      score2 = ScoreModel(
        id: 'abc1',
        scoreName: 'Test Score',
        isFavorite: true,
        lastOpened: DateTime.fromMillisecondsSinceEpoch(1000),
        uploaded: DateTime.fromMillisecondsSinceEpoch(1000),
        pdfFile: File('updated_pdf_location.pdf'),
        thumbnailImage: File('image_location.png'),
      );
      expect(score1 == score2, false);

      score2 = ScoreModel(
        id: 'abc1',
        scoreName: 'Test Score',
        isFavorite: true,
        lastOpened: DateTime.fromMillisecondsSinceEpoch(1000),
        uploaded: DateTime.fromMillisecondsSinceEpoch(1000),
        pdfFile: File('pdf_location.pdf'),
        thumbnailImage: File('updated_image_location.png'),
      );
      expect(score1 == score2, false);
    });
  });
}
