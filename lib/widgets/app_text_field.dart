import 'package:flutter/material.dart';

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
    final theme = Theme.of(context);
    final inputTheme = theme.inputDecorationTheme;

    final borderRadius = BorderRadius.circular(30);
    final borderStyle = BorderSide.none;

    final outlineBorder = OutlineInputBorder(
      borderRadius: borderRadius,
      borderSide: borderStyle,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        validator: validator,
        cursorColor: inputTheme.labelStyle?.color ?? theme.primaryColor,
        style: theme.textTheme.bodyMedium?.copyWith(fontSize: 14),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: inputTheme.labelStyle?.copyWith(fontSize: 14),
          floatingLabelBehavior: FloatingLabelBehavior.never,
          suffixIcon: suffixIcon,
          filled: inputTheme.filled,
          fillColor: inputTheme.fillColor ?? theme.cardColor,
          contentPadding: const EdgeInsets.all(20),
          border: outlineBorder,
          enabledBorder: outlineBorder,
          focusedBorder: outlineBorder,
          disabledBorder: outlineBorder,
          errorBorder: outlineBorder,
          focusedErrorBorder: outlineBorder,
        ),
      ),
    );
  }
}
