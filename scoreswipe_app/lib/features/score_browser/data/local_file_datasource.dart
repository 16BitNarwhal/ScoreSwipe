import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';

class LocalFileDatasource {
  static Future<void> deleteFile(File file) async {
    await file.delete();
  }

  static Future<List<File>> listAllFiles(String extension) async {
    List<File> files = [];

    Directory appDirectory = await getApplicationDocumentsDirectory();

    List<FileSystemEntity> systemFiles = await appDirectory.list().toList();
    for (FileSystemEntity systemFile in systemFiles) {
      if (systemFile.path.endsWith(".$extension")) {
        files.add(File(systemFile.path));
      }
    }

    return files;
  }

  static Future<void> saveFile(File file) async {
    Directory appDirectory = await getApplicationDocumentsDirectory();
    String newPath = "${appDirectory.path}/${file.path.split("/").last}";
    await file.copy(newPath);
  }

  static Future<File> loadFile(String relativePath) async {
    Directory appDirectory = await getApplicationDocumentsDirectory();
    return File("${appDirectory.path}/$relativePath");
  }

  static Future<void> saveString(String string, String relativePath) async {
    Directory appDirectory = await getApplicationDocumentsDirectory();
    File file = File("${appDirectory.path}/$relativePath");
    if (!(await file.exists())) {
      await file.create();
    }
    await file.writeAsString(string);
  }

  static Future<File?> pickSingleFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
        allowMultiple: false);
    if (result == null || result.files.isEmpty) return null;

    return File(result.files.single.path!);
  }

  static Future<List<File>?> pickMultipleFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom, allowedExtensions: ['pdf'], allowMultiple: true);
    if (result == null || result.files.isEmpty) return null;

    List<File> files = [];
    for (PlatformFile file in result.files) {
      files.add(File(file.path!));
    }
    return files;
  }
}
