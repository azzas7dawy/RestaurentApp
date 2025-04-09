import 'dart:ui';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:restrant_app/firebase_options.dart';
import 'package:restrant_app/screens/categoriesScreens/categroy_one.dart';
import 'package:restrant_app/screens/categoriesScreens/notify_success.dart';
import 'package:restrant_app/screens/onboarding/onboarding_screen.dart';
import 'package:restrant_app/screens/foodHomeScreen/food_home_screen.dart';
import 'package:restrant_app/screens/splash/splash_screen.dart';

import 'package:restrant_app/utils/colors_utility.dart';
import 'package:restrant_app/utils/widgets/show_bottomsheet.dart';

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
            return MaterialPageRoute(
              builder: (context) => const OnboardingScreen(),
            );
          case FoodHomeScreen.id:
            return MaterialPageRoute(
              builder: (context) => const FoodHomeScreen(),
            );
               case CateringScreen.id:
            return MaterialPageRoute(
              builder: (context) => const CateringScreen(),
            );
            //    case CateringBottomSheet.id:
            // return MaterialPageRoute(
            //   builder: (context) => const CateringBottomSheet(),
            // );
            case OnboardingScreen.id:
            return MaterialPageRoute(
              builder: (context) =>  OnboardingScreen(),
            );
             case OrderConfirmationScreen.id:
            return MaterialPageRoute(
              builder: (context) =>  OrderConfirmationScreen(orderId: 'ID4578',),
            );
          default:
            return MaterialPageRoute(builder: (context) => const SplashPage());
        }
      },
      initialRoute: CateringScreen.id,
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
