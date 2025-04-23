import 'package:flutter/material.dart';
import 'package:restrant_app/utils/colors_utility.dart';

class AppElevatedBtn extends StatelessWidget {
  const AppElevatedBtn({
    super.key,
    required this.onPressed,
    required this.text,
    this.child,
    this.isLoading = false,
  });

  final void Function()? onPressed;
  final String text;
  final Widget? child;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ElevatedButton(
      style: theme.elevatedButtonTheme.style,
      onPressed: onPressed,
      child: Text(
        text,
        style: const TextStyle(color: ColorsUtility.onboardingColor),
      ),
    );
  }
}
