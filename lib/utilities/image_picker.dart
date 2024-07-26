// ignore_for_file: unused_import, no_leading_underscores_for_local_identifiers, avoid_print

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

pickImage(ImageSource source) async{
final ImagePicker _imagePicker = ImagePicker();
XFile? _file = await _imagePicker.pickImage(source: source);
if(_file != null){
  return await _file.readAsBytes();
}
print('No Images Selected');
}