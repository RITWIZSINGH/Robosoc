import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:robosoc/mainscreens/momscreen/mom_details_screen.dart';
import 'package:robosoc/models/mom.dart';

class MomForm extends StatefulWidget {
  final Mom? mom;

  const MomForm({Key? key, this.mom}) : super(key: key);

  @override
  _MomFormState createState() => _MomFormState();
}

class _MomFormState extends State<MomForm> {
  final _formKey = GlobalKey<FormState>();

  // Form field controllers
  final _dateController = TextEditingController();
  final _startTimeController = TextEditingController();
  final _endTimeController = TextEditingController();
  final _presentController = TextEditingController();
  final _totalController = TextEditingController();
  final _createdByController = TextEditingController();
  final _contentController = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    // Populate controllers with existing data if editing
    if (widget.mom != null) {
      _dateController.text =
          DateFormat('yyyy-MM-dd').format(widget.mom!.dateTime);
      _startTimeController.text =
          DateFormat('HH:mm').format(widget.mom!.startTime);
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
      appBar: AppBar(
        title: Text(
          widget.mom == null ? 'Create MOM' : 'Edit MOM',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 175, 89, 241),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          surfaceTintColor: Colors.black,
          elevation: 8.0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    buildFormField(
                      controller: _dateController,
                      labelText: 'Date',
                      readOnly: true,
                      onTap: () => _selectDate(context),
                      validatorText: 'Please select a date',
                    ),
                    SizedBox(height: 10),
                    buildFormField(
                      controller: _startTimeController,
                      labelText: 'Start Time',
                      readOnly: true,
                      onTap: () => _selectTime(context, _startTimeController),
                      validatorText: 'Please select start time',
                    ),
                    SizedBox(height: 10),
                    buildFormField(
                      controller: _endTimeController,
                      labelText: 'End Time',
                      readOnly: true,
                      onTap: () => _selectTime(context, _endTimeController),
                      validatorText: 'Please select end time',
                    ),
                    SizedBox(height: 10),
                    buildFormField(
                      controller: _presentController,
                      labelText: 'Present Attendees',
                      keyboardType: TextInputType.number,
                      validatorText: 'Please enter present attendees',
                    ),
                    SizedBox(height: 10),
                    buildFormField(
                      controller: _totalController,
                      labelText: 'Total Attendees',
                      keyboardType: TextInputType.number,
                      validatorText: 'Please enter total attendees',
                    ),
                    SizedBox(height: 10),
                    buildFormField(
                      controller: _createdByController,
                      labelText: 'Created By',
                      validatorText: 'Please enter creator name',
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: _contentController,
                      decoration: InputDecoration(
                        labelText: 'Content',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 5,
                      validator: (value) => value!.isEmpty
                          ? 'Please enter meeting content'
                          : null,
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _submitForm,
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.orange, // Background color
                      ),
                      child: Text(
                        widget.mom == null ? 'Save MOM' : 'Update MOM',
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildFormField({
    required TextEditingController controller,
    required String labelText,
    String? validatorText,
    TextInputType? keyboardType,
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      ),
      keyboardType: keyboardType,
      readOnly: readOnly,
      onTap: onTap,
      validator: (value) => value!.isEmpty ? validatorText : null,
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
