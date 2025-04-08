// widgets/custom_app_bar.dart
import 'package:flutter/material.dart';
import 'package:restrant_app/utils/colors_utility.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: const Align(
        alignment: Alignment.centerLeft,
        child: Text(
          'PARAGON',
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
