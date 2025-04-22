import 'package:flutter/material.dart';
import 'package:restrant_app/adminDashbord/Category.dart';

class CategorySelector extends StatelessWidget {
  final List<Category> categories;
  final String? selectedCategory;
  final ValueChanged<String> setSelectedCategory;

  const CategorySelector({
    required this.categories,
    required this.selectedCategory,
    required this.setSelectedCategory,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Menu', style: TextStyle(color: Colors.white)),
        DropdownButton<String>(
          value: selectedCategory,
          hint: Text('Select Category'),
          onChanged: (value) => setSelectedCategory(value!),
          items: categories.map((Category cat) {
            return DropdownMenuItem<String>(
              value: cat.id,
              child: Text(cat.name),
            );
          }).toList(),
        ),
      ],
    );
  }
}