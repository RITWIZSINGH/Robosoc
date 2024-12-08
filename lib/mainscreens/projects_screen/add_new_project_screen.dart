import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:robosoc/models/project_model.dart';
import 'package:robosoc/utilities/project_provider.dart';
import 'package:robosoc/utilities/image_picker.dart';

class AddProjectScreen extends StatefulWidget {
  const AddProjectScreen({Key? key}) : super(key: key);

  @override
  _AddProjectScreenState createState() => _AddProjectScreenState();
}

class _AddProjectScreenState extends State<AddProjectScreen> {
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
          child: _imageFile == null
              ? const Icon(Icons.add_photo_alternate, size: 40)
              : null,
          backgroundImage: _imageFile != null ? FileImage(_imageFile) : null,
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: CircleAvatar(
            backgroundColor: Theme.of(context).primaryColor,
            radius: 20,
            child: IconButton(
              icon: const Icon(Icons.camera_alt, color: Colors.white),
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

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isUploading = true);

      try {
        _formKey.currentState!.save();
        final imageUrl = await ImagePickerUtils.uploadImage(
          _imageFile,
          'project_images',
        );

        final newProject = Project(
          status: '',
          teamLeader: '',
          id: '',
          title: _title,
          description: _description,
          link: _link,
          imageUrl: imageUrl ?? '',
        );

        await Provider.of<ProjectProvider>(context, listen: false)
            .addProject(newProject);
        Navigator.pop(context);
      } catch (e) {
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
        title: const Text(
          'Add New Project',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
        ),
      ),
      body: Container(
        height: double.infinity,
        color: Colors.white,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _buildImagePreview(),
                const SizedBox(height: 40),
                TextFormField(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey.shade200,
                    labelText: 'Title',
                    labelStyle: const TextStyle(fontFamily: "NexaBold"),
                    border: const OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Please enter a title' : null,
                  onSaved: (value) => _title = value!,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey.shade200,
                    labelText: 'Google Drive Link',
                    labelStyle: const TextStyle(fontFamily: "NexaBold"),
                    border: const OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Please enter a link' : null,
                  onSaved: (value) => _link = value!,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey.shade200,
                    labelText: 'Description',
                    labelStyle: const TextStyle(fontFamily: "NexaBold"),
                    border: const OutlineInputBorder(),
                  ),
                  maxLines: 5,
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Please enter a description' : null,
                  onSaved: (value) => _description = value!,
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: _isUploading ? null : _submitForm,
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.black,
                      backgroundColor: Colors.yellow,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    child: _isUploading
                        ? const CircularProgressIndicator()
                        : Text(
                            'ADD PROJECT',
                            style: const TextStyle(fontFamily: "NexaBold"),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}