// Flutter screen for menu management with dynamic sections, image upload, animation, and full CRUD support

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  final TextEditingController _nameArController = TextEditingController();
  final TextEditingController _nameEnController = TextEditingController();
  final TextEditingController _descArController = TextEditingController();
  final TextEditingController _descEnController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  XFile? _pickedImage;
  String? _selectedSection;
  String? _editingDocId;
  List<String> _sections = [];

  @override
  void initState() {
    super.initState();
    _fetchSections();
  }

  Future<void> _fetchSections() async {
    final snapshot = await FirebaseFirestore.instance.collection('menu').get();
    setState(() {
      _sections = snapshot.docs.map((doc) => doc.id).toList();
    });
  }

  Future<String?> _uploadImage(XFile image) async {
    final ref = FirebaseStorage.instance
        .ref('menu_images/${DateTime.now().millisecondsSinceEpoch}_${image.name}');
    Uint8List data = await image.readAsBytes();
    await ref.putData(data);
    return await ref.getDownloadURL();
  }

  void _showItemDialog({Map<String, dynamic>? item, String? section, String? docId}) {
    _nameArController.text = item?['name_ar'] ?? '';
    _nameEnController.text = item?['name_en'] ?? '';
    _descArController.text = item?['desc_ar'] ?? '';
    _descEnController.text = item?['desc_en'] ?? '';
    _priceController.text = item?['price']?.toString() ?? '';
    _selectedSection = section;
    _editingDocId = docId;
    _pickedImage = null;

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
              DropdownButton<String>(
                value: _selectedSection,
                hint: const Text("Select Section", style: TextStyle(color: Colors.grey)),
                dropdownColor: Colors.grey[900],
                style: const TextStyle(color: Colors.white),
                isExpanded: true,
                items: _sections.map((e) => DropdownMenuItem(
                      value: e,
                      child: Text(e),
                    )).toList(),
                onChanged: (val) => setState(() => _selectedSection = val),
              ),
              TextField(controller: _nameArController, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(hintText: 'اسم المنتج', hintStyle: TextStyle(color: Colors.grey))),
              TextField(controller: _nameEnController, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(hintText: 'Product Name', hintStyle: TextStyle(color: Colors.grey))),
              TextField(controller: _descArController, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(hintText: 'الوصف بالعربية', hintStyle: TextStyle(color: Colors.grey))),
              TextField(controller: _descEnController, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(hintText: 'Description (English)', hintStyle: TextStyle(color: Colors.grey))),
              TextField(controller: _priceController, keyboardType: TextInputType.number, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(hintText: 'السعر', hintStyle: TextStyle(color: Colors.grey))),
              ElevatedButton(
                onPressed: () async {
                  final image = await _picker.pickImage(source: ImageSource.gallery);
                  setState(() {
                    _pickedImage = image;
                  });
                },
                child: const Text("اختر صورة")
              )
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("إلغاء", style: TextStyle(color: Colors.grey))),
          ElevatedButton(
            onPressed: _saveItem,
            child: Text(docId == null ? "إضافة" : "تحديث"),
          ),
        ],
      ),
    );
  }

  void _saveItem() async {
    final section = _selectedSection;
    if (section == null) return;
    final nameAr = _nameArController.text.trim();
    final nameEn = _nameEnController.text.trim();
    final descAr = _descArController.text.trim();
    final descEn = _descEnController.text.trim();
    final price = double.tryParse(_priceController.text.trim());
    if (nameAr.isEmpty || nameEn.isEmpty || descAr.isEmpty || descEn.isEmpty || price == null) return;

    String? imageUrl;
    if (_pickedImage != null) {
      imageUrl = await _uploadImage(_pickedImage!);
    }

    final data = {
      'name_ar': nameAr,
      'name_en': nameEn,
      'desc_ar': descAr,
      'desc_en': descEn,
      'price': price,
      'image': imageUrl,
      'updatedAt': FieldValue.serverTimestamp()
    };

    final ref = FirebaseFirestore.instance.collection('menu').doc(section).collection('items');

    if (_editingDocId == null) {
      await ref.add(data);
    } else {
      if (imageUrl == null) data.remove('image');
      await ref.doc(_editingDocId).update(data);
    }

    _nameArController.clear();
    _nameEnController.clear();
    _descArController.clear();
    _descEnController.clear();
    _priceController.clear();
    _pickedImage = null;
    _editingDocId = null;
    Navigator.pop(context);
  }

  void _deleteItem(String section, String docId) async {
    await FirebaseFirestore.instance.collection('menu').doc(section).collection('items').doc(docId).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1a1d21),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        onPressed: () => _showItemDialog(),
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _sections.length,
        itemBuilder: (context, index) {
          final section = _sections[index];
          return StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('menu').doc(section).collection('items').orderBy('updatedAt', descending: true).snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              final docs = snapshot.data!.docs;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(section, style: const TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  ...docs.map((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2a2e34),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: data['image'] != null
                              ? Image.network(
                                  data['image'],
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => const Icon(Icons.broken_image, color: Colors.white),
                                )
                              : const Icon(Icons.fastfood, color: Colors.white),
                        ),
                        title: Text('${data['name_ar']} / ${data['name_en']}', style: const TextStyle(color: Colors.white)),
                        subtitle: Text('${data['desc_ar']}', style: const TextStyle(color: Colors.white70)),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(icon: const Icon(Icons.edit, color: Colors.teal), onPressed: () => _showItemDialog(item: data, section: section, docId: doc.id)),
                            IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () => _deleteItem(section, doc.id)),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                  const Divider(color: Colors.white30),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
