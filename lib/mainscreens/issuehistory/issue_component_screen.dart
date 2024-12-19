import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utilities/notification_provider.dart';
import '/../utilities/component_provider.dart';
import '/../utilities/image_picker.dart';

class IssueComponentScreen extends StatefulWidget {
  const IssueComponentScreen({Key? key}) : super(key: key);

  @override
  State<IssueComponentScreen> createState() => _IssueComponentScreenState();
}

class _IssueComponentScreenState extends State<IssueComponentScreen> {
  final _formKey = GlobalKey<FormState>();
  String _selectedComponentId = '';
  String _componentName = '';
  int _quantity = 0;
  String _purpose = '';
  dynamic _imageFile;
  bool _isSubmitting = false;

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
          right: 100,
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

  Widget _buildComponentDropdown() {
    final components = Provider.of<ComponentProvider>(context).components;
    
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey.shade200,
        labelText: 'Select Component',
        border: const OutlineInputBorder(),
      ),
      value: _selectedComponentId.isEmpty ? null : _selectedComponentId,
      items: components.map((component) {
        return DropdownMenuItem(
          value: component.id,
          child: Text(component.name),
        );
      }).toList(),
      onChanged: (value) {
        if (value != null) {
          setState(() {
            _selectedComponentId = value;
            _componentName = components
                .firstWhere((component) => component.id == value)
                .name;
          });
        }
      },
      validator: (value) => value == null ? 'Please select a component' : null,
    );
  }

  Future<void> _submitRequest() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() => _isSubmitting = true);

    try {
      final imageUrl = await ImagePickerUtils.uploadImage(
        _imageFile,
        'issue_requests',
      );

      await Provider.of<NotificationProvider>(context, listen: false)
          .sendComponentRequest(
        componentId: _selectedComponentId,
        componentName: _componentName,
        quantity: _quantity,
        type: 'issue_request',
        purpose: _purpose,
        imageUrl: imageUrl ?? '',
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Request sent successfully')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to send request: $e')),
        );
      }
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Issue Component Request'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildImagePreview(),
              const SizedBox(height: 24),
              _buildComponentDropdown(),
              const SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey.shade200,
                  labelText: 'Quantity',
                  border: const OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) => _quantity = int.tryParse(value) ?? 0,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter quantity';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey.shade200,
                  labelText: 'Purpose',
                  border: const OutlineInputBorder(),
                ),
                maxLines: 3,
                onChanged: (value) => _purpose = value,
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Please enter purpose' : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isSubmitting ? null : _submitRequest,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.yellow,
                  foregroundColor: Colors.black,
                ),
                child: _isSubmitting
                    ? const CircularProgressIndicator()
                    : const Text(
                        'SUBMIT REQUEST',
                        style: TextStyle(fontFamily: "NexaBold"),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}