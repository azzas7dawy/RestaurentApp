import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:restrant_app/generated/l10n.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final isDark = theme.brightness == Brightness.dark;

    final String logoAsset = isDark
        ? 'assets/images/logo dark-mood.svg'
        : 'assets/images/logo light-mood.svg';

    final Color titleColor = theme.colorScheme.primary;

    final Color iconColor = theme.colorScheme.primary;

    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: theme.scaffoldBackgroundColor,
      elevation: 0,
      title: Align(
        alignment: isArabic() ? Alignment.centerRight : Alignment.centerLeft,
        
        child: Row(
          children: [
            Text(
              S.of(context).splashTitle,
              style: theme.textTheme.titleLarge?.copyWith(
                color: titleColor,
                fontWeight: FontWeight.bold,
              ),
              
            ),
              SvgPicture.asset(
                        logoAsset,
                             width: 50,
                             height: 50,
              ),
          ],
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
