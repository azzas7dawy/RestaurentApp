import 'package:flutter/material.dart';
import 'package:restrant_app/utils/colors_utility.dart';

class AppElevatedBtn extends StatelessWidget {
  const AppElevatedBtn({
    super.key,
    required this.onPressed,
    required this.text,
  });

  final void Function()? onPressed;
  final String text;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: ColorsUtility.elevatedBtnColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        side: BorderSide.none,
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 40.0),
        minimumSize: const Size(300, 60),
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: const TextStyle(color: ColorsUtility.onboardingColor),
      ),
    );
  }
}
