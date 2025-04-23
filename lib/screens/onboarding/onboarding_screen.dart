import 'package:flutter/material.dart';
<<<<<<< HEAD

=======
>>>>>>> master
import 'package:restrant_app/generated/l10n.dart';
import 'package:restrant_app/screens/onboarding/onboarding_data.dart';
import 'package:restrant_app/services/pref_service.dart';

import '../../utils/images_utility.dart';
import '../auth/sign_up_screen.dart';
import '../customScreen/custom_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  static const String id = 'Onboarding';

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late List<Map<String, String>> onboardingData;

  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
<<<<<<< HEAD

=======
>>>>>>> master
    onboardingData = [];
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (onboardingData.isEmpty) {
      onboardingData = [
        {
          'title': S.of(context).onboardingTitleOne,
          'description': S.of(context).onboardingDescriptionOne,
          'image1': ImagesUtility.onboardingImage1,
          'image2': ImagesUtility.onboardingImage2,
        },
        {
          'title': S.of(context).onboardingTitleTwo,
          'description': S.of(context).onboardingDescriptionTwo,
          'image1': ImagesUtility.onboardingImage3,
          'image2': ImagesUtility.onboardingImage4,
        },
        {
          'title': S.of(context).onboardingTitleThree,
          'description': S.of(context).onboardingDescriptionThree,
          'image1': ImagesUtility.onboardingImage5,
          'image2': ImagesUtility.onboardingImage6,
        },
      ];

      setState(() {});
    }
  }

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
        Navigator.pushReplacementNamed(context, CustomScreen.id);
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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
}
