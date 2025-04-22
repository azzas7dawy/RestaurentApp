import 'package:flutter/material.dart';

class Sidebar extends StatelessWidget {
  final ValueChanged<String> setShowModal;

  const Sidebar({required this.setShowModal});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Column(
        children: [
          Text('Admin Panel', style: TextStyle(color: Colors.white)),
          ElevatedButton(
            onPressed: () => setShowModal('category'),
            child: Text('Add Category'),
          ),
          ElevatedButton(
            onPressed: () {
              // Sign out logic
            },
            child: Text('Sign Out'),
          ),
        ],
      ),
    );
  }
}