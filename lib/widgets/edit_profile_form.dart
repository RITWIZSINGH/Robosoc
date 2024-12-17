// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';

class EditProfileForm extends StatelessWidget {
  final TextEditingController nameController;
  final String selectedRole;
  final List<String> roles;
  final Function(String) onRoleSelected;

  const EditProfileForm({
    Key? key,
    required this.nameController,
    required this.selectedRole,
    required this.roles,
    required this.onRoleSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Edit Profile',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'NexaBold',
            ),
          ),
          SizedBox(height: 20),
          TextFormField(
            controller: nameController,
            decoration: InputDecoration(
              labelText: 'Name',
              prefixIcon: Icon(Icons.person_outline),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.yellow.shade700, width: 2),
              ),
              filled: true,
              fillColor: Colors.grey.shade50,
            ),
          ),
          SizedBox(height: 24),
          Text(
            'Select Role',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily: 'NexaBold',
            ),
          ),
          SizedBox(height: 12),
          Container(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Wrap(
              spacing: 12,
              runSpacing: 12,
              children: roles.map((role) {
                return ChoiceChip(
                  label: Text(role),
                  selected: selectedRole == role,
                  onSelected: (selected) => onRoleSelected(selected ? role : ''),
                  selectedColor: Colors.yellow[700],
                  backgroundColor: Colors.grey[100],
                  labelStyle: TextStyle(
                    color: selectedRole == role ? Colors.white : Colors.black87,
                    fontWeight: selectedRole == role ? FontWeight.bold : FontWeight.normal,
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                    side: BorderSide(
                      color: selectedRole == role 
                          ? Colors.yellow.shade700 
                          : Colors.grey.shade300,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}