// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api, avoid_print, use_build_context_synchronously
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:robosoc/utilities/project_provider.dart';
import 'package:robosoc/models/project_model.dart';

class NewProjectScreen extends StatefulWidget {
  @override
  _NewProjectScreenState createState() => _NewProjectScreenState();
}

class _NewProjectScreenState extends State<NewProjectScreen> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _description = '';
  String _link = '';
  dynamic _imageFile; // Changed to dynamic to handle both File and XFile
  final ImagePicker _picker = ImagePicker();
  bool _isUploading = false;

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        setState(() {
          _imageFile = kIsWeb ? pickedFile : File(pickedFile.path);
        });
      }
    } catch (e) {
      print('Error picking image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to pick image: $e')),
      );
    }
  }

  Future<void> _showImageSourceDialog() async {
    // Only show camera option if not on web
    List<Widget> options = [
      ListTile(
        leading: Icon(Icons.photo_library),
        title: Text('Gallery'),
        onTap: () {
          Navigator.pop(context);
          _pickImage(ImageSource.gallery);
        },
      ),
    ];

    if (!kIsWeb) {
      options.insert(0, ListTile(
        leading: Icon(Icons.camera_alt),
        title: Text('Camera'),
        onTap: () {
          Navigator.pop(context);
          _pickImage(ImageSource.camera);
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

  Future<String?> _uploadImage() async {
    if (_imageFile == null) return null;

    try {
      final storageRef = FirebaseStorage.instance.ref();
      final imageRef = storageRef.child('project_images/${DateTime.now().millisecondsSinceEpoch}.jpg');
      
      UploadTask uploadTask;
      if (kIsWeb) {
        // Handle web upload
        final bytes = await (_imageFile as XFile).readAsBytes();
        uploadTask = imageRef.putData(bytes);
      } else {
        // Handle mobile upload
        uploadTask = imageRef.putFile(_imageFile as File);
      }

      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Error uploading image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to upload image: $e')),
      );
      return null;
    }
  }

  Widget _buildImagePreview() {
    return Stack(
      alignment: Alignment.center,
      children: [
        CircleAvatar(
          radius: 60,
          backgroundColor: Colors.grey[300],
          child: _imageFile == null
              ? Icon(Icons.add_photo_alternate, size: 40)
              : null,
          backgroundImage: _imageFile != null
              ? (kIsWeb
                  ? NetworkImage(_imageFile.path)
                  : FileImage(_imageFile) as ImageProvider)
              : null,
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: CircleAvatar(
            backgroundColor: Theme.of(context).primaryColor,
            radius: 20,
            child: IconButton(
              icon: Icon(Icons.camera_alt, color: Colors.white),
              onPressed: _showImageSourceDialog,
            ),
          ),
        ),
      ],
    );
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isUploading = true;
      });

      try {
        _formKey.currentState!.save();
        String? imageUrl;
        
        if (_imageFile != null) {
          imageUrl = await _uploadImage();
        }

        final newProject = Project(
          id: '',
          title: _title,
          description: _description,
          link: _link,
          imageUrl: imageUrl ?? '',
        );

        await Provider.of<ProjectProvider>(context, listen: false).addProject(newProject);
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add project: $e')),
        );
      } finally {
        setState(() {
          _isUploading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Project'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _buildImagePreview(),
                SizedBox(height: 20),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Title'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                  onSaved: (value) => _title = value!,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Description'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                  onSaved: (value) => _description = value!,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Google Drive Link'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a link';
                    }
                    return null;
                  },
                  onSaved: (value) => _link = value!,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _isUploading ? null : _submitForm,
                  child: _isUploading 
                    ? CircularProgressIndicator()
                    : Text('Add Project'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}