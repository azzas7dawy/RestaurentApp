import 'package:flutter/material.dart';

class AppMainTitleWidget extends StatelessWidget {
  const AppMainTitleWidget({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final Color titleColor = theme.colorScheme.primary;
    return Text(
      title,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: titleColor,
      ),
    );
  }
}
