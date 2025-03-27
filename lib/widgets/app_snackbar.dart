import 'package:flutter/material.dart';

void appSnackbar(
    BuildContext context, {
    required String text,
    required Color backgroundColor,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: backgroundColor,
        content: Text(text),
      ),
    );
  }
