// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';
import 'package:restrant_app/screens/ReservationPages/widgets/city_restrant_bottomsheet.dart';
import 'package:restrant_app/screens/categoriesScreens/Catering_bottom_sheet.dart';
import 'package:restrant_app/utils/colors_utility.dart';
import 'package:restrant_app/utils/widgets/show_bottomsheet.dart';

class ReservationsplashScreen extends StatelessWidget {
  static const String id = 'catering_screen';
  const ReservationsplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsUtility.mainBackgroundColor,
      body: Stack(
        children: [
          // الخلفية
          Positioned.fill(
            child: Image.asset(
              'assets/images/category1.png',
            ),
          ),


          Positioned(
            top: 10,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                    IconButton(
                      icon: Icon(Icons.arrow_back_ios_new, color: const Color.fromARGB(255, 120, 113, 113), size: 30),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),

                    IconButton(
                      icon: Icon(Icons.notifications_active_rounded, color: Colors.white, size: 25),
                      onPressed: () {

                      },
                    ),
                  ],
                ),
              ),
            ),
          ),


          Positioned.fill(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Reserve Table',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Reserve a table at Paragon right now',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16),
                  GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                        ),
                        builder: (_) => RestaurantBottomSheet(),
                      );
                    },
                    child: const Column(
                      children: [
                        Icon(Icons.keyboard_double_arrow_down_rounded,
                            size: 32, color: Colors.white),
                        Icon(Icons.keyboard_double_arrow_down_rounded,
                            size: 32, color: Colors.white),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
