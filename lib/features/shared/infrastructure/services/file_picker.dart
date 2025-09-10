

import 'dart:io';
import 'package:file_picker/file_picker.dart';


class FilePickerAdapter {
  
  Future<File?> pickFile() async {

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx', 'pdf',],
    );

    if (result != null) {
      return File(result.files.single.path!);
    }
    return null;
  }
  
}