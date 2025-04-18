import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:restrant_app/utils/colors_utility.dart';

class AnimatedTextWidget extends StatefulWidget {
  const AnimatedTextWidget({super.key});

  @override
  State<AnimatedTextWidget> createState() => _AnimatedTextWidgetState();
}

class _AnimatedTextWidgetState extends State<AnimatedTextWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: AnimatedTextKit(
        animatedTexts: [
          TypewriterAnimatedText(
            'Hi ${FirebaseAuth.instance.currentUser?.displayName?.toUpperCase() ?? 'User'.toUpperCase()}, Ready to order?',
            textStyle: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: ColorsUtility.onboardingColor,
            ),
            speed: const Duration(milliseconds: 80),
          ),
        ],
        totalRepeatCount: 1,
        pause: const Duration(milliseconds: 500),
        displayFullTextOnTap: true,
      ),
    );
  }
}
