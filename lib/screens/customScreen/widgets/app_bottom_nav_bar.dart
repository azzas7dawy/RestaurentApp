import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:restrant_app/generated/l10n.dart';
import 'package:restrant_app/utils/colors_utility.dart';
import 'package:restrant_app/utils/icons_utility.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class AppBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const AppBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isLightMode = theme.brightness == Brightness.light;

    final Color selectedColor = theme.colorScheme.primary;
    final Color unselectedColor = isLightMode
        ? ColorsUtility.mainBackgroundColor
        : ColorsUtility.textFieldLabelColor;

    return SalomonBottomBar(
      currentIndex: currentIndex,
      onTap: onTap,
      items: [
        SalomonBottomBarItem(
          icon: SvgPicture.asset(
            IconsUtility.homeIcon,
            width: 20,
            height: 20,
            colorFilter: ColorFilter.mode(
              currentIndex == 0 ? selectedColor : unselectedColor,
              BlendMode.srcIn,
            ),
          ),
          title: Text(
            S.of(context).home,
            style: TextStyle(
              color: currentIndex == 0 ? selectedColor : unselectedColor,
            ),
          ),
          selectedColor: selectedColor,
          unselectedColor: unselectedColor,
        ),
        SalomonBottomBarItem(
          icon: SvgPicture.asset(
            IconsUtility.orderFoodIcon,
            width: 20,
            height: 20,
            colorFilter: ColorFilter.mode(
              currentIndex == 1 ? selectedColor : unselectedColor,
              BlendMode.srcIn,
            ),
          ),
          title: Text(
            S.of(context).menu,
            style: TextStyle(
              color: currentIndex == 1 ? selectedColor : unselectedColor,
            ),
          ),
          selectedColor: selectedColor,
          unselectedColor: unselectedColor,
        ),
        SalomonBottomBarItem(
          icon: SvgPicture.asset(
            IconsUtility.searchIcon,
            width: 20,
            height: 20,
            colorFilter: ColorFilter.mode(
              currentIndex == 2 ? selectedColor : unselectedColor,
              BlendMode.srcIn,
            ),
          ),
          title: Text(
            S.of(context).search,
            style: TextStyle(
              color: currentIndex == 2 ? selectedColor : unselectedColor,
            ),
          ),
          selectedColor: selectedColor,
          unselectedColor: unselectedColor,
        ),
        SalomonBottomBarItem(
          icon: SvgPicture.asset(
            IconsUtility.reserveTableIcon,
            width: 20,
            height: 20,
            colorFilter: ColorFilter.mode(
              currentIndex == 3 ? selectedColor : unselectedColor,
              BlendMode.srcIn,
            ),
          ),
          title: Text(
            S.of(context).reserveTable,
            style: TextStyle(
              color: currentIndex == 3 ? selectedColor : unselectedColor,
            ),
          ),
          selectedColor: selectedColor,
          unselectedColor: unselectedColor,
        ),
        SalomonBottomBarItem(
          icon: SvgPicture.asset(
            IconsUtility.profileIcon,
            width: 20,
            height: 20,
            colorFilter: ColorFilter.mode(
              currentIndex == 4 ? selectedColor : unselectedColor,
              BlendMode.srcIn,
            ),
          ),
          title: Text(
            S.of(context).profile,
            style: TextStyle(
              color: currentIndex == 4 ? selectedColor : unselectedColor,
            ),
          ),
          selectedColor: selectedColor,
          unselectedColor: unselectedColor,
        ),
      ],
    );
  }
}
