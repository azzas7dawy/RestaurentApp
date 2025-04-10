// widgets/custom_drawer.dart
import 'package:flutter/material.dart';
import 'package:restrant_app/screens/ordersScreen/orders_screen.dart';
import 'package:restrant_app/utils/colors_utility.dart';

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
            // Header
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

            // Items
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
                    leading: const Icon(Icons.info_outline,
                        color: ColorsUtility.takeAwayColor),
                    title: const Text("About / Help",
                        style: TextStyle(color: ColorsUtility.takeAwayColor)),
                    onTap: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
