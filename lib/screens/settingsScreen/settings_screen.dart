import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restrant_app/cubit/AuthLogic/cubit/auth_cubit.dart';
import 'package:restrant_app/cubit/ThemeLogic/cubit/theme_cubit.dart';
import 'package:restrant_app/cubit/ThemeLogic/cubit/theme_state.dart';
import 'package:restrant_app/generated/l10n.dart';
import 'package:restrant_app/screens/customScreen/custom_screen.dart';
import 'package:restrant_app/utils/colors_utility.dart';

class SettignsScreen extends StatelessWidget {
  const SettignsScreen({super.key});
  static const String id = 'SettingsScreen';

  @override
  Widget build(BuildContext context) {
    final currentLocale = Localizations.localeOf(context);
    final isArabic = currentLocale.languageCode == 'ar';
    final theme = Theme.of(context);
    // final isDarkTheme = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          S.of(context).settings,
          style: TextStyle(
            color: theme.colorScheme.primary,
          ),
        ),
        iconTheme: IconThemeData(
          color: theme.colorScheme.primary,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacementNamed(context, CustomScreen.id);
          },
        ),
        backgroundColor: theme.scaffoldBackgroundColor,
      ),
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Language Settings
            ListTile(
              title: Text(
                S.of(context).language,
                style: TextStyle(
                  fontSize: 18,
                  color: theme.colorScheme.primary,
                ),
              ),
              trailing: Switch(
                value: isArabic,
                activeColor: ColorsUtility.lightOnboardingDescriptionColor,
                onChanged: (value) {
                  final newLocale =
                      value ? const Locale('ar') : const Locale('en');
                  context.read<AuthCubit>().changeLanguage(newLocale, context);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    isArabic ? 'العربية' : 'English',
                    style: TextStyle(
                      fontSize: 16,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  Text(
                    isArabic ? 'English' : 'العربية',
                    style: TextStyle(
                      fontSize: 16,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),

            const Divider(height: 32),

            // Theme Settings
            BlocBuilder<ThemeCubit, ThemeState>(
              builder: (context, themeState) {
                final isDarkMode = themeState.themeMode == ThemeMode.dark;
                return Column(
                  children: [
                    ListTile(
                      title: Text(
                        S.of(context).theme,
                        style: TextStyle(
                          fontSize: 18,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      trailing: Switch(
                        value: isDarkMode,
                        activeColor:
                            ColorsUtility.lightOnboardingDescriptionColor,
                        onChanged: (value) {
                          context.read<ThemeCubit>().toggleTheme(value);
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Light',
                            style: TextStyle(
                              fontSize: 16,
                              color: !isDarkMode
                                  ? ColorsUtility.textFieldLabelColor
                                  : Colors.grey,
                            ),
                          ),
                          Text(
                            'Dark',
                            style: TextStyle(
                              fontSize: 16,
                              color: isDarkMode
                                  ? ColorsUtility.textFieldLabelColor
                                  : Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
