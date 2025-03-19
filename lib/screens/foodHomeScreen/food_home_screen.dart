import 'package:flutter/material.dart';
import 'package:restrant_app/screens/foodHomeScreen/service_card.dart';
import 'package:restrant_app/utils/colors_utility.dart';

class FoodHomeScreen extends StatelessWidget {
  const FoodHomeScreen({super.key});

  static const String id = 'FoodHome';

  @override
  Widget build(BuildContext context) {
    final List serviceData = [
      {
        'title': 'ORDER FOOD',
        'imagePath': './assets/images/kerfin7_nea_3142.jpg',
        'color': ColorsUtility.orderFoodColor,
      },
      {
        'title': 'TAKE AWAY',
        'imagePath': './assets/images/6157272.jpg',
        'color': ColorsUtility.takeAwayColor,
      },
      {
        'title': 'RESERVE TABLE',
        'imagePath': './assets/images/38597.jpg',
        'color': ColorsUtility.reserveTableColor,
      },
      {
        'title': 'FOOD PLANNER',
        'imagePath': './assets/images/schedule_calendar_flat_style.jpg',
        'color': ColorsUtility.calenderColor,
      },
      {
        'title': 'CATERING',
        'imagePath': './assets/images/9555977.jpg',
        'color': ColorsUtility.cateringColor,
      },
    ];

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              childAspectRatio: 0.8,
            ),
            itemCount: serviceData.length,
            itemBuilder: (context, index) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ServiceCard(
                    title: serviceData[index]['title'],
                    onPressed: () {
                      if(index == 1){
                        // nav to order food page
                      }else if (index == 2){
                        // nav to take away page
                      }else if(index == 3){
                        // nav to reserve table
                      }else if (index == 4){
                        // nav to food planner
                      }else if (index == 5){
                        // nav to catering
                      }
                    },
                    imagePath: serviceData[index]['imagePath'],
                    color: serviceData[index]['color'],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}


