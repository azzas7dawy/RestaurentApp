
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class NotificationHome extends StatefulWidget {
  @override
  _NotificationHomeState createState() => _NotificationHomeState();
}

class _NotificationHomeState extends State<NotificationHome> {
  String? token = '';

  @override
  void initState() {
    super.initState();
    _initNotifications();
  }

  void _initNotifications() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission();

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      token = await messaging.getToken();
      print('✅ FCM Token: $token');
    }

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('🔔 Foreground message: ${message.notification?.title}');
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text(message.notification?.title ?? 'No Title'),
          content: Text(message.notification?.body ?? 'No Body'),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Firebase Web Notifications'),
      ),
      body: Center(
        child: SelectableText(
          token ?? "Waiting for token...",
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}