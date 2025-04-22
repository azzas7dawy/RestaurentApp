import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class AdminDashboard extends StatelessWidget {
  const AdminDashboard({Key? key}) : super(key: key);
  static const String id = 'adminDashboard';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Sidebar
          Container(
            width: MediaQuery.of(context).size.width / 6, // Sidebar width
            color: Color(0xFF212529), // Dark gray color
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Admin Panel', style: TextStyle(color: Colors.white, fontSize: 24)),
                  SizedBox(height: 30),
                  SidebarItem(label: 'Orders', icon: Icons.list),
                  SidebarItem(label: 'Statistics', icon: Icons.bar_chart),
                  SidebarItem(label: 'Chat', icon: Icons.chat),
                ],
              ),
            ),
          ),
          
          // Main Content
          Expanded(
            child: Container(
              color: Color(0xFF1A1D21), // Dark background
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    SectionTitle(title: 'Orders Management'),
                    OrderCard(),
                    SizedBox(height: 20),
                    SectionTitle(title: 'Statistics'),
                    StatisticsCard(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SidebarItem extends StatelessWidget {
  final String label;
  final IconData icon;

  const SidebarItem({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.white),
          SizedBox(width: 10),
          Text(label, style: TextStyle(color: Colors.white, fontSize: 16)),
        ],
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;
  
  const SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Text(
        title,
        style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class OrderCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color(0xFF2A2E34),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Order #1234', style: TextStyle(color: Colors.white)),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Color(0xFF4A919E), // Accepted status
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text('Accepted', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
            SizedBox(height: 10),
            Text('Customer: John Doe', style: TextStyle(color: Colors.white)),
            Text('Total: \$150', style: TextStyle(color: Colors.yellow)),
          ],
        ),
      ),
    );
  }
}

class StatisticsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color(0xFF2A2E34),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text('Total Orders', style: TextStyle(color: Colors.white, fontSize: 16)),
            SizedBox(height: 10),
            Text('250', style: TextStyle(color: Colors.white, fontSize: 24)),
          ],
        ),
      ),
    );
  }
}
