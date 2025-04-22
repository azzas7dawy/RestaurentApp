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
    return SalomonBottomBar(
      currentIndex: currentIndex,
      onTap: onTap,
      items: [
        SalomonBottomBarItem(
          icon: SvgPicture.asset(
            IconsUtility.homeIcon,
            width: 20,
            height: 20,
          ),
          title: Text(S.of(context).home),
          selectedColor: ColorsUtility.takeAwayColor,
        ),
        SalomonBottomBarItem(
          icon: SvgPicture.asset(
            IconsUtility.orderFoodIcon,
            width: 20,
            height: 20,
          ),
          title: Text(S.of(context).menu),
          selectedColor: ColorsUtility.takeAwayColor,
        ),
        SalomonBottomBarItem(
          icon: SvgPicture.asset(
            IconsUtility.searchIcon,
            width: 20,
            height: 20,
          ),
          title: Text(S.of(context).search),
          selectedColor: ColorsUtility.takeAwayColor,
        ),
        SalomonBottomBarItem(
          icon: SvgPicture.asset(
            IconsUtility.reserveTableIcon,
            width: 20,
            height: 20,
          ),
          title: Text(S.of(context).reserveTable),
          selectedColor: ColorsUtility.takeAwayColor,
        ),
        SalomonBottomBarItem(
          icon:
              SvgPicture.asset(IconsUtility.profileIcon, width: 20, height: 20),
          title: Text(S.of(context).profile),
          selectedColor: ColorsUtility.takeAwayColor,
        ),
      ],
    );
  }
}
