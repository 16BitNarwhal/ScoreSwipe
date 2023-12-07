import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:pdf_render/pdf_render.dart';

class FileManager {
  static Future<File?> systemPickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
        allowMultiple: false);

    if (result == null) return null;
    if (result.files.isEmpty) return null;

    return File(result.files.single.path!);
  }

  static Future<List<File>?> systemMultipleFilePicker() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom, allowedExtensions: ['pdf'], allowMultiple: true);

    if (result == null) return null;
    if (result.files.isEmpty) return null;

    List<File> files = [];
    for (PlatformFile file in result.files) {
      files.add(File(file.path!));
    }
    return files;
  }

  static void systemPickAndUploadFile() async {
    List<File>? files = await systemMultipleFilePicker();
    if (files == null) return;

    Directory appDirectory = await getApplicationDocumentsDirectory();
    // save picked files to app directory
    for (File file in files) {
      String newPath = "${appDirectory.path}/${file.path.split("/").last}";
      await file.copy(newPath);
    }
  }

  static void systemDeleteFile(File file) async {
    await file.delete();
  }

  static Future<Directory?> systemPickDirectory() async {
    String? directory = await FilePicker.platform.getDirectoryPath();
    if (directory == null) return null;
    return Directory(directory);
  }

  static Future<List<File>> listAllPdfFiles() async {
    List<File> pdfFiles = [];

    Directory appDirectory = await getApplicationDocumentsDirectory();

    appDirectory.listSync(recursive: true).forEach((element) {
      if (element is File) {
        if (element.path.endsWith(".pdf")) {
          pdfFiles.add(element);
        }
      }
    });

    return pdfFiles;
  }

  static Future<RawImage?> getThumbnail(File file,
      {int? width, int? height}) async {
    PdfDocument doc = await PdfDocument.openFile(file.path);
    PdfPage page = await doc.getPage(1);
    PdfPageImage pageImage = await page.render();
    doc.dispose();
    await pageImage.createImageIfNotAvailable();
    RawImage image = RawImage(
      image: pageImage.imageIfAvailable,
      fit: BoxFit.fitWidth,
      alignment: Alignment.topCenter,
    );
    return image;
  }
}
