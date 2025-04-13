import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileSection extends StatefulWidget {
  const ProfileSection({super.key});
  static const String id = 'ProfileSection';

  @override
  State<ProfileSection> createState() => _ProfileSectionState();
}

class _ProfileSectionState extends State<ProfileSection> {
  String? imageUrl;
  String? name;
  String? phone;
  String? email;
  String? address;
  String? calorieCounter;
  String? payments;

  // Food planner statuses
  bool breakfastDone = false;
  bool lunchDone = false;
  bool dinnerDone = false;

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
      calorieCounter = prefs.getString('calories') ?? 'Not set';
      payments = prefs.getString('payments') ?? 'No payments found';

      // Load food planner statuses
      breakfastDone = prefs.getBool('breakfastDone') ?? false;
      lunchDone = prefs.getBool('lunchDone') ?? false;
      dinnerDone = prefs.getBool('dinnerDone') ?? false;
    });
  }

  Future<void> pickImage() async {
    try {
      final result = await FilePicker.platform.pickFiles(type: FileType.image);

      if (result != null && result.files.single.bytes != null) {
        Uint8List bytes = result.files.single.bytes!;
        final fileName = result.files.single.name;

        final storageRef =
        FirebaseStorage.instance.ref('profile_images/$fileName');
        await storageRef.putData(bytes);
        final downloadUrl = await storageRef.getDownloadURL();

        await FirebaseFirestore.instance.collection('users2').add({
          'profileImage': downloadUrl,
          'timestamp': FieldValue.serverTimestamp(),
        });

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('profileImage', downloadUrl);

        setState(() => imageUrl = downloadUrl);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('فشل في رفع الصورة! تأكد من الاتصال بالإنترنت.')),
      );
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

  Widget buildFoodPlannerStep(String label, bool isDone, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: isDone ? Colors.green : Colors.grey,
            child: Icon(
              isDone ? Icons.check : Icons.circle_outlined,
              color: Colors.white,
              size: 18,
            ),
          ),
          const SizedBox(height: 6),
          Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
        ],
      ),
    );
  }

  Widget buildFoodPlannerCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.grey[900],
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                Icon(Icons.restaurant_menu, color: Colors.white70, size: 18),
                SizedBox(width: 10),
                Text('Food Planner', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 16),
            const Text("Today", style: TextStyle(color: Colors.white, fontSize: 14)),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                buildFoodPlannerStep("Breakfast", breakfastDone, () => toggleMealStatus("breakfastDone")),
                Container(width: 30, height: 2, color: Colors.grey),
                buildFoodPlannerStep("Lunch", lunchDone, () => toggleMealStatus("lunchDone")),
                Container(width: 30, height: 2, color: Colors.grey),
                buildFoodPlannerStep("Dinner", dinnerDone, () => toggleMealStatus("dinnerDone")),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(color: Colors.white24),
            const SizedBox(height: 8),
            const Text("This Week", style: TextStyle(color: Colors.white)),
            const SizedBox(height: 4),
            const Text("Next Week", style: TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }

  Future<void> toggleMealStatus(String mealKey) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      if (mealKey == 'breakfastDone') {
        breakfastDone = !breakfastDone;
        prefs.setBool('breakfastDone', breakfastDone);
      } else if (mealKey == 'lunchDone') {
        lunchDone = !lunchDone;
        prefs.setBool('lunchDone', lunchDone);
      } else if (mealKey == 'dinnerDone') {
        dinnerDone = !dinnerDone;
        prefs.setBool('dinnerDone', dinnerDone);
      }
    });
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
                child: imageUrl == null
                    ? const Icon(Icons.person, size: 45)
                    : null,
              ),
            ),
            const SizedBox(height: 10),
            InkWell(
              onTap: () => showEditDialog('name', name ?? '', context),
              child: Text(name ?? '',
                  style: const TextStyle(color: Colors.white, fontSize: 20)),
            ),
            const SizedBox(height: 4),
            InkWell(
              onTap: () => showEditDialog('phone', phone ?? '', context),
              child: Text(phone ?? '',
                  style: const TextStyle(color: Colors.white70)),
            ),
            InkWell(
              onTap: () => showEditDialog('email', email ?? '', context),
              child: Text(email ?? '',
                  style: const TextStyle(color: Colors.white70)),
            ),
            const SizedBox(height: 20),
            buildEditableCard(
              title: 'Address',
              content: address ?? '',
              icon: Icons.location_on,
              onEdit: () =>
                  showEditDialog('address', address ?? '', context),
            ),
            buildFoodPlannerCard(),
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
              onEdit: () =>
                  showEditDialog('payments', payments ?? '', context),
            ),
          ],
        ),
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
                        icon: const Icon(Icons.edit,
                            size: 18, color: Colors.white70),
                      )
                    ],
                  ),
                  Text(content,
                      style: const TextStyle(color: Colors.white70)),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
