import 'package:flutter/material.dart';
import 'package:restrant_app/adminDashbord/menuItem.dart';
class MenuItemCard extends StatelessWidget {
   final String name;
  final MenuItem menuItem;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const MenuItemCard({
    required this.name,
    required this.menuItem,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(menuItem.image, fit: BoxFit.cover),
            const SizedBox(height: 8),
            Text(menuItem.title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text(menuItem.description, style: TextStyle(color: Colors.grey)),
            Text('\$${menuItem.price.toStringAsFixed(2)}', style: TextStyle(color: Colors.green)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: onEdit,
                  child: Text('Edit'),
                ),
                ElevatedButton(
                  onPressed: onDelete,
                  child: Text('Delete'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}