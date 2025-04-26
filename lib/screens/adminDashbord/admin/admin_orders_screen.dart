import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AdminOrdersScreen extends StatefulWidget {
  const AdminOrdersScreen({super.key});
  static const String id = 'admin_orders_screen';

  @override
  State<AdminOrdersScreen> createState() => _AdminOrdersScreenState();
}

class _AdminOrdersScreenState extends State<AdminOrdersScreen> {
  bool isAdmin = false;

  final List<String> statusOptions = const [
  
    'Accepted',

    'Rejected',
  
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

  void _confirmStatusChange(BuildContext context, String docId, String newStatus) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("confirm change"),
        content: Text("are you sure you want to change the status of this order to: \"$newStatus\"؟"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text("cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              FirebaseFirestore.instance
                  .collection('orders')
                  .doc(docId)
                  .update({'status': newStatus});
              Navigator.of(ctx).pop();
            },
            child: const Text("save"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFF1a1d21),
        appBar: AppBar(
          title: const Text("Manage Orders", style: TextStyle(color: Colors.white)),
          actions: [
          //  IconButton(onPressed: (){
          //   Navigator.pop(context);
          //  }, icon:Icon(Icons.arrow_back_ios_new) ),
            IconButton(
              icon: const Icon(Icons.download),
              onPressed: () {
                // Add Export functionality here
                print(" Export button pressed");
              },
            ),
          ],
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('orders')
              .orderBy('timestamp', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(child: Text("Error loading orders", style: TextStyle(color: Colors.red)));
            }
      
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator(color: Colors.white));
            }
      
            final orders = snapshot.data!.docs;
      
            if (orders.isEmpty) {
              return const Center(child: Text("no orders", style: TextStyle(color: Colors.grey)));
            }
      
            return ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final doc = orders[index];
                final order = doc.data() as Map<String, dynamic>;
      
                final currentStatus = order['status'];
                final validStatus = statusOptions.contains(currentStatus) ? currentStatus : null;
      
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
                      Text("Order #${doc.id}", style: const TextStyle(color: Color(0xFF4A919E), fontSize: 16)),
                      //  Text("Order #${}", style: const TextStyle(color: Color(0xFF4A919E), fontSize: 16)),
                      // Text("table number: ${order['tableNumber']}", style: const TextStyle(color: Colors.white70)),
                      Text("user: ${order ['user']}", style: const TextStyle(color: Colors.white70)),
                      Text("order: ${order['order']}", style: const TextStyle(color: Colors.white70)),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Text("status: ", style: TextStyle(color: Colors.white70)),
                          DropdownButton<String>(
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
                              if (newValue != null && newValue != currentStatus) {
                                _confirmStatusChange(context, doc.id, newValue);
                              }
                            },
                          ),
                        ],
                      ),
                      Text("paymentMethod: ${order['paymentMethod']}", style: const TextStyle(color: Colors.white70)),
                      Text("total: \$${order['total']}", style: const TextStyle(color: Color(0xFFD4A017), fontSize: 14)),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
