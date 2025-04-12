// widgets/custom_drawer.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restrant_app/cubit/AuthLogic/cubit/auth_cubit.dart';
import 'package:restrant_app/screens/favoritesScreen/favorites_screen.dart';
import 'package:restrant_app/screens/ordersScreen/orders_screen.dart';
import 'package:restrant_app/utils/colors_utility.dart';
import 'package:restrant_app/widgets/app_confirmation_dialog.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: ColorsUtility.onboardingDescriptionColor,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // header
            // Container(
            //   width: double.infinity,
            //   padding: const EdgeInsets.all(16),
            //   child: const Row(
            //     children: [
            //       CircleAvatar(
            //         radius: 30,
            //         backgroundImage: AssetImage('assets/images/user.png'),
            //       ),
            //       SizedBox(width: 16),
            //       Column(
            //         crossAxisAlignment: CrossAxisAlignment.start,
            //         children: [
            //           Text(
            //             "Hello, Enas",
            //             style: TextStyle(
            //               color: ColorsUtility.takeAwayColor,
            //               fontSize: 18,
            //             ),
            //           ),
            //           Text(
            //             "Enas@mail.com",
            //             style: TextStyle(
            //               color: ColorsUtility.takeAwayColor,
            //               fontSize: 14,
            //             ),
            //           ),
            //         ],
            //       ),
            //     ],
            //   ),
            // ),

            // items
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  const Text(
                    'More Options',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: ColorsUtility.takeAwayColor,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ListTile(
                    leading: const Icon(Icons.fastfood,
                        color: ColorsUtility.takeAwayColor),
                    title: const Text("Your Orders",
                        style: TextStyle(color: ColorsUtility.takeAwayColor)),
                    onTap: () => Navigator.pushNamed(
                      context,
                      OrdersScreen.id,
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.favorite_sharp,
                        color: ColorsUtility.takeAwayColor),
                    title: const Text("Your Favorites",
                        style: TextStyle(color: ColorsUtility.takeAwayColor)),
                    onTap: () => Navigator.pushNamed(
                      context,
                      FavoritesScreen.id,
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.info_outline,
                        color: ColorsUtility.takeAwayColor),
                    title: const Text("About / Help",
                        style: TextStyle(color: ColorsUtility.takeAwayColor)),
                    onTap: () => Navigator.pop(context),
                  ),
                  ListTile(
                    leading: const Icon(Icons.logout_outlined,
                        color: ColorsUtility.takeAwayColor),
                    title: const Text(
                      "Log Out",
                      style: TextStyle(color: ColorsUtility.takeAwayColor),
                    ),
                    onTap: () {
                      _showLogoutConfirmation(context);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showLogoutConfirmation(BuildContext context) async {
    await CustomConfirmationDialog.show(
      context: context,
      title: 'Log Out',
      message: 'Are you sure you want to log out?',
      confirmText: 'Yes',
      onConfirm: () {
        context.read<AuthCubit>().signOut(context);
      },
    );
  }
}
