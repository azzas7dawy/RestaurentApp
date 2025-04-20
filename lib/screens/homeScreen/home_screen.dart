import 'package:flutter/material.dart';
import 'package:restrant_app/screens/customScreen/custom_screen.dart';
import 'package:restrant_app/screens/homeScreen/widgets/animated_text_widget.dart';
import 'package:restrant_app/screens/homeScreen/widgets/reserve_table_card_widget.dart';
import 'package:restrant_app/screens/homeScreen/widgets/slider_widget.dart';
import 'package:restrant_app/screens/homeScreen/widgets/special_plates_section_widget.dart';
import 'package:restrant_app/widgets/app_main_title_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  static const String id = 'HomeScreen';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          const SliderWidget(),
          const SizedBox(height: 20),
          const AnimatedTextWidget(),
          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: AppMainTitleWidget(
              title: 'Special Plates',
            ),
          ),
          const SpecialPlatesSectionWidget(),
          const SizedBox(height: 20),
          ReserveTableCardWidget(
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const CustomScreen(
                      initialIndex: 3,
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
