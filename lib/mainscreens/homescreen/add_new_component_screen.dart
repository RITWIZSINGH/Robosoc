// lib/screens/add_new_component_screen.dart
// ignore_for_file: sort_child_properties_last, use_build_context_synchronously

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:robosoc/utilities/image_picker.dart';
import 'package:robosoc/utilities/component_provider.dart';
import 'package:robosoc/models/component_model.dart';

class AddNewComponentScreen extends StatefulWidget {
  const AddNewComponentScreen({super.key});

  @override
  State<AddNewComponentScreen> createState() => _AddNewComponentScreenState();
}

class _AddNewComponentScreenState extends State<AddNewComponentScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _componentName = '';
  late String _quantity = '';
  late String _description = '';
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
          right: 100,
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
            await ImagePickerUtils.uploadImage(_imageFile, 'component_images');

        final component = Component(
          id: '',
          name: _componentName,
          quantity: int.parse(_quantity),
          description: _description,
          imageUrl: imageUrl ?? '',
        );

        await Provider.of<ComponentProvider>(context, listen: false)
            .addComponent(component);
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add component: $e')),
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
          "",
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
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildImagePreview(),
                SizedBox(height: 24),
                TextFormField(
                  onChanged: (value) => _componentName = value,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey.shade200,
                    labelStyle: TextStyle(fontFamily: "NexaBold"),
                    labelText: 'Enter Component Name',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                  validator: (value) => value?.isEmpty ?? true
                      ? 'Please enter a component name'
                      : null,
                ),
                SizedBox(height: 16),
                TextFormField(
                  onChanged: (value) => _quantity = value,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey.shade200,
                    labelStyle: TextStyle(fontFamily: "NexaBold"),
                    labelText: 'Quantity',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Please enter quantity' : null,
                ),
                SizedBox(height: 16),
                TextFormField(
                  onChanged: (value) => _description = value,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey.shade200,
                    labelStyle: TextStyle(fontFamily: "NexaBold"),
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 5,
                  validator: (value) => value?.isEmpty ?? true
                      ? 'Please enter description'
                      : null,
                ),
                SizedBox(height: 24),
                TextButton(
                  onPressed: _isUploading ? null : _submitForm,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: Colors.yellow,
                    padding: EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: _isUploading
                      ? CircularProgressIndicator()
                      : Text(
                          'SAVE',
                          style: TextStyle(fontFamily: "NexaBold"),
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
