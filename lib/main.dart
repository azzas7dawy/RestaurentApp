import 'dart:developer';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:restrant_app/chatAndNotifiction/notifiction.dart';
import 'package:restrant_app/cubit/AuthLogic/cubit/auth_cubit.dart';
import 'package:restrant_app/cubit/FavoritesLogic/cubit/favorites_cubit.dart';
import 'package:restrant_app/cubit/OrdersLogic/cubit/orders_cubit.dart';
import 'package:restrant_app/firebase_options.dart';
import 'package:restrant_app/screens/auth/complete_user_data.dart';
import 'package:restrant_app/screens/auth/forgot_password_screen.dart';
import 'package:restrant_app/screens/auth/login_screen.dart';
import 'package:restrant_app/screens/auth/sign_up_screen.dart';
import 'package:restrant_app/screens/customScreen/custom_screen.dart';
import 'package:restrant_app/screens/favoritesScreen/favorites_screen.dart';
import 'package:restrant_app/screens/homeScreen/home_screen.dart';
import 'package:restrant_app/screens/mealDeatilsScreen/meal_details_screen.dart';
import 'package:restrant_app/screens/menuScreens/category_items_screen.dart';
import 'package:restrant_app/screens/onboarding/onboarding_screen.dart';
import 'package:restrant_app/screens/ordersScreen/orders_screen.dart';
import 'package:restrant_app/screens/paymentScreen/complete_payment_screen.dart';
import 'package:restrant_app/screens/paymentScreen/payment_screen.dart';
import 'package:restrant_app/screens/reserveTableScreen/reserve_table_screen.dart';
import 'package:restrant_app/screens/specialPlatesScreen/special_plates_screen.dart';
import 'package:restrant_app/screens/splash/splash_screen.dart';
import 'package:restrant_app/screens/trackOrdersScreen/track_orders_screen.dart';
import 'package:restrant_app/services/pref_service.dart';
import 'package:restrant_app/utils/colors_utility.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

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
  await dotenv.load(fileName: ".env");
   NotificationSettings settings = await FirebaseMessaging.instance.requestPermission();
  print('Permission: ${settings.authorizationStatus}');

  // خدي FCM Token
  String? token = await FirebaseMessaging.instance.getToken(
    vapidKey: "BKUu1ugjmvRlcjeZdDRBtsatP1FoF4nE49HhYOTX4B40nWbJegaHqNw1jhpTF33TbxvA7c_SboXLGXAEmRAmfzU",
  );
  print("FCM Token: $token");

  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AuthCubit(),
          ),
          BlocProvider(
            create: (context) => OrdersCubit(
              firestore: FirebaseFirestore.instance,
              userId: FirebaseAuth.instance.currentUser?.uid ?? '',
            ),
          ),
          BlocProvider(
            create: (context) => FavoritesCubit(
              firestore: FirebaseFirestore.instance,
              userId: FirebaseAuth.instance.currentUser?.uid ?? '',
            ),
          ),
        ],
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
        appBarTheme: const AppBarTheme(
          backgroundColor: ColorsUtility.mainBackgroundColor,
        ),
        scaffoldBackgroundColor: ColorsUtility.mainBackgroundColor,
        fontFamily: 'Raleway',
        colorScheme: ColorScheme.fromSeed(
            seedColor: ColorsUtility.progressIndictorColor),
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
          case SignUpScreen.id:
            return MaterialPageRoute(
              builder: (context) => const SignUpScreen(),
            );
          case CustomScreen.id:
            return MaterialPageRoute(
              builder: (context) => const CustomScreen(),
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
          case HomeScreen.id:
            return MaterialPageRoute(
              builder: (context) => const HomeScreen(),
            );
          case SpecialPlatesScreen.id:
            return MaterialPageRoute(
              builder: (context) => SpecialPlatesScreen(
                items: data,
              ),
            );
          case MealDetailsScreen.id:
            return MaterialPageRoute(
              builder: (context) => MealDetailsScreen(
                meal: data,
              ),
            );
          case OrdersScreen.id:
            return MaterialPageRoute(
              builder: (context) => const OrdersScreen(),
            );
          case ReserveTableScreen.id:
            return MaterialPageRoute(
              builder: (context) => const ReserveTableScreen(),
            );
          case FavoritesScreen.id:
            return MaterialPageRoute(
              builder: (context) => const FavoritesScreen(),
            );
          case PaymentScreen.id:
            return MaterialPageRoute(
              builder: (context) => PaymentScreen(
                initialTotal: data,
              ),
            );
          case CompletePaymentScreen.id:
            return MaterialPageRoute(
              builder: (context) => CompletePaymentScreen(
                paymentMethod: data,
                totalAmount: data,
                discountAmount: data,
              ),
            );
          case TrackOrdersScreen.id:
            return MaterialPageRoute(
              builder: (context) => const TrackOrdersScreen(),
            );
          case CategoryItemsScreen.id:
            return MaterialPageRoute(
              builder: (context) => CategoryItemsScreen(
                categoryDoc: data,
              ),
            );
          default:
            return MaterialPageRoute(builder: (context) => const SplashPage());
        }
      },
      // initialRoute: SplashPage.id,
      home: NotificationHome(),
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
