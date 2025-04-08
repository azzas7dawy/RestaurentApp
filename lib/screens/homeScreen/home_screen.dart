import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  static const String id = 'HomeScreen';

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Home Screen',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
