// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';

class RoleSelector extends StatelessWidget {
  final List<String> roles;
  final String selectedRole;
  final Function(String) onRoleSelected;

  const RoleSelector({
    Key? key,
    required this.roles,
    required this.selectedRole,
    required this.onRoleSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Your Role',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: 'NexaBold',
            color: Colors.grey.shade800,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Wrap(
            spacing: 12,
            runSpacing: 12,
            children: roles.map((role) {
              return ChoiceChip(
                label: Text(role),
                selected: selectedRole == role,
                onSelected: (selected) => onRoleSelected(selected ? role : ''),
                selectedColor: Colors.yellow[700],
                backgroundColor: Colors.white,
                labelStyle: TextStyle(
                  color: selectedRole == role ? Colors.white : Colors.grey.shade700,
                  fontWeight: selectedRole == role ? FontWeight.bold : FontWeight.normal,
                  fontSize: 16,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                  side: BorderSide(
                    color: selectedRole == role 
                        ? Colors.yellow.shade700 
                        : Colors.grey.shade300,
                    width: 1.5,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}