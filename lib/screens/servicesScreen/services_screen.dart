import 'package:flutter/material.dart';

class ServicesScreen extends StatelessWidget {
  const ServicesScreen({super.key});
  static const String id = 'Services';

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'services',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}