// ignore_for_file: use_super_parameters, library_private_types_in_public_api, use_build_context_synchronously, avoid_print

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:robosoc/models/mom.dart';
import 'package:robosoc/mainscreens/momscreen/mom_details_screen.dart';
import 'package:robosoc/widgets/mom_form/form_field.dart';
import 'package:robosoc/utilities/user_profile_provider.dart';

class MomForm extends StatefulWidget {
  final Mom? mom;

  const MomForm({Key? key, this.mom}) : super(key: key);

  @override
  _MomFormState createState() => _MomFormState();
}

class _MomFormState extends State<MomForm> {
  final _formKey = GlobalKey<FormState>();
  final _dateController = TextEditingController();
  final _startTimeController = TextEditingController();
  final _endTimeController = TextEditingController();
  final _presentController = TextEditingController();
  final _totalController = TextEditingController();
  final _createdByController = TextEditingController();
  final _contentController = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late String _createdBy;

  @override
  void initState() {
    super.initState();
    final userProfile = Provider.of<UserProfileProvider>(context, listen: false);
    _createdBy = widget.mom?.createdBy ?? userProfile.userName;

    if (widget.mom != null) {
      _dateController.text = DateFormat('yyyy-MM-dd').format(widget.mom!.dateTime);
      _startTimeController.text = DateFormat('HH:mm').format(widget.mom!.startTime);
      _endTimeController.text = DateFormat('HH:mm').format(widget.mom!.endTime);
      _presentController.text = widget.mom!.present.toString();
      _totalController.text = widget.mom!.total.toString();
      _createdByController.text = widget.mom!.createdBy;
      _contentController.text = widget.mom!.content;
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      setState(() {
        _dateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
      });
    }
  }

  Future<void> _selectTime(
      BuildContext context, TextEditingController controller) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      final now = DateTime.now();
      final selectedDateTime = DateTime(
          now.year, now.month, now.day, pickedTime.hour, pickedTime.minute);
      setState(() {
        controller.text = DateFormat('HH:mm').format(selectedDateTime);
      });
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final momData = Mom(
        id: widget.mom?.id,
        dateTime: DateTime.parse(_dateController.text),
        startTime: DateTime.parse(
            "${_dateController.text} ${_startTimeController.text}"),
        endTime: DateTime.parse(
            "${_dateController.text} ${_endTimeController.text}"),
        present: int.parse(_presentController.text),
        total: int.parse(_totalController.text),
        createdBy: _createdByController.text,
        content: _contentController.text,
      );

      try {
        if (widget.mom == null) {
          // Adding a new document
          final docRef =
              await _firestore.collection('moms').add(momData.toMap());
          momData.id = docRef.id; // Set the Firestore-generated ID in momData
        } else {
          // Updating an existing document
          await _firestore
              .collection('moms')
              .doc(momData.id)
              .update(momData.toMap());
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('MOM saved successfully')),
        );
        if (widget.mom == null) {
          Navigator.pop(context);
        } else {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => MomDetailsScreen(
                        mom: momData,
                      )));
        }
      } catch (e) {
        print('Failed to save MOM: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text(
          widget.mom == null ? 'Create MOM' : 'Edit MOM',
          style: const TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    CustomFormField(
                      controller: _dateController,
                      labelText: 'Date',
                      readOnly: true,
                      onTap: () => _selectDate(context),
                      validatorText: 'Please select a date',
                      prefix: const Icon(Icons.calendar_today),
                    ),
                    const SizedBox(height: 16),
                    CustomFormField(
                      controller: _startTimeController,
                      labelText: 'Start Time',
                      readOnly: true,
                      onTap: () => _selectTime(context, _startTimeController),
                      validatorText: 'Please select start time',
                      prefix: const Icon(Icons.access_time),
                    ),
                    const SizedBox(height: 16),
                    CustomFormField(
                      controller: _endTimeController,
                      labelText: 'End Time',
                      readOnly: true,
                      onTap: () => _selectTime(context, _endTimeController),
                      validatorText: 'Please select end time',
                      prefix: const Icon(Icons.access_time_filled),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: CustomFormField(
                            controller: _presentController,
                            labelText: 'Present',
                            keyboardType: TextInputType.number,
                            validatorText: 'Required',
                            prefix: const Icon(Icons.people),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: CustomFormField(
                            controller: _totalController,
                            labelText: 'Total',
                            keyboardType: TextInputType.number,
                            validatorText: 'Required',
                            prefix: const Icon(Icons.groups),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    CustomFormField(
                      controller: _createdByController,
                      labelText: 'Created By',
                      validatorText: 'Please enter creator name',
                      prefix: const Icon(Icons.person),
                    ),
                    const SizedBox(height: 16),
                    CustomFormField(
                      controller: _contentController,
                      labelText: 'Content',
                      maxLines: 5,
                      validatorText: 'Please enter meeting content',
                      prefix: const Icon(Icons.note),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _submitForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.secondary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        widget.mom == null ? 'Create MOM' : 'Update MOM',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _dateController.dispose();
    _startTimeController.dispose();
    _endTimeController.dispose();
    _presentController.dispose();
    _totalController.dispose();
    _createdByController.dispose();
    _contentController.dispose();
    super.dispose();
  }
}