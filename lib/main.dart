import 'dart:developer';
import 'dart:ui';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restrant_app/firebase_options.dart';
import 'package:restrant_app/screens/auth/complete_user_data.dart';
import 'package:restrant_app/screens/auth/forgot_password_screen.dart';
import 'package:restrant_app/screens/auth/logic/cubit/auth_cubit.dart';
import 'package:restrant_app/screens/auth/login_screen.dart';
import 'package:restrant_app/screens/auth/sign_up_screen.dart';
import 'package:restrant_app/screens/home_screen.dart';
import 'package:restrant_app/screens/onboarding/onboarding_screen.dart';
import 'package:restrant_app/screens/foodHomeScreen/food_home_screen.dart';
import 'package:restrant_app/screens/splash/splash_screen.dart';
import 'package:restrant_app/services/pref_service.dart';
import 'package:restrant_app/utils/colors_utility.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PrefService.init();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    log('failed to initialize firebase : $e');
  }

  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => BlocProvider(
        create: (context) => AuthCubit(),
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scrollBehavior: AppScrollBehavior(),
      debugShowCheckedModeBanner: false,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      title: 'Flutter Demo',
      theme: ThemeData(
        scaffoldBackgroundColor: ColorsUtility.mainBackgroundColor,
        fontFamily: 'Raleway',
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      onGenerateRoute: (settings) {
        final String routeName = settings.name ?? '';
        final dynamic data = settings.arguments;
        switch (routeName) {
          case OnboardingScreen.id:
            return MaterialPageRoute(
              builder: (context) => const OnboardingScreen(),
            );
          case FoodHomeScreen.id:
            return MaterialPageRoute(
              builder: (context) => const FoodHomeScreen(),
            );
          case LoginScreen.id:
            return MaterialPageRoute(
              builder: (context) => const LoginScreen(),
            );
          case SignUpScreen.id:
            return MaterialPageRoute(
              builder: (context) => const SignUpScreen(),
            );
          case HomeScreen.id:
            return MaterialPageRoute(
              builder: (context) => const HomeScreen(),
            );
          case CompleteUserDataScreen.id:
            return MaterialPageRoute(
              builder: (context) => CompleteUserDataScreen(
                user: data,
              ),
            );
          case ForgotPasswordScreen.id:
            return MaterialPageRoute(
              builder: (context) => ForgotPasswordScreen(),
            );
          default:
            return MaterialPageRoute(builder: (context) => const SplashPage());
        }
      },
      initialRoute: SplashPage.id,
    );
  }
}

class AppScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
      };
}
