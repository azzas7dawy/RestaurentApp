import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restrant_app/screens/onboarding/onboarding_screen.dart';
import 'package:restrant_app/screens/splash/logic/cubit/splash_cubit.dart';
import 'package:restrant_app/utils/colors_utility.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  static const String id = 'Splash';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SplashCubit()..initialize(),
      child: Scaffold(
        // backgroundColor: ColorsUtility.mainBackgroundColor,
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
                    } else if (state is SplashCubitAnimationComplete || state is SplashCubitNavigateToHome) {
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
                    if (state is SplashCubitAnimationComplete || state is SplashCubitNavigateToHome) {
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
                      Navigator.pushReplacementNamed(context, OnboardingScreen.id);
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