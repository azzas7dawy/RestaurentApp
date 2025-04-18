// widgets/custom_bottom_navbar.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

import '../../../utils/colors_utility.dart';
import '../../../utils/icons_utility.dart';

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
            width: 24,
            height: 24,
          ),
          title: const Text("Home"),
          selectedColor: ColorsUtility.takeAwayColor,
        ),
        SalomonBottomBarItem(
          icon: SvgPicture.asset(
            IconsUtility.orderFoodIcon,
            width: 24,
            height: 24,
          ),
          title: const Text("Order Food"),
          selectedColor: ColorsUtility.takeAwayColor,
        ),
        SalomonBottomBarItem(
          icon: SvgPicture.asset(
            IconsUtility.reserveTableIcon,
            width: 24,
            height: 24,
          ),
          title: const Text("Reserve Table"),
          selectedColor: ColorsUtility.takeAwayColor,
        ),
        SalomonBottomBarItem(
          icon:
              SvgPicture.asset(IconsUtility.profileIcon, width: 24, height: 24),
          title: const Text("Profile"),
          selectedColor: ColorsUtility.takeAwayColor,
        ),
      ],
    );
  }
}
