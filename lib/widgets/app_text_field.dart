import 'package:flutter/material.dart';

import '../utils/colors_utility.dart';


class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.label,
    required this.controller,
    this.obscureText = false,
    required this.keyboardType,
    required this.validator,
    this.suffixIcon,
  });

  final String label;
  final TextEditingController controller;
  final bool obscureText;
  final TextInputType? keyboardType;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: TextFormField(
        validator: validator,
        keyboardType: keyboardType,
        obscureText: obscureText,
        controller: controller,
        cursorColor: ColorsUtility.textFieldLabelColor,
        style: const TextStyle(
          color: ColorsUtility.textFieldLabelColor,
          fontSize: 14,
        ),
        decoration: InputDecoration(
          suffixIcon: suffixIcon,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
          fillColor: ColorsUtility.textFieldFillColor,
          filled: true,
          labelText: label,
          labelStyle: const TextStyle(
            color: ColorsUtility.textFieldLabelColor,
            fontSize: 14,
          ),
          floatingLabelBehavior: FloatingLabelBehavior.never,
          contentPadding: const EdgeInsets.all(20),
        ),
      ),
    );
  }
}
