import 'package:flutter/material.dart';

class ItemDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> itemData;

  const ItemDetailsScreen({super.key, required this.itemData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(itemData['category_ar'] ?? 'Details'),
        backgroundColor: const Color(0xFF2a2e34),
      ),
      backgroundColor: const Color(0xFF1a1d21),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (itemData['image'] != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  itemData['image'],
                  height: 250,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image, size: 100, color: Colors.white54),
                ),
              ),
            const SizedBox(height: 20),
            Text(
              '${itemData['category_ar']} / ${itemData['category']}',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              itemData['desc_ar'] ?? '',
              style: const TextStyle(fontSize: 18, color: Colors.white70),
            ),
            const SizedBox(height: 20),
            Text(
              itemData['description'] ?? '',
              style: const TextStyle(fontSize: 16, color: Colors.white54),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Text(
                  'Price: ',
                  style: const TextStyle(fontSize: 20, color: Colors.white),
                ),
                Text(
                  '${itemData['price']} EGP',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.tealAccent,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              itemData['is_available'] == true ? 'Available' : 'Not Available',
              style: TextStyle(
                fontSize: 18,
                color: itemData['is_available'] == true ? Colors.green : Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
