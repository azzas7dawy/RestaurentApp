import 'package:flutter/material.dart';
import 'package:restrant_app/screens/customScreen/widgets/app_bottom_nav_bar.dart';
import 'package:restrant_app/screens/customScreen/widgets/app_drawer.dart';
import 'package:restrant_app/screens/customScreen/widgets/custom_app_bar.dart';
import 'package:restrant_app/screens/homeScreen/home_screen.dart';

class CustomScreen extends StatefulWidget {
  const CustomScreen({super.key});
  static const String id = 'CustomScreen';

  @override
  State<CustomScreen> createState() => _HomePageState();
}

class _HomePageState extends State<CustomScreen> {
  int _currentIndex = 0;
  final List<Widget> _pages = const [
    HomeScreen(),
    Center(child: Text('Order Food')),
    Center(child: Text('Reserve Table')),
    Center(child: Text('Profile')),
  ];

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
    );
  }
}
