import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:restrant_app/utils/colors_utility.dart';
import 'package:restrant_app/utils/images_utility.dart';

class SliderWidget extends StatelessWidget {
  const SliderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      items: [
        buildBanner(
          ImagesUtility.dessertImage,
          "Delicious Desserts Just for You! Indulge in the Sweetest Treats.",
        ),
        buildBanner(
          ImagesUtility.pizzaImage,
          "Freshly Baked Pizzas with Perfect Toppings! Taste the Flavor in Every Bite.",
        ),
        buildBanner(
          ImagesUtility.burgerImage,
          "Juicy Burgers with a Perfect Blend of Flavors! Savor Every Bite.",
        ),
        buildBanner(
          ImagesUtility.mexicanFoodImage,
          "Spicy and Savory Mexican Delights! Taste the Fiesta in Every Bite.",
        ),
      ],
      options: CarouselOptions(
        height: 180,
        autoPlay: true,
        enlargeCenterPage: true,
        viewportFraction: 0.85,
        autoPlayInterval: const Duration(seconds: 5),
      ),
    );
  }

  Widget buildBanner(String imagePath, String promoText) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      child: Stack(
        alignment: Alignment.bottomLeft,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              imagePath,
              fit: BoxFit.cover,
              width: double.infinity,
              height: 180,
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: const LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Colors.black54,
                  Colors.transparent,
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: 250,
              child: Text(
                promoText,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: ColorsUtility.onboardingColor,
                  shadows: [
                    Shadow(
                      blurRadius: 10,
                      color: ColorsUtility.textFieldFillColor,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
