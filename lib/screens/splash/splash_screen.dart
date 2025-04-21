import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restrant_app/cubit/SplashLogic/cubit/splash_cubit.dart';
import 'package:restrant_app/screens/auth/login_screen.dart';
import 'package:restrant_app/screens/customScreen/custom_screen.dart';
import 'package:restrant_app/screens/onboarding/onboarding_screen.dart';
import 'package:restrant_app/utils/colors_utility.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  static const String id = 'Splash';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SplashCubit()..initialize(),
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                BlocBuilder<SplashCubit, SplashState>(
                  builder: (context, state) {
                    double fadeValue = 0.0;
                    double scaleValue = 0.5;

                    if (state is SplashCubitProgress) {
                      fadeValue = state.progress.clamp(0.0, 1.0);
                      scaleValue = 0.5 + (0.5 * state.progress);
                    } else if (state is SplashCubitAnimationComplete ||
                        state is SplashCubitNavigateToHome ||
                        state is SplashCubitNavigateToLogin ||
                        state is SplashCubitNavigateToOnboarding) {
                      fadeValue = 1.0;
                      scaleValue = 1.0;
                    }

                    return Opacity(
                      opacity: fadeValue,
                      child: Transform.scale(
                        scale: scaleValue,
                        child: const Text(
                          'PARAGON',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: ColorsUtility.progressIndictorColor,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 50),
                BlocBuilder<SplashCubit, SplashState>(
                  builder: (context, state) {
                    if (state is SplashCubitAnimationComplete ||
                        state is SplashCubitNavigateToHome ||
                        state is SplashCubitNavigateToLogin ||
                        state is SplashCubitNavigateToOnboarding) {
                      return const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                            ColorsUtility.progressIndictorColor),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
                BlocListener<SplashCubit, SplashState>(
                  listener: (context, state) {
                    if (state is SplashCubitNavigateToHome) {
                      Navigator.pushReplacementNamed(context, CustomScreen.id);
                    } else if (state is SplashCubitNavigateToLogin) {
                      Navigator.pushReplacementNamed(context, LoginScreen.id);
                    } else if (state is SplashCubitNavigateToOnboarding) {
                      Navigator.pushReplacementNamed(
                          context, OnboardingScreen.id);
                    } else if (state is SplashCubitError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.message)),
                      );
                      Navigator.pushReplacementNamed(
                          context, OnboardingScreen.id);
                    }
                  },
                  child: const SizedBox.shrink(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
