import 'package:flutter/material.dart';
import 'package:restrant_app/screens/auth/sign_up_screen.dart';
import 'package:restrant_app/screens/home_screen.dart';
import 'package:restrant_app/screens/onboarding/onboarding_data.dart';
import 'package:restrant_app/services/pref_service.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  static const String id = 'Onboarding';

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final List onboardingData = [
    {
      'title': 'Plan your weekly menu',
      'description':
          'You can order weekly meals, and we\'ll bring them straight to your door.',
      'image1': 'assets/images/pexels-akbarattamimi-2104699.jpg',
      'image2': 'assets/images/pexels-alteredsnaps-14536809.jpg',
    },
    {
      'title': 'Reserve a table',
      'description':
          'Tired of having to wait? Make a table reservation right away.',
      'image1': 'assets/images/pexels-alteredsnaps-28449692.jpg',
      'image2': 'assets/images/pexels-artofxx-325140257-28593083.jpg',
    },
    {
      'title': 'Place catering Orders',
      'description': 'Place catering orders with us.',
      'image1': 'assets/images/pexels-mikitayo-18252321.jpg',
      'image2': 'assets/images/pexels-sylwester-ficek-154797634-14611857.jpg',
    },
  ];

  final PageController _pageController = PageController();

  void _goToNextPage() {
    if (_pageController.page! < onboardingData.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _navigateBasedOnAuthStatus();
    }
  }

  Future<void> _navigateBasedOnAuthStatus() async {
    await PrefService.setOnboardingSeen(true);

    if (PrefService.isLoggedIn) {
      if (mounted) {
        Navigator.pushReplacementNamed(context, HomeScreen.id);
      }
    } else {
      if (mounted) {
        Navigator.pushReplacementNamed(context, SignUpScreen.id);
      }
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        controller: _pageController,
        itemCount: onboardingData.length,
        itemBuilder: (context, index) {
          final data = onboardingData[index];
          return OnboardingData(
            title: data['title']!,
            description: data['description']!,
            imagePath1: data['image1']!,
            imagePath2: data['image2']!,
            onSkipPressed: () => Navigator.pushNamed(context, SignUpScreen.id),
            onForwardPressed: _goToNextPage,
          );
        },
      ),
    );
  }

  // void onLogin() {
  //   PrefService.isOnboardingSeen = true;
  //   Navigator.pushNamed(context, FoodHomeScreen.id);}
}
