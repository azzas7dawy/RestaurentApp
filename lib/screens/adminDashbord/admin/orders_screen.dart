import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OrdersScreenn extends StatefulWidget {
  const OrdersScreenn({super.key});
  static const String id = 'orders_screen';

  @override
  State<OrdersScreenn> createState() => _OrdersScreennState();
}

class _OrdersScreennState extends State<OrdersScreenn> {
  bool isAdmin = false;

  final List<String> statusOptions = const [
    'Under Review',
    'In Progress',
    'Ready for Pickup',
    'Out for Delivery',
    'Delivered',
    'Cancelled',
  ];

  @override
  void initState() {
    super.initState();
    getAdminStatus();
  }

  Future<void> getAdminStatus() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      setState(() {
        isAdmin = doc.data()?['isAdmin'] ?? false;
      });
    }
  }

  void _confirmStatusChange(
    BuildContext context,
    String docId,
    String newStatus,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Confirm Change"),
        content: Text("Are you sure you want to change the status of this order to: \"$newStatus\"؟"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              FirebaseFirestore.instance
                  .collection('orders')
                  .doc(docId)
                  .update({'status': newStatus});
              Navigator.of(ctx).pop();
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1a1d21),
      appBar: AppBar(
        title: const Text('Manage Orders'),
        backgroundColor: const Color(0xFF2a2e34),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Manage Orders",
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
                    .collection('orders')
                    .orderBy('timestamp', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Text("Error loading orders", style: TextStyle(color: Colors.red));
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                        child: CircularProgressIndicator(color: Colors.white));
                  }

                  final orders = snapshot.data!.docs;

                  if (orders.isEmpty) {
                    return const Text("No orders", style: TextStyle(color: Colors.grey));
                  }

                  return ListView.builder(
                    itemCount: orders.length,
                    itemBuilder: (context, index) {
                      final doc = orders[index];
                      final order = doc.data() as Map<String, dynamic>;

                      final currentStatus = order['status'];
                      final validStatus = statusOptions.contains(currentStatus)
                          ? currentStatus
                          : null;

                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2a2e34),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Text(
                                  "Status: ",
                                  style: TextStyle(color: Colors.white70),
                                ),
                                isAdmin
                                    ? DropdownButton<String>(
                                        value: validStatus,
                                        dropdownColor: const Color(0xFF2a2e34),
                                        style: const TextStyle(color: Colors.white),
                                        items: statusOptions.map((status) {
                                          return DropdownMenuItem<String>(
                                            value: status,
                                            child: Text(status),
                                          );
                                        }).toList(),
                                        onChanged: (newValue) {
                                          if (newValue != null &&
                                              newValue != order['status']) {
                                            _confirmStatusChange(
                                                context, doc.id, newValue);
                                          }
                                        },
                                      )
                                    : Text(
                                        order['status'],
                                        style: const TextStyle(color: Colors.white),
                                      ),
                              ],
                            ),
                            Text(
                              "Payment Method: ${order['paymentMethod']}",
                              style: const TextStyle(color: Colors.white70),
                            ),
                            Text(
                              "Total: \$${order['total']}",
                              style: const TextStyle(
                                  color: Color(0xFFD4A017), fontSize: 14),
                            ),

                            // عرض المنتجات داخل الطلب
                            if (order['items'] is String &&
                                (order['items'] as String).trim().isNotEmpty) ...[
                              const SizedBox(height: 8),
                              const Text(
                                "Items:",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              ...order['items']
                                  .split(',')
                                  .map((item) => Text("- ${item.trim()}",
                                      style: const TextStyle(color: Colors.white70)))
                                  .toList(),
                            ],
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
