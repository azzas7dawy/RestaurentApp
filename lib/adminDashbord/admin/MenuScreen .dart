import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:restrant_app/adminDashbord/admin/CategoryItemsScreen.dart';
import 'package:restrant_app/adminDashbord/categoryItemScreenAdmin.dart';


class AdminMenuScreen extends StatefulWidget {
  const AdminMenuScreen({super.key});
  static const String id = 'admin_menu_screen';

  @override
  State<AdminMenuScreen> createState() => _AdminMenuScreenState();
}

class _AdminMenuScreenState extends State<AdminMenuScreen> {
  final TextEditingController _nameController = TextEditingController();

  void _addCategoryDialog() {
    _nameController.clear();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF2a2e34),
        title: const Text("Add Category", style: TextStyle(color: Colors.white)),
        content: TextField(
          controller: _nameController,
          decoration: const InputDecoration(hintText: "Category name", hintStyle: TextStyle(color: Colors.white38)),
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              final name = _nameController.text.trim();
              if (name.isNotEmpty) {
                await FirebaseFirestore.instance.collection('menu').doc(name).set({});
                Navigator.pop(context);
              }
            },
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }

  void _editCategoryDialog(String oldName) {
    _nameController.text = oldName;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF2a2e34),
        title: const Text("Edit Category", style: TextStyle(color: Colors.white)),
        content: TextField(
          controller: _nameController,
          decoration: const InputDecoration(hintText: "New category name", hintStyle: TextStyle(color: Colors.white38)),
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              final newName = _nameController.text.trim();
              if (newName.isNotEmpty && newName != oldName) {
                final oldDoc = FirebaseFirestore.instance.collection('menu').doc(oldName);
                final newDoc = FirebaseFirestore.instance.collection('menu').doc(newName);
                final items = await oldDoc.collection('items').get();

                await newDoc.set({});
                for (var item in items.docs) {
                  await newDoc.collection('items').doc(item.id).set(item.data());
                }
                await oldDoc.delete();
                Navigator.pop(context);
              }
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }
  // void _addItemDialog(String categoryId) {
  //   showDialog(
  //     context: context,
  //     builder: (_) => AlertDialog(
  //       backgroundColor: const Color(0xFF2a2e34),
  //       title: const Text("Add Item", style: TextStyle(color: Colors.white)),
  //       content: CategoryItemsScreenn(categoryId: categoryId),
  //     ),
  //   );
  // }

  void _deleteCategory(String categoryId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF2a2e34),
        title: const Text("Delete Category", style: TextStyle(color: Colors.white)),
        content: const Text("Are you sure you want to delete this category?", style: TextStyle(color: Colors.white70)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Cancel")),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text("Delete")),
        ],
      ),
    );

    if (confirm == true) {
      final docRef = FirebaseFirestore.instance.collection('menu').doc(categoryId);
      final items = await docRef.collection('items').get();
      for (var doc in items.docs) {
        await docRef.collection('items').doc(doc.id).delete();
      }
      await docRef.delete();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1a1d21),
      appBar: AppBar(
        title: const Text("Admin Menu"),
        backgroundColor: const Color.fromARGB(255, 134, 150, 173),
        actions: [
          IconButton(
            onPressed: _addCategoryDialog,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('menu').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

          final categories = snapshot.data!.docs;

          if (categories.isEmpty) {
            return const Center(child: Text('No categories yet', style: TextStyle(color: Colors.white70)));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            separatorBuilder: (_, __) => const Divider(color: Colors.white24),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final doc = categories[index];
              final categoryName = doc.id;

              return ListTile(
                title: Text(categoryName, style: const TextStyle(color: Colors.white)),
                tileColor: const Color(0xFF2a2e34),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                trailing: Wrap(
                  spacing: 10,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.amber),
                      onPressed: () => _editCategoryDialog(categoryName),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteCategory(categoryName),
                    ),
                    IconButton(
                      icon: const Icon(Icons.arrow_forward, color: Colors.tealAccent),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => AdminCategoryItemsScreen(categoryId: categoryName),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
