import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';

class AddItemDialog extends StatefulWidget {
  final String categoryId;
  final String? docId; // في حالة تعديل عنصر موجود

  const AddItemDialog({super.key, required this.categoryId, this.docId});

  @override
  State<AddItemDialog> createState() => _AddItemDialogState();
}

class _AddItemDialogState extends State<AddItemDialog> {
  final _nameArController = TextEditingController();
  final _nameEnController = TextEditingController();
  final _descArController = TextEditingController();
  final _descEnController = TextEditingController();
  final _priceController = TextEditingController();

  final _picker = ImagePicker();
  XFile? _pickedImage;

  @override
  void initState() {
    super.initState();
    if (widget.docId != null) {
      _loadItemData(widget.docId!);
    }
  }

  Future<void> _loadItemData(String docId) async {
    final doc = await FirebaseFirestore.instance
        .collection('menu')
        .doc(widget.categoryId)
        .collection('items')
        .doc(docId)
        .get();
    final data = doc.data() as Map<String, dynamic>;
    _nameArController.text = data['name_ar'];
    _nameEnController.text = data['name_en'];
    _descArController.text = data['desc_ar'];
    _descEnController.text = data['desc_en'];
    _priceController.text = data['price'].toString();
  }

  Future<String?> _uploadImage(XFile image) async {
    final ref = FirebaseStorage.instance
        .ref('menu_images/${DateTime.now().millisecondsSinceEpoch}_${image.name}');
    Uint8List data = await image.readAsBytes();
    await ref.putData(data);
    return await ref.getDownloadURL();
  }

  void _saveItem() async {
    final nameAr = _nameArController.text.trim();
    final nameEn = _nameEnController.text.trim();
    final descAr = _descArController.text.trim();
    final descEn = _descEnController.text.trim();
    final price = double.tryParse(_priceController.text.trim());

    if (nameAr.isEmpty || nameEn.isEmpty || descAr.isEmpty || descEn.isEmpty || price == null) {
      return;
    }

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
      'updatedAt': FieldValue.serverTimestamp(),
    };

    final ref = FirebaseFirestore.instance
        .collection('menu')
        .doc(widget.categoryId)
        .collection('items');

    if (widget.docId == null) {
      await ref.add(data); // إضافة العنصر
    } else {
      await ref.doc(widget.docId).update(data); // تعديل العنصر
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.docId == null ? "Add Item" : "Edit Item"),
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextField(controller: _nameArController, decoration: const InputDecoration(hintText: 'اسم المنتج')),
            TextField(controller: _nameEnController, decoration: const InputDecoration(hintText: 'Product Name')),
            TextField(controller: _descArController, decoration: const InputDecoration(hintText: 'الوصف بالعربية')),
            TextField(controller: _descEnController, decoration: const InputDecoration(hintText: 'Description (English)')),
            TextField(controller: _priceController, keyboardType: TextInputType.number, decoration: const InputDecoration(hintText: 'السعر')),
            ElevatedButton(
              onPressed: () async {
                final image = await _picker.pickImage(source: ImageSource.gallery);
                setState(() {
                  _pickedImage = image;
                });
              },
              child: const Text("اختر صورة")
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text("إلغاء")),
        ElevatedButton(onPressed: _saveItem, child: const Text("حفظ")),
      ],
    );
  }
}
