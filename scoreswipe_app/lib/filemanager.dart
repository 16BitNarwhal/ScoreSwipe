import 'dart:io';
import 'package:file_picker/file_picker.dart';

class FileManager {
  static Future<String?> systemFilePicker() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
        allowMultiple: false);

    if (result == null) return null;
    return result.files.single.path;
  }
}
