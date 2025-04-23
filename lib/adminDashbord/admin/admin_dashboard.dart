import 'package:flutter/material.dart';
import 'package:restrant_app/adminDashbord/admin/admin_orders_screen.dart';

import 'orders_screen.dart';
import 'menu_screen.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});
  static const String id = 'adminDashboard';

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int currentIndex = 0;

  final screens = [
    const OrdersScreen(),
    MenuScreen(),
  
   const AdminOrdersScreen(),

  
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        backgroundColor: const Color(0xFF212529),
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const Text("Admin Dashboard",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold)),
            const Divider(color: Colors.grey),
            ListTile(
              title: const Text(" Orders", style: TextStyle(color: Colors.white)),
              onTap: () {
                setState(() {
                  currentIndex = 0;
                  Navigator.pop(context);
                });
              },
            ),
            ListTile(
              title: const Text("Menu", style: TextStyle(color: Colors.white)),
              onTap: () {
                setState(() {
                  currentIndex = 1;
                  Navigator.pop(context);
                });
              },
            ),
            ListTile(
              title: const Text(" AdminOrders", style: TextStyle(color: Colors.white)),
              onTap: () {
                setState(() {
                  currentIndex = 2;
                  Navigator.pop(context);
                });
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text("Admin Dashboard"),
        backgroundColor: const Color(0xFF2A2E32),
      ),
      body: screens[currentIndex],
    );
  }
}
