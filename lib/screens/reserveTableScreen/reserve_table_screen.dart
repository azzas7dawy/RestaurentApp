import 'package:flutter/material.dart';

class ReserveTableScreen extends StatelessWidget {
  const ReserveTableScreen({super.key});
  static const String id = 'ReserveTableScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'TABLE',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
