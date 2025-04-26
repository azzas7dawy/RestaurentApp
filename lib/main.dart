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
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:restrant_app/cubit/AuthLogic/cubit/auth_cubit.dart';
import 'package:restrant_app/cubit/FavoritesLogic/cubit/favorites_cubit.dart';
import 'package:restrant_app/cubit/OrdersLogic/cubit/orders_cubit.dart';
import 'package:restrant_app/cubit/ThemeLogic/cubit/theme_cubit.dart';
import 'package:restrant_app/cubit/ThemeLogic/cubit/theme_state.dart';
import 'package:restrant_app/firebase_options.dart';
import 'package:restrant_app/generated/l10n.dart';
import 'package:restrant_app/screens/aboutUs/about_us.dart';
import 'package:restrant_app/screens/adminDashbord/admin/MenuScreen%20.dart';
import 'package:restrant_app/screens/adminDashbord/admin/admin_dashboard.dart';
import 'package:restrant_app/screens/adminDashbord/admin/admin_orders_screen.dart';
import 'package:restrant_app/screens/adminDashbord/admin/orders_screen.dart';
import 'package:restrant_app/screens/adminDashbord/admin/statistics_screen.dart';
import 'package:restrant_app/screens/adminDashbord/chat.dart';
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
import 'package:restrant_app/screens/settingsScreen/settings_screen.dart';
import 'package:restrant_app/services/pref_service.dart';
import 'package:restrant_app/themes/dark_theme.dart';
import 'package:restrant_app/themes/light_theme.dart';
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
  await dotenv.load(fileName: ".env");

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
          BlocProvider(
            create: (context) => ThemeCubit(),
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
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, authState) {
        return BlocBuilder<ThemeCubit, ThemeState>(
          builder: (context, themeState) {
            return FutureBuilder<Locale>(
              future: _getLocale(context, authState),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return MaterialApp(
                    localizationsDelegates: [
                      S.delegate,
                      GlobalMaterialLocalizations.delegate,
                      GlobalWidgetsLocalizations.delegate,
                      GlobalCupertinoLocalizations.delegate,
                    ],
                    supportedLocales: S.delegate.supportedLocales,
                    scrollBehavior: AppScrollBehavior(),
                    debugShowCheckedModeBanner: false,
                    locale: snapshot.data,
                    builder: DevicePreview.appBuilder,
                    title: 'Flutter Demo',
                    theme: lightTheme,
                    darkTheme: darkTheme,
                    themeMode: themeState.themeMode, // تم التعديل هنا
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
                        case ReservationsplashScreen.id:
                          return MaterialPageRoute(
                            builder: (context) =>
                                const ReservationsplashScreen(),
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
                        case SettignsScreen.id:
                          return MaterialPageRoute(
                            builder: (context) => const SettignsScreen(),
                          );
                        case OrdersScreenn.id:
                          return MaterialPageRoute(
                            builder: (context) => const OrdersScreenn(),
                          );
                        case AdminMenuScreen.id:
                          return MaterialPageRoute(
                            builder: (context) => const AdminMenuScreen(),
                          );
                        case AdminOrdersScreen.id:
                          return MaterialPageRoute(
                            builder: (context) => const AdminOrdersScreen(),
                          );
                        case StatisticsScreen.id:
                          return MaterialPageRoute(
                            builder: (context) => const StatisticsScreen(),
                          );
                        case DashboardHomeScreen.id:
                          return MaterialPageRoute(
                            builder: (context) => DashboardHomeScreen(),
                          );
                        case ChatScreen.id:
                          return MaterialPageRoute(
                            builder: (context) =>
                                ChatScreen(otherUserEmail: data),
                          );
                        case AboutSupportPage.id:
                          return MaterialPageRoute(
                            builder: (context) => AboutSupportPage(),
                          );

                        default:
                          return MaterialPageRoute(
                              builder: (context) => const SplashPage());
                      }
                    },
                    initialRoute: SplashPage.id,
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: ColorsUtility.progressIndictorColor,
                    ),
                  );
                }
              },
            );
          },
        );
      },
    );
  }

  Future<Locale> _getLocale(BuildContext context, AuthState state) async {
    if (state is LanguageChanged) {
      return state.locale;
    } else {
      final authCubit = BlocProvider.of<AuthCubit>(context);
      return await authCubit.getSavedLocale();
    }
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
