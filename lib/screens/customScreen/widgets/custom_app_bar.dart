import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:restrant_app/generated/l10n.dart';
import 'package:restrant_app/utils/colors_utility.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Align(
        alignment: isArabic() ? Alignment.centerRight : Alignment.centerLeft,
        child: Text(
          S.of(context).splashTitle,
          style: TextStyle(color: ColorsUtility.takeAwayColor),
        ),
      ),
      actions: [
        Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu,
                size: 30, color: ColorsUtility.takeAwayColor),
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
