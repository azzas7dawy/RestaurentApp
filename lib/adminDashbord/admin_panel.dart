import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:restrant_app/adminDashbord/Category.dart';
import 'package:restrant_app/adminDashbord/menuItem.dart';
import 'package:restrant_app/adminDashbord/meun_item_card.dart';
import 'sidebar.dart';
import 'category_selector.dart';
// import 'menu_item_card.dart';
import 'item_modal.dart';

class AdminPanel extends StatefulWidget {
  const AdminPanel({Key? key}) : super(key: key);
   static const String id = '/adminPanel';
  @override
  _AdminPanelState createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  User? user;
  List<Category> categories = [];
  String? selectedCategory;
  List<MenuItem> menuItems = [];
  String? showModal;

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((user) {
      setState(() {
        this.user = user;
        if (user != null) {
          loadCategories();
        }
      });
    });
  }

  void loadCategories() async {
    // Load categories from Firestore
    FirebaseFirestore.instance.collection('categories').get().then((snapshot) {
      setState(() {
        categories = snapshot.docs.map((doc) {
          return Category(
            id: doc.id,
            name: doc['name'],
          );
        }).toList();
        if (categories.isNotEmpty) {
          selectedCategory = categories[0].id;
          loadMenuItems(selectedCategory!);
        }
      });
    });
  }

  void loadMenuItems(String categoryId) async {
    // Load menu items from Firestore
    FirebaseFirestore.instance
        .collection('menu')
        .doc(categoryId)
        .collection('items')
        .get()
        .then((snapshot) {
      setState(() {
        menuItems = snapshot.docs.map((doc) {
          return MenuItem(
            id: doc.id ,
            name: doc['name'],
            description: doc['description'],
            price: doc['price'],
            image: doc['imageUrl'],
            special: doc['special'], docId: '', title: '',
          );
        }).toList();
      });
    });
  }
@override
Widget build(BuildContext context) {
  return SafeArea(
    child: Scaffold(
      body: Row(
        children: [
          Sidebar(setShowModal: (modal) => setState(() => showModal = modal)),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  CategorySelector(
                    categories: categories,
                    selectedCategory: selectedCategory,
                    setSelectedCategory: (category) {
                      setState(() {
                        selectedCategory = category;
                        loadMenuItems(category);
                      });
                    },
                  ),
                  const SizedBox(height: 16), // Space between category selector and list
                  Expanded(
                    child: ListView.builder(
                      itemCount: menuItems.length,
                      itemBuilder: (context, index) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: MenuItemCard(
                          menuItem: menuItems[index],
                          onEdit: () => setState(() => showModal = 'edit'),
                          onDelete: () => setState(() => showModal = 'delete'), name: menuItems[index].title,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
}
