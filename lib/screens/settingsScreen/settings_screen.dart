import 'package:flutter/material.dart';

class SettignsScreen extends StatelessWidget {
  const SettignsScreen({super.key});
  static const String id = 'SettingsScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Center(
        child: Text(
          'Settings Screen',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
}
