import 'dart:developer';
import 'dart:ui';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:restrant_app/firebase_options.dart';
import 'package:restrant_app/screens/auth/login_screen.dart';
import 'package:restrant_app/screens/categoriesScreens/categroy_one.dart';
import 'package:restrant_app/screens/onboarding/onboarding_screen.dart';
import 'package:restrant_app/screens/foodHomeScreen/food_home_screen.dart';
import 'package:restrant_app/screens/paymentOptions/checkout.dart';
import 'package:restrant_app/screens/paymentOptions/checkout_page.dart';
import 'package:restrant_app/screens/splash/splash_screen.dart';
import 'package:restrant_app/screens/trackOrder/track_order_screen.dart';
import 'package:restrant_app/utils/colors_utility.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);

  runApp(
    DevicePreview(enabled: !kReleaseMode, builder: (context) => const MyApp()),
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
        appBarTheme: const AppBarTheme(
            backgroundColor: ColorsUtility.mainBackgroundColor),
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
          case LoginScreen.id:
            return MaterialPageRoute(
              builder: (context) => const LoginScreen(),
            );  
          case  OrderTrackingPage.id:
            return MaterialPageRoute(
              builder: (context) =>  OrderTrackingPage(),
            );  
            case CheckoutPage.id:
            return MaterialPageRoute(
              builder: (context) =>  CheckoutPage(),
            );
            
          default:
            return MaterialPageRoute(builder: (context) => const SplashPage());
        }
      },
      // initialRoute: SplashPage.id,
      initialRoute: CheckoutPage.id,
        // initialRoute: CartOrderScreen.id,
        //   initialRoute: OrderTrackingPage.id,
            // initialRoute: CateringScreen.id,
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
