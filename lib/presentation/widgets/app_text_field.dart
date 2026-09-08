import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({super.key, required this.controller, required this.label, this.obscureText = false, this.keyboardType});

  final TextEditingController controller;
  final String label;
  final bool obscureText;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(labelText: label, prefixIcon: Icon(obscureText ? Icons.lock_outline : Icons.person_outline)),
      validator: (value) => value == null || value.trim().isEmpty ? 'Ce champ est obligatoire' : null,
    );
  }
}
