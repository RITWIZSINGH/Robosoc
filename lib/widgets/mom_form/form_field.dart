import 'package:flutter/material.dart';

class CustomFormField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String? validatorText;
  final TextInputType? keyboardType;
  final bool readOnly;
  final VoidCallback? onTap;
  final int? maxLines;
  final Widget? prefix;

  const CustomFormField({
    Key? key,
    required this.controller,
    required this.labelText,
    this.validatorText,
    this.keyboardType,
    this.readOnly = false,
    this.onTap,
    this.maxLines = 1,
    this.prefix,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(color: Colors.grey.shade700),
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
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        filled: true,
        fillColor: Colors.white,
        prefixIcon: prefix,
        contentPadding: EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: maxLines! > 1 ? 16.0 : 0,
        ),
      ),
      keyboardType: keyboardType,
      readOnly: readOnly,
      onTap: onTap,
      maxLines: maxLines,
      validator: (value) => value!.isEmpty ? validatorText : null,
      style: const TextStyle(
        fontSize: 16,
        color: Colors.black87,
      ),
    );
  }
}