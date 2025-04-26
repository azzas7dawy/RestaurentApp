import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class AdminCategoryItemsScreen extends StatefulWidget {
  final String categoryId;
  const AdminCategoryItemsScreen({super.key, required this.categoryId});

  @override
  State<AdminCategoryItemsScreen> createState() => _AdminCategoryItemsScreenState();
}

class _AdminCategoryItemsScreenState extends State<AdminCategoryItemsScreen> {
  final picker = ImagePicker();

  Future<void> _addOrEditItem({DocumentSnapshot? existingDoc}) async {
    final isEditing = existingDoc != null;
    final nameArController = TextEditingController(text: existingDoc?['title_ar'] ?? '');
    final nameEnController = TextEditingController(text: existingDoc?['title'] ?? '');
    final descArController = TextEditingController(text: existingDoc?['desc_ar'] ?? '');
    final descEnController = TextEditingController(text: existingDoc?['description'] ?? '');
    final priceController = TextEditingController(text: existingDoc?['price']?.toString() ?? '');
    File? imageFile;
    String? imageUrl = existingDoc?['image'];

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(isEditing ? 'Edit Item' : 'Add Item'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(controller: nameArController, decoration: const InputDecoration(labelText: 'Name (Arabic)')),
              TextField(controller: nameEnController, decoration: const InputDecoration(labelText: 'Name (English)')),
              TextField(controller: descArController, decoration: const InputDecoration(labelText: 'Description (Arabic)')),
              TextField(controller: descEnController, decoration: const InputDecoration(labelText: 'Description (English)')),
              TextField(controller: priceController, decoration: const InputDecoration(labelText: 'Price'), keyboardType: TextInputType.number),
              const SizedBox(height: 10),
              imageUrl != null
                  ? Image.network(imageUrl, height: 100)
                  : const SizedBox.shrink(),
              ElevatedButton(
                onPressed: () async {
                  final pickedFile = await picker.pickImage(source: ImageSource.gallery);
                  if (pickedFile != null) {
                    imageFile = File(pickedFile.path);
                  }
                },
                child: const Text("Pick Image"),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              if (nameArController.text.isEmpty || priceController.text.isEmpty) return;

              String? uploadedImageUrl = imageUrl;

              if (imageFile != null) {
                final ref = FirebaseStorage.instance
                    .ref('items/${DateTime.now().millisecondsSinceEpoch}.jpg');
                await ref.putFile(imageFile!);
                uploadedImageUrl = await ref.getDownloadURL();
              }

              final data = {
                'title_ar': nameArController.text,
                'title': nameEnController.text,
                'desc_ar': descArController.text,
                'desc_en': descEnController.text,
                'price': double.tryParse(priceController.text) ?? 0,
                'image': uploadedImageUrl,
              };

              final collection = FirebaseFirestore.instance
                  .collection('menu')
                  .doc(widget.categoryId)
                  .collection('items');

              if (isEditing) {
                await collection.doc(existingDoc!.id).update(data);
              } else {
                await collection.add(data);
              }
            },
            child: Text(isEditing ? 'Save' : 'Add'),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteItem(String itemId) async {
    await FirebaseFirestore.instance
        .collection('menu')
        .doc(widget.categoryId)
        .collection('items')
        .doc(itemId)
        .delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Items - ${widget.categoryId}'),
        backgroundColor: const Color.fromARGB(255, 134, 150, 173),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _addOrEditItem(),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('menu')
            .doc(widget.categoryId)
            .collection('items')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final items = snapshot.data!.docs;

          if (items.isEmpty) {
            return const Center(child: Text("No items found."));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              final data = item.data() as Map<String, dynamic>;
              return Card(
                child: ListTile(
                  leading: data['image'] != null
                      ? CachedNetworkImage(imageUrl: data['image'], width: 50, height: 50, fit: BoxFit.cover)
                      : const Icon(Icons.fastfood),
                  title: Text('${data['name_ar']} / ${data['name_en']}'),
                  subtitle: Text('${data['price']} EGP\n${data['desc_en']}'),
                  isThreeLine: true,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => _addOrEditItem(existingDoc: item),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteItem(item.id),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
