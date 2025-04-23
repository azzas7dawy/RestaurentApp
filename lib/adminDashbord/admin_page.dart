import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  final TextEditingController _titleArController = TextEditingController();
  final TextEditingController _titleEnController = TextEditingController();
  final TextEditingController _descriptionArController = TextEditingController();
  final TextEditingController _descriptionEnController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  XFile? _pickedImage;
  String? _editingId;

  Future<void> _pickImage() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _pickedImage = picked;
    });
  }

  void _showItemDialog({Map<String, dynamic>? item, String? docId}) {
    _titleArController.text = item?['title_ar'] ?? '';
    _titleEnController.text = item?['title_en'] ?? '';
    _descriptionArController.text = item?['description_ar'] ?? '';
    _descriptionEnController.text = item?['description_en'] ?? '';
    _priceController.text = item?['price']?.toString() ?? '';
    _pickedImage = null;
    _editingId = docId;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF2a2e34),
        title: Text(docId == null ? "Add Item" : "Edit Item",
            style: const TextStyle(color: Colors.white)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _titleArController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: "اسم الأكل (عربي)",
                  hintStyle: TextStyle(color: Colors.grey),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _titleEnController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: "Food Name (English)",
                  hintStyle: TextStyle(color: Colors.grey),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _descriptionArController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: "وصف الأكل (عربي)",
                  hintStyle: TextStyle(color: Colors.grey),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _descriptionEnController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: "Description (English)",
                  hintStyle: TextStyle(color: Colors.grey),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _priceController,
                style: const TextStyle(color: Colors.white),
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: "Price",
                  hintStyle: TextStyle(color: Colors.grey),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _pickImage,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                child: const Text("Pick Image"),
              ),
              if (_pickedImage != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    "Image selected: ${_pickedImage!.name}",
                    style: const TextStyle(color: Colors.white70),
                  ),
                )
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              _titleArController.clear();
              _titleEnController.clear();
              _descriptionArController.clear();
              _descriptionEnController.clear();
              _priceController.clear();
              _pickedImage = null;
              Navigator.pop(context);
            },
            child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: _saveItem,
            style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
            child: Text(docId == null ? "Add" : "Update"),
          ),
        ],
      ),
    );
  }

  void _saveItem() async {
    final titleAr = _titleArController.text.trim();
    final titleEn = _titleEnController.text.trim();
    final descriptionAr = _descriptionArController.text.trim();
    final descriptionEn = _descriptionEnController.text.trim();
    final price = double.tryParse(_priceController.text.trim());

    if (titleAr.isEmpty || titleEn.isEmpty || descriptionAr.isEmpty || descriptionEn.isEmpty || price == null) return;

    final menuRef = FirebaseFirestore.instance.collection('menu');
    String? imageUrl;

    if (_pickedImage != null) {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('menu_images')
          .child('${DateTime.now().millisecondsSinceEpoch}_${_pickedImage!.name}');
      await storageRef.putData(await _pickedImage!.readAsBytes());
      imageUrl = await storageRef.getDownloadURL();
    }

    final data = {
      'title_ar': titleAr,
      'title_en': titleEn,
      'description_ar': descriptionAr,
      'description_en': descriptionEn,
      'price': price,
      'image': imageUrl,
      'createdAt': Timestamp.now(),
    };

    if (_editingId == null) {
      await menuRef.add(data);
    } else {
      if (imageUrl == null) data.remove('image');
      data.remove('createdAt');
      await menuRef.doc(_editingId).update(data);
    }

    _titleArController.clear();
    _titleEnController.clear();
    _descriptionArController.clear();
    _descriptionEnController.clear();
    _priceController.clear();
    _pickedImage = null;
    _editingId = null;
    Navigator.pop(context);
  }

  void _deleteItem(String docId) async {
    await FirebaseFirestore.instance.collection('menu_items').doc(docId).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1a1d21),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF4A919E),
        onPressed: () => _showItemDialog(),
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Menu Management",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('menu_items')
                    .orderBy('createdAt', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Text("Error loading items",
                        style: TextStyle(color: Colors.red));
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                        child: CircularProgressIndicator(color: Colors.white));
                  }

                  final items = snapshot.data!.docs;

                  if (items.isEmpty) {
                    return const Text("No items found.",
                        style: TextStyle(color: Colors.grey));
                  }

                  return ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index].data() as Map<String, dynamic>;
                      final docId = items[index].id;

                      return ListTile(
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                        tileColor: const Color(0xFF2a2e34),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        leading: item['image'] != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  item['image'],
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : const Icon(Icons.fastfood, color: Colors.white),
                        title: Text(
                          "${item['title_ar']} / ${item['title_en']}",
                          style: const TextStyle(color: Colors.white),
                        ),
                        subtitle: Text("Price: \$${item['price']}",
                            style: const TextStyle(color: Colors.grey)),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.teal),
                              onPressed: () =>
                                  _showItemDialog(item: item, docId: docId),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete,
                                  color: Colors.redAccent),
                              onPressed: () => _deleteItem(docId),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}