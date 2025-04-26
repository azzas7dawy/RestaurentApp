import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:restrant_app/chat/user_chat.dart';
import 'package:url_launcher/url_launcher.dart';


class AboutSupportPage extends StatelessWidget {
  const AboutSupportPage({super.key});
  static const String id = 'AboutSupportPage';

  // 📍 رابط موقع محافظة المنيا على Google Maps
  final String googleMapsUrl = "https://www.google.com/maps/place/Minya,+Menia,+Egypt";

  // 🔗 فتح الخريطة
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
        title: const Text('عن المطعم والدعم', style: TextStyle(color: Colors.white)),
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
              style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Text(
              "مطعم Tasty Bites بيقدملك أشهى وأطيب الأكلات بجودة عالية وخدمة ممتازة. بنهتم براحتك وتجربتك، وكل وجبة بنقدمها بحب ❤️",
              style: TextStyle(color: Colors.white70, fontSize: 15, height: 1.5),
              textAlign: TextAlign.justify,
            ),

            const SizedBox(height: 30),

            GestureDetector(
                  onTap: () => Navigator.push(context,MaterialPageRoute( builder: (context) => ChatScreen(otherUserEmail: FirebaseAuth.instance.currentUser?.email ?? '',)
                  )),
              child: const Text(
                "Ask Admin 💬",
                style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
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
              "📍 موقع المطعم",
              style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
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
                      "المطعم في محافظة المنيا. موقع مميز وسهل الوصول ليه.",
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
