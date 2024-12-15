// ignore_for_file: library_private_types_in_public_api, use_super_parameters, use_build_context_synchronously

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
  String _teamLeader = '';
  dynamic _imageFile;
  bool _isUploading = false;

  // New variable for project status
  String _projectStatus = 'ongoing'; // Default value
  final List<String> _statusOptions = ['ongoing', 'completed'];

  Widget _buildImagePreview() {
    return Stack(
      alignment: Alignment.center,
      children: [
        CircleAvatar(
          radius: 60,
          backgroundColor: Colors.grey[300],
          backgroundImage: _imageFile != null ? FileImage(_imageFile) : null,
          child: _imageFile == null
              ? const Icon(Icons.add_photo_alternate, size: 40)
              : null,
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

  void _showValidationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Incomplete Form', style: TextStyle(fontFamily: "NexaBold")),
        content: const Text(
          'Please fill in all fields:\n'
          '- Project Title\n'
          '- Google Drive Link\n'
          '- Description\n'
          '- Team Leader Name\n'
          '- Project Image\n'
          '- Project Status',
          style: TextStyle(fontFamily: "NexaRegular"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK', style: TextStyle(fontFamily: "NexaBold")),
          ),
        ],
      ),
    );
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      // Additional check for image and other fields
      if (_imageFile == null) {
        _showValidationDialog();
        return;
      }

      setState(() => _isUploading = true);

      try {
        _formKey.currentState!.save();
        final imageUrl = await ImagePickerUtils.uploadImage(
          _imageFile,
          'project_images',
        );

        final newProject = Project(
          // Use the selected status
          status: _projectStatus,
          teamLeader: _teamLeader,
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
    } else {
      _showValidationDialog();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add New Project',
          style: TextStyle(
              color: Colors.amber,
              fontFamily: "NexaBold",
              fontWeight: FontWeight.w900),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
        ),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
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
                    labelText: 'Team Leader Name',
                    labelStyle: const TextStyle(fontFamily: "NexaBold"),
                    border: const OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Please enter team leader name' : null,
                  onSaved: (value) => _teamLeader = value!,
                ),
                const SizedBox(height: 20),
                // New Dropdown for Project Status
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey.shade200,
                    labelText: 'Project Status',
                    labelStyle: const TextStyle(fontFamily: "NexaBold"),
                    border: const OutlineInputBorder(),
                  ),
                  value: _projectStatus,
                  items: _statusOptions.map((status) {
                    return DropdownMenuItem(
                      value: status,
                      child: Text(
                        status.capitalize(),
                        style: const TextStyle(fontFamily: "NexaRegular"),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _projectStatus = value!;
                    });
                  },
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
                  validator: (value) => value?.isEmpty ?? true
                      ? 'Please enter a description'
                      : null,
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

// Extension to capitalize first letter of a string
extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}