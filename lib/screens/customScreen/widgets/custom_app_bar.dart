import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:restrant_app/generated/l10n.dart';
import 'package:restrant_app/utils/icons_utility.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final isDark = theme.brightness == Brightness.dark;

    final String logoAsset =
        isDark ? IconsUtility.logoDarkModeIcon : IconsUtility.logoLightModeIcon;

    final Color titleColor = theme.colorScheme.primary;

    final Color iconColor = theme.colorScheme.primary;

    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: theme.scaffoldBackgroundColor,
      elevation: 0,
      title: Align(
        alignment: isArabic() ? Alignment.centerRight : Alignment.centerLeft,
        child: Expanded(
          child: Row(
            children: [
              SvgPicture.asset(
                logoAsset,
                width: 40,
                height: 40,
                colorFilter: ColorFilter.mode(
                  titleColor,
                  BlendMode.srcIn,
                ),
              ),
              Text(
                S.of(context).splashTitle,
                style: theme.textTheme.titleLarge?.copyWith(
                  color: titleColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        Builder(
          builder: (context) => IconButton(
            icon: Icon(
              Icons.menu,
              size: 30,
              color: iconColor,
            ),
            onPressed: () {
              Scaffold.of(context).openEndDrawer();
            },
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

bool isArabic() {
  return Intl.getCurrentLocale() == 'ar';
}
