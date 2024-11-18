// ignore_for_file: avoid_print, no_leading_underscores_for_local_identifiers

// lib/utilities/image_picker_utils.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

pickImage(ImageSource source) async {
  final ImagePicker _imagePicker = ImagePicker();
  XFile? _file = await _imagePicker.pickImage(source: source);
  if (_file != null) {
    return await _file.readAsBytes();
  }
  print('No Images Selected');
}



class ImagePickerUtils {
  static final ImagePicker _picker = ImagePicker();

  static Future<dynamic> pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        return kIsWeb ? pickedFile : File(pickedFile.path);
      }
      return null;
    } catch (e) {
      print('Error picking image: $e');
      return null;
    }
  }

  static Future<void> showImageSourceDialog(BuildContext context, Function(dynamic) onImagePicked) async {
    List<Widget> options = [
      ListTile(
        leading: Icon(Icons.photo_library),
        title: Text('Gallery'),
        onTap: () async {
          Navigator.pop(context);
          final image = await pickImage(ImageSource.gallery);
          if (image != null) onImagePicked(image);
        },
      ),
    ];

    if (!kIsWeb) {
      options.insert(0, ListTile(
        leading: Icon(Icons.camera_alt),
        title: Text('Camera'),
        onTap: () async {
          Navigator.pop(context);
          final image = await pickImage(ImageSource.camera);
          if (image != null) onImagePicked(image);
        },
      ));
    }

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Choose image source'),
          content: SingleChildScrollView(
            child: ListBody(children: options),
          ),
        );
      },
    );
  }

  static Future<String?> uploadImage(dynamic imageFile, String folder) async {
    if (imageFile == null) return null;

    try {
      final storageRef = FirebaseStorage.instance.ref();
      final imageRef = storageRef.child('$folder/${DateTime.now().millisecondsSinceEpoch}.jpg');
      
      UploadTask uploadTask;
      if (kIsWeb) {
        final bytes = await (imageFile as XFile).readAsBytes();
        uploadTask = imageRef.putData(bytes);
      } else {
        uploadTask = imageRef.putFile(imageFile as File);
      }

      final snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }
}