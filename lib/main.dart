import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:restrant_app/screens/onboarding/onboarding_screen.dart';
import 'package:restrant_app/screens/register/login_screen.dart';
import 'package:restrant_app/screens/register/signUp_srceen.dart';
import 'package:restrant_app/screens/servicesScreen/services_screen.dart';
import 'package:restrant_app/screens/splash/splash_screen.dart';
import 'package:restrant_app/utils/colors_utility.dart';

void main() => runApp(
  DevicePreview(
    enabled: !kReleaseMode,
    builder: (context) => const MyApp(),
  ),
);

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
        // final dynamic data = settings.arguments;
        switch (routeName) {
          case OnboardingScreen.id:
            return MaterialPageRoute(builder: (context) => const OnboardingScreen());
          case SignupSrceen.id:
            return MaterialPageRoute(builder: (context) =>  SignupSrceen());
          case LoginScreen.id:
            return MaterialPageRoute(builder: (context) =>  LoginScreen());  
          case ServicesScreen.id:
            return MaterialPageRoute(builder: (context) => const ServicesScreen());
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