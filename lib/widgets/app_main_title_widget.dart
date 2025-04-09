import 'package:flutter/material.dart';
import 'package:restrant_app/utils/colors_utility.dart';

class AppMainTitleWidget extends StatelessWidget {
  const AppMainTitleWidget({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: ColorsUtility.takeAwayColor,
      ),
    );
  }
}
