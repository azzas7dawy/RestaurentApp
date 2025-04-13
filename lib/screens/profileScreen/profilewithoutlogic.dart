import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileSectionn extends StatefulWidget {
  const ProfileSectionn({super.key});
  static const String id = 'ProfileSection';

  @override
  State<ProfileSectionn> createState() => _ProfileSectionState();
}

class _ProfileSectionState extends State<ProfileSectionn> {
  String? imageUrl;
  String? name;
  String? phone;
  String? email;
  String? address;
  String? foodPlanner;
  String? calorieCounter;
  String? payments;

  @override
  void initState() {
    super.initState();
    fetchProfileData();
  }

  Future<void> fetchProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      imageUrl = prefs.getString('profileImage');
      name = prefs.getString('name') ?? 'No Name';
      phone = prefs.getString('phone') ?? 'No Phone';
      email = prefs.getString('email') ?? 'No Email';
      address = prefs.getString('address') ?? 'No address yet';
      foodPlanner = prefs.getString('foodPlanner') ?? 'No plan yet';
      calorieCounter = prefs.getString('calories') ?? 'Not set';
      payments = prefs.getString('payments') ?? 'No payments found';
    });
  }

  Future<void> pickImage() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null && result.files.single.bytes != null) {
      Uint8List bytes = result.files.single.bytes!;
      final fileName = result.files.single.name;

      try {
        final storageRef = FirebaseStorage.instance.ref('profile_images/$fileName');
        await storageRef.putData(bytes);
        final downloadUrl = await storageRef.getDownloadURL();

        await FirebaseFirestore.instance.collection('users2').add({
          'profileImage': downloadUrl,
          'timestamp': FieldValue.serverTimestamp(),
        });

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('profileImage', downloadUrl);

        setState(() => imageUrl = downloadUrl);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Image upload failed: $e')),
        );
      }
    }
  }

  void showEditDialog(String field, String currentValue, BuildContext context) {
    final controller = TextEditingController(text: currentValue);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Edit $field'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Enter new value'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.setString(field, controller.text);

              Navigator.of(ctx).pop();
              fetchProfileData();

              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('$field updated successfully!')),
                );
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Widget buildEditableCard({
    required String title,
    required String content,
    required IconData icon,
    required VoidCallback onEdit,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.grey[900],
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 18, color: Colors.redAccent),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(title,
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                      IconButton(
                        onPressed: onEdit,
                        icon: const Icon(Icons.edit, size: 18, color: Colors.white70),
                      )
                    ],
                  ),
                  Text(content, style: const TextStyle(color: Colors.white70)),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildFoodPlanner() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.grey[900],
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // العنوان مع القلم
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Row(
                  children: [
                    Icon(Icons.restaurant_menu, size: 18, color: Colors.white),
                    SizedBox(width: 6),
                    Text('Food Planner', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                  ],
                ),
                Icon(Icons.edit, color: Colors.white70, size: 18),
              ],
            ),
            const SizedBox(height: 16),
            const Text("Today", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),

            // الخط و المراحل
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buildStepItem('Breakfast', true),
                buildDashedLine(),
                buildStepItem('Lunch', true),
                buildDashedLine(),
                buildStepItem('Dinner', false),
              ],
            ),

            const SizedBox(height: 20),
            const Text("This Week", style: TextStyle(color: Colors.white70)),
            const SizedBox(height: 8),
            const Text("Next Week", style: TextStyle(color: Colors.white70)),
          ],
        ),
      ),
    );
  }

  Widget buildStepItem(String label, bool isDone) {
    return Column(
      children: [
        CircleAvatar(
          radius: 14,
          backgroundColor: isDone ? Colors.green : Colors.grey,
          child: Icon(
            isDone ? Icons.check : Icons.circle,
            color: Colors.white,
            size: 16,
          ),
        ),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
      ],
    );
  }

  Widget buildDashedLine() {
    return Container(
      width: 20,
      height: 1,
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.white24, width: 1, style: BorderStyle.solid),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.clear();
              if (mounted) {
                Navigator.of(context).pushReplacementNamed('/login');
              }
            },
          )
        ],
      ),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            GestureDetector(
              onTap: pickImage,
              child: CircleAvatar(
                radius: 45,
                backgroundImage: imageUrl != null
                    ? NetworkImage(imageUrl!)
                    : null,
                onBackgroundImageError: (_, __) => {},
                child: imageUrl == null
                    ? const Icon(Icons.person, size: 45)
                    : null,
              ),
            ),
            const SizedBox(height: 10),
            InkWell(
              onTap: () => showEditDialog('name', name ?? '', context),
              child: Text(name ?? '', style: const TextStyle(color: Colors.white, fontSize: 20)),
            ),
            const SizedBox(height: 4),
            InkWell(
              onTap: () => showEditDialog('phone', phone ?? '', context),
              child: Text(phone ?? '', style: const TextStyle(color: Colors.white70)),
            ),
            InkWell(
              onTap: () => showEditDialog('email', email ?? '', context),
              child: Text(email ?? '', style: const TextStyle(color: Colors.white70)),
            ),
            const SizedBox(height: 20),

            buildEditableCard(
              title: 'Address',
              content: address ?? '',
              icon: Icons.location_on,
              onEdit: () => showEditDialog('address', address ?? '', context),
            ),

            buildFoodPlanner(),

            buildEditableCard(
              title: 'Calorie Counter',
              content: calorieCounter ?? '',
              icon: Icons.local_fire_department,
              onEdit: () => showEditDialog('calories', calorieCounter ?? '', context),
            ),

            buildEditableCard(
              title: 'Payments',
              content: payments ?? '',
              icon: Icons.payment,
              onEdit: () => showEditDialog('payments', payments ?? '', context),
            ),
          ],
        ),
      ),
    );
  }
}
