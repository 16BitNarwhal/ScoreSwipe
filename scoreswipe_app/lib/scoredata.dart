import 'dart:io';
import 'dart:convert';
import 'filemanager.dart';

class ScoreData {
  File pdfFile;

  late File metadataFile;

  late String title;
  late List<String> genres;
  late bool isFavorite;
  late DateTime lastOpened;
  late DateTime uploaded;

  ScoreData(this.pdfFile) {
    print("Creating score data object for ${pdfFile.path}");
    String metadataPath = "${pdfFile.path}.metadata";
    metadataFile = File(metadataPath);
  }

  Future<void> init() async {
    await loadMetadata();
  }

  Future<void> loadMetadata() async {
    if (!(await metadataFile.exists())) {
      print("Metadata file does not exist, creating");
      await metadataFile.create();
      print("Created metadata file");
      await saveMetadata();
      print("Saved metadata");
    }
    String metadataString = await metadataFile.readAsString();
    print("Loaded Metadata");
    Map<String, dynamic> metadata;
    if (metadataString == "") {
      metadata = {};
    } else {
      metadata = jsonDecode(metadataString);
    }
    print("Decoded metadata: $metadata");

    if (metadata["title"] != null && metadata["title"].runtimeType == String) {
      title = metadata["title"];
    } else {
      title = pdfFile.path
          .split('/')
          .last
          .substring(0, pdfFile.path.split('/').last.length - 4);
    }
    if (metadata["genres"] != null &&
        metadata["genres"].runtimeType == List<String>) {
      genres = metadata["genres"].map((e) => e.toString()).toList();
    } else {
      genres = [];
    }
    if (metadata["isFavorite"] != null &&
        metadata["isFavorite"].runtimeType == bool) {
      isFavorite = metadata["isFavorite"];
    } else {
      isFavorite = false;
    }
    if (metadata["lastOpened"] != null &&
        metadata["lastOpened"].runtimeType == String) {
      lastOpened = DateTime.parse(metadata["lastOpened"]);
    } else {
      lastOpened = DateTime.now();
    }
    if (metadata["uploaded"] != null &&
        metadata["uploaded"].runtimeType == String) {
      uploaded = DateTime.parse(metadata["uploaded"]);
    } else {
      uploaded = DateTime.now();
    }
    saveMetadata();
  }

  void setTitle(String newTitle) {
    title = newTitle;
    saveMetadata();
  }

  void setGenres(List<String> newGenres) {
    genres = newGenres;
    saveMetadata();
  }

  void toggleFavorite() {
    isFavorite = !isFavorite;
    saveMetadata();
  }

  void setLastOpened() {
    lastOpened = DateTime.now();
    saveMetadata();
  }

  Future<void> saveMetadata() async {
    print("Saving metadata");
    Map<String, dynamic> metadata = {
      "title": title,
      "genres": genres,
      "isFavorite": isFavorite,
      "lastOpened": lastOpened.toString(),
      "uploaded": uploaded.toString(),
    };
    print("Metadata: $metadata");
    if (!(await metadataFile.exists())) {
      print("Metadata file does not exist, creating");
      await metadataFile.create();
    }
    print("Writing metadata: $metadata");
    await metadataFile.writeAsString(jsonEncode(metadata), flush: true);
  }

  Future<void> deleteScore() async {
    await pdfFile.delete();
    File metadataFile = File("${pdfFile.path}.metadata");
    await metadataFile.delete();
  }

  @override
  String toString() {
    return "ScoreData: $title";
  }

  static Future<List<ScoreData>> getAllScores() async {
    List<ScoreData> scores = [];

    List<File> pdfFiles = await FileManager.listAllPdfFiles();
    print("Found ${pdfFiles.length} pdf files");
    print("Searching for metadata files");
    for (File file in pdfFiles) {
      ScoreData scoreData = ScoreData(file);
      print("Found metadata file for ${file.path}");
      await scoreData.init();

      print("Generated score data");
      scores.add(scoreData);
    }
    print("Found ${scores.length} scores");
    print(scores);
    return scores;
  }
}
