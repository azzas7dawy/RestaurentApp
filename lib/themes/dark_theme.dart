import 'package:flutter/material.dart';
import '../utils/colors_utility.dart';

final ThemeData darkTheme = ThemeData(
  fontFamily: 'Raleway',
  brightness: Brightness.dark,
  scaffoldBackgroundColor: ColorsUtility.mainBackgroundColor,
  primaryColor: ColorsUtility.progressIndictorColor,
  colorScheme: ColorScheme.dark(
    primary: ColorsUtility.progressIndictorColor,
    secondary: ColorsUtility.takeAwayColor,
    error: ColorsUtility.errorSnackbarColor,
  ),
  textTheme: const TextTheme(
    displayLarge: TextStyle(color: ColorsUtility.onboardingColor),
    displayMedium: TextStyle(color: ColorsUtility.onboardingColor),
    displaySmall: TextStyle(color: ColorsUtility.onboardingColor),
    headlineLarge: TextStyle(color: ColorsUtility.onboardingColor),
    headlineMedium: TextStyle(color: ColorsUtility.onboardingColor),
    headlineSmall: TextStyle(color: ColorsUtility.onboardingColor),
    titleLarge: TextStyle(color: ColorsUtility.onboardingColor),
    titleMedium: TextStyle(color: ColorsUtility.onboardingColor),
    titleSmall: TextStyle(color: ColorsUtility.onboardingColor),
    bodyLarge: TextStyle(color: ColorsUtility.onboardingColor),
    bodyMedium: TextStyle(color: ColorsUtility.onboardingColor),
    bodySmall: TextStyle(color: ColorsUtility.onboardingColor),
    labelLarge: TextStyle(color: ColorsUtility.onboardingColor),
    labelMedium: TextStyle(color: ColorsUtility.onboardingColor),
    labelSmall: TextStyle(color: ColorsUtility.onboardingColor),
  ),
  primaryTextTheme: const TextTheme(
    displayLarge: TextStyle(color: ColorsUtility.onboardingColor),
    displayMedium: TextStyle(color: ColorsUtility.onboardingColor),
    displaySmall: TextStyle(color: ColorsUtility.onboardingColor),
    headlineLarge: TextStyle(color: ColorsUtility.onboardingColor),
    headlineMedium: TextStyle(color: ColorsUtility.onboardingColor),
    headlineSmall: TextStyle(color: ColorsUtility.onboardingColor),
    titleLarge: TextStyle(color: ColorsUtility.onboardingColor),
    titleMedium: TextStyle(color: ColorsUtility.onboardingColor),
    titleSmall: TextStyle(color: ColorsUtility.onboardingColor),
    bodyLarge: TextStyle(color: ColorsUtility.onboardingColor),
    bodyMedium: TextStyle(color: ColorsUtility.onboardingColor),
    bodySmall: TextStyle(color: ColorsUtility.onboardingColor),
    labelLarge: TextStyle(color: ColorsUtility.onboardingColor),
    labelMedium: TextStyle(color: ColorsUtility.onboardingColor),
    labelSmall: TextStyle(color: ColorsUtility.onboardingColor),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: ColorsUtility.elevatedBtnColor,
      foregroundColor: ColorsUtility.onboardingColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      side: BorderSide.none,
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 40.0),
      minimumSize: const Size(300, 60),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    fillColor: ColorsUtility.textFieldFillColor,
    filled: true,
    labelStyle: const TextStyle(color: ColorsUtility.textFieldLabelColor),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide.none,
    ),
  ),
  // snackBarTheme: const SnackBarThemeData(
  //   backgroundColor: ColorsUtility.successSnackbarColor,
  //   contentTextStyle: TextStyle(color: ColorsUtility.textFieldLabelColor),
  // ),
  cardColor: ColorsUtility.elevatedBtnColor,
);
