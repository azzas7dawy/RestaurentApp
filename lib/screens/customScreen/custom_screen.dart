import 'package:flutter/material.dart';
import 'package:restrant_app/screens/aiChat/chat_screen.dart' show ChatScreen;
import 'package:restrant_app/screens/customScreen/widgets/app_bottom_nav_bar.dart';
import 'package:restrant_app/screens/customScreen/widgets/app_drawer.dart';
import 'package:restrant_app/screens/customScreen/widgets/custom_app_bar.dart';
import 'package:restrant_app/screens/homeScreen/home_screen.dart';
import 'package:restrant_app/screens/menuScreens/menu_screen.dart';
import 'package:restrant_app/screens/profileScreen/profile_screen.dart';
import 'package:restrant_app/screens/reserveTableScreen/final_reservation.dart';
// import 'package:restrant_app/screens/reserveTableScreen/reserve_table_screen.dart';
import 'package:restrant_app/screens/searchScreen/search_screen.dart';
import 'package:restrant_app/utils/colors_utility.dart';

class CustomScreen extends StatefulWidget {
  const CustomScreen({super.key, this.initialIndex = 0});
  final int initialIndex;
  static const String id = 'CustomScreen';

  @override
  State<CustomScreen> createState() => _HomePageState();
}

class _HomePageState extends State<CustomScreen> {
  late int _currentIndex;
  final List<Widget> _pages = [
    const HomeScreen(),
    const MenuScreen(),
    SearchScreen(),
    const TableSelectionPage(),
    const ProfileScreen(),
  ];

  @override
  void initState() {
    _currentIndex = widget.initialIndex;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      endDrawer: const AppDrawer(),
      body: _pages[_currentIndex],
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
      floatingActionButton: _currentIndex == 0
          ? FloatingActionButton(
              backgroundColor: ColorsUtility.errorSnackbarColor,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatScreen(),
                  ),
                );
              },
              child: const Icon(
                Icons.chat_bubble_outline_rounded,
              ),
            )
          : null,
      // floatingActionButton: _currentIndex == 0
      //     ? FloatingActionButton(
      //         backgroundColor: ColorsUtility.errorSnackbarColor,
      //         onPressed: () {
      //           Navigator.push(
      //             context,
      //             MaterialPageRoute(
      //               builder: (context) => ChatWidget(),
      //             ),
      //           );
      //         },
      //         child: const Icon(
      //           Icons.chat_bubble_outline_rounded,
      //         ),
      //       )
      //     : null,
    );
  }
}
