import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:restrant_app/screens/adminDashbord/chat.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'package:url_launcher/url_launcher.dart';

class AboutSupportPage extends StatelessWidget {
  const AboutSupportPage({super.key});
  static const String id = 'AboutSupportPage';

  final String googleMapsUrl =
      "https://www.google.com/maps/place/Minya,+Menia,+Egypt";

 
  void _openMap() async {
    final Uri url = Uri.parse(googleMapsUrl);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text('about restaurant',
            style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ✨ نبذة عن المطعم
            const Text(
              " about  Tasty Bites 🍔",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Text(
              'Tasty Bites Restaurant offers you the most delicious and tasty food with high quality and excellent service. We care about your comfort and experience, and we serve every meal with love ❤️',
              style:
                  TextStyle(color: Colors.white70, fontSize: 15, height: 1.5),
              textAlign: TextAlign.justify,
            ),

            const SizedBox(height: 30),

            // 💬 قسم الشات
            GestureDetector(
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ChatScreen(
                            otherUserEmail:
                                FirebaseAuth.instance.currentUser?.email ?? '',
                          ))),
              child: const Text(
                "Ask Admin 💬",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[850],
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Center(
                child: Text(
                  ".and give your feedback\n(you can ask the admin)",
                  style: TextStyle(color: Colors.white70),
                  textAlign: TextAlign.center,
                ),
              ),
            ),

            const SizedBox(height: 30),

            const Text(
              "📍  Location",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[850],
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                children: [
                  const Icon(Icons.location_on, color: Colors.teal, size: 30),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      "our location in Minya, Egypt",
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ),
                  IconButton(
                    onPressed: _openMap,
                    icon: const Icon(Icons.map, color: Colors.teal),
                  )
                ],
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
