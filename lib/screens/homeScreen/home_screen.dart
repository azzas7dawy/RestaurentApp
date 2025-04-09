import 'package:flutter/material.dart';
import 'package:restrant_app/screens/homeScreen/widgets/animated_text_widget.dart';
import 'package:restrant_app/screens/homeScreen/widgets/slider_widget.dart';
import 'package:restrant_app/screens/homeScreen/widgets/special_plates_section_widget.dart';
import 'package:restrant_app/widgets/app_main_title_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  static const String id = 'HomeScreen';

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10),
          SliderWidget(),
          SizedBox(height: 20),
          AnimatedTextWidget(),
          SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: AppMainTitleWidget(
              title: 'Special Plates',
            ),
          ),
          SpecialPlatesSectionWidget(),
        ],
      ),
    );
  }
}
