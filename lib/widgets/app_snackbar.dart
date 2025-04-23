import 'package:flutter/material.dart';
import 'package:restrant_app/utils/colors_utility.dart';

void appSnackbar(
  BuildContext context, {
  required String text,
  required Color backgroundColor,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: backgroundColor,
<<<<<<< HEAD
      content: Text(text),
=======
      content: Text(text,
          style: TextStyle(color: ColorsUtility.lightMainBackgroundColor)),
>>>>>>> master
      duration: const Duration(seconds: 2),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),
  );
}
