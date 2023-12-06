import 'dart:convert';

class ScoreModel {
  final String id;
  final String title;
  final List<String> genres;
  final bool isFavorite;
  final DateTime lastOpened;
  final DateTime uploaded;

  ScoreModel(
      {required this.id,
      required this.title,
      required this.genres,
      required this.isFavorite,
      required this.lastOpened,
      required this.uploaded});

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "title": title,
      "genres": genres,
      "isFavorite": isFavorite,
      "lastOpened": lastOpened.toString(),
      "uploaded": uploaded.toString(),
    };
  }

  factory ScoreModel.fromMap(Map<String, dynamic> map) {
    return ScoreModel(
        id: map["_id"],
        title: map["title"],
        genres: map["genres"].map((e) => e.toString()).toList(),
        isFavorite: map["isFavorite"],
        lastOpened: DateTime.parse(map["lastOpened"]),
        uploaded: DateTime.parse(map["uploaded"]));
  }

  String toJson() => json.encode(toMap());

  factory ScoreModel.fromJson(String source) =>
      ScoreModel.fromMap(json.decode(source));

  ScoreModel copyWith({
    String? id,
    String? title,
    List<String>? genres,
    bool? isFavorite,
    DateTime? lastOpened,
    DateTime? uploaded,
  }) {
    return ScoreModel(
      id: id ?? this.id,
      title: title ?? this.title,
      genres: genres ?? this.genres,
      isFavorite: isFavorite ?? this.isFavorite,
      lastOpened: lastOpened ?? this.lastOpened,
      uploaded: uploaded ?? this.uploaded,
    );
  }
}
