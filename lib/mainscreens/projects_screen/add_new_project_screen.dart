// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api, avoid_print, use_build_context_synchronously// lib/screens/new_project_screen.dart, sort_child_properties_last, unused_import, unused_import, use_build_context_synchronously, use_build_context_synchronously, use_build_context_synchronously, prefer_const_constructors, prefer_const_constructors, sort_child_properties_last, use_build_context_synchronously, sort_child_properties_last, use_build_context_synchronously, use_build_context_synchronously, sort_child_properties_last
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:robosoc/utilities/image_picker.dart';
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
  dynamic _imageFile;
  bool _isUploading = false;

  Widget _buildImagePreview() {
    return Stack(
      alignment: Alignment.center,
      children: [
        CircleAvatar(
          radius: 60,
          backgroundColor: Colors.grey[300],
          // ignore: sort_child_properties_last
          child: _imageFile == null
              // ignore: prefer_const_constructors
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
              onPressed: () => ImagePickerUtils.showImageSourceDialog(
                context,
                (image) => setState(() => _imageFile = image),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isUploading = true);

      try {
        _formKey.currentState!.save();
        final imageUrl =
            await ImagePickerUtils.uploadImage(_imageFile, 'project_images');

        final newProject = Project(
          id: '',
          title: _title,
          description: _description,
          link: _link,
          imageUrl: imageUrl ?? '',
        );

        // ignore: use_build_context_synchronously
        await Provider.of<ProjectProvider>(context, listen: false)
            .addProject(newProject);
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
      } catch (e) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add project: $e')),
        );
      } finally {
        setState(() => _isUploading = false);
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
                SizedBox(height: 40),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Please enter a title' : null,
                  onSaved: (value) => _title = value!,
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                  validator: (value) => value?.isEmpty ?? true
                      ? 'Please enter a description'
                      : null,
                  onSaved: (value) => _description = value!,
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Google Drive Link',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Please enter a link' : null,
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
