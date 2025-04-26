import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:restrant_app/screens/adminDashbord/admin/detials.dart';

class CategoryItemsScreenn extends StatefulWidget {
  final String categoryId;
  static const String id = 'category_items_screen';

  const CategoryItemsScreenn({super.key, required this.categoryId});

  @override
  State<CategoryItemsScreenn> createState() => _CategoryItemsScreennState();
}

class _CategoryItemsScreennState extends State<CategoryItemsScreenn> {
  late Future<QuerySnapshot> _itemsFuture;

  @override
  void initState() {
    super.initState();
    _itemsFuture = _fetchItems();
  }

  Future<QuerySnapshot> _fetchItems() {
    return FirebaseFirestore.instance
        .collection('menu')
        .doc(widget.categoryId)
        .collection('items')
        .get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1a1d21),
      appBar: AppBar(
        title: Text(widget.categoryId),
        backgroundColor: const Color(0xFF2a2e34),
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: _itemsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.teal),
            );
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text(
                'حدث خطأ أثناء تحميل البيانات.',
                style: TextStyle(color: Colors.red),
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                'لا توجد عناصر هنا.',
                style: TextStyle(color: Colors.white70),
              ),
            );
          }

          final items = snapshot.data!.docs;

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: items.length,
            separatorBuilder: (context, index) =>
                const Divider(color: Colors.white30),
            itemBuilder: (context, index) {
              final item = items[index];
              final itemName = item['category'] ?? 'اسم غير معروف';
              final imageUrl = item['image'] ?? '';

              return ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    imageUrl,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.error, color: Colors.red),
                  ),
                ),
                title: Text(
                  itemName,
                  style: const TextStyle(color: Colors.white),
                ),
                trailing:
                    const Icon(Icons.arrow_forward_ios, color: Colors.teal),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ItemDetailsScreen(
                        itemData: item.data() as Map<String, dynamic>,
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
