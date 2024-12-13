// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:robosoc/models/project_model.dart';
import 'package:robosoc/utilities/project_provider.dart';

class AddUpdateScreen extends StatefulWidget {
  final Project project;

  const AddUpdateScreen({
    Key? key,
    required this.project,
  }) : super(key: key);

  @override
  _AddUpdateScreenState createState() => _AddUpdateScreenState();
}

class _AddUpdateScreenState extends State<AddUpdateScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _commentController = TextEditingController();
  final List<String> _comments = [];
  DateTime? _startDate;
  DateTime? _endDate;

  Future<void> _selectDate(bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  void _addComment() {
    if (_commentController.text.isNotEmpty) {
      setState(() {
        _comments.add(_commentController.text);
        _commentController.clear();
      });
    }
  }

  void _saveUpdate() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Create a new ProjectUpdate
        final newUpdate = ProjectUpdate(
          title: _titleController.text,
          description: _descriptionController.text,
          date: DateTime.now(),
          addedBy: 'Current User', // Replace with actual user
          comments: _comments,
        );

        // Add the update to Firestore
        await FirebaseFirestore.instance
            .collection('projects')
            .doc(widget.project.id)
            .update({
          'updates': FieldValue.arrayUnion([newUpdate.toMap()])
        });

        // Refresh the project data
        Provider.of<ProjectProvider>(context, listen: false).fetchProjects();

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Update added successfully')),
        );

        // Navigate back
        Navigator.pop(context);
      } catch (e) {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add update: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Update'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                    hintText: ' Title',
                    border: OutlineInputBorder(),
                    fillColor: Color.fromARGB(120, 188, 188, 188),
                    filled: true),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Please enter a title' : null,
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () => _selectDate(true),
                      child: InputDecorator(
                        decoration: const InputDecoration(
                            hintText: 'Start Date',
                            border: OutlineInputBorder(),
                            fillColor: Color.fromARGB(120, 188, 188, 188),
                            filled: true),
                        child: Text(
                          _startDate != null
                              ? "${_startDate!.day}/${_startDate!.month}/${_startDate!.year}"
                              : 'Select Start Date',
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: InkWell(
                      onTap: () => _selectDate(false),
                      child: InputDecorator(
                        decoration: const InputDecoration(
                            hintText: 'End Date',
                            border: OutlineInputBorder(),
                            fillColor: Color.fromARGB(120, 188, 188, 188),
                            filled: true),
                        child: Text(
                          _endDate != null
                              ? "${_endDate!.day}/${_endDate!.month}/${_endDate!.year}"
                              : 'Select End Date',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                    hintText: 'Description',
                    border: OutlineInputBorder(),
                    fillColor: Color.fromARGB(120, 188, 188, 188),
                    filled: true),
                maxLines: 5,
                validator: (value) => value?.isEmpty ?? true
                    ? 'Please enter a description'
                    : null,
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _commentController,
                      decoration: const InputDecoration(
                          hintText: 'Add Comment',
                          border: OutlineInputBorder(),
                          fillColor: Color.fromARGB(120, 188, 188, 188),
                          filled: true),
                    ),
                  ),
                  const SizedBox(width: 10),
                  IconButton(
                    icon: const Icon(Icons.add_circle),
                    color: Colors.amber,
                    onPressed: _addComment,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _comments.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: const Icon(Icons.comment),
                    title: Text(_comments[index]),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        setState(() {
                          _comments.removeAt(index);
                        });
                      },
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveUpdate,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: const Text(
                  'Save',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
