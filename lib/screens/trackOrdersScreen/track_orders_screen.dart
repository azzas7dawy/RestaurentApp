import 'package:flutter/material.dart';
import 'package:restrant_app/utils/colors_utility.dart';

class TrackOrdersScreen extends StatelessWidget {
  const TrackOrdersScreen({super.key});
  static const String id = 'TrackOrdersScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Track Orders',
          style: TextStyle(
            fontSize: 20,
            color: ColorsUtility.takeAwayColor,
          ),
        ),
        iconTheme: const IconThemeData(
          color: ColorsUtility.takeAwayColor,
        ),
      ),
    );
  }
}
