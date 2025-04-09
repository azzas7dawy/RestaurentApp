import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:restrant_app/utils/colors_utility.dart';
import 'package:restrant_app/widgets/app_elevated_btn_widget.dart';

class MealDetailsScreen extends StatelessWidget {
  const MealDetailsScreen({
    super.key,
    required this.meal,
  });
  final Map<String, dynamic> meal;
  static const String id = 'MealDetailsScreen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          meal['title'] ?? 'Unknown',
          style: const TextStyle(
            color: ColorsUtility.textFieldLabelColor,
          ),
        ),
        iconTheme: const IconThemeData(
          color: ColorsUtility.textFieldLabelColor,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              meal['image'],
              height: 250,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 16),
            Text(
              meal['title'],
              style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: ColorsUtility.takeAwayColor),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Chip(
                  label: Text(
                    meal['category'] ?? '',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: ColorsUtility.progressIndictorColor,
                    ),
                  ),
                  backgroundColor: ColorsUtility.mainBackgroundColor,
                  side: const BorderSide(
                    color: ColorsUtility.progressIndictorColor,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      50,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                if (meal['category_type'] != null &&
                    meal['category_type'].isNotEmpty)
                  Chip(
                    label: Text(
                      meal['category_type'] ?? '',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: ColorsUtility.progressIndictorColor,
                      ),
                    ),
                    backgroundColor: ColorsUtility.mainBackgroundColor,
                    side: const BorderSide(
                      color: ColorsUtility.progressIndictorColor,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        50,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              meal['description'],
              style: const TextStyle(
                fontSize: 16,
                color: ColorsUtility.textFieldLabelColor,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text(
                  'Rating: ',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: ColorsUtility.progressIndictorColor),
                ),
                RatingBar.builder(
                  initialRating: meal['rate']?.toDouble() ?? 0,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemSize: 24.0,
                  itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) => const Icon(
                    Icons.star,
                    color: ColorsUtility.takeAwayColor,
                  ),
                  onRatingUpdate: (rating) {
                    // logic to give rate
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${meal['price']} EGP',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: ColorsUtility.progressIndictorColor,
                  ),
                ),
                Text(
                  meal['is_available'] ? 'Available' : 'Not Available',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: meal['is_available']
                        ? ColorsUtility.successSnackbarColor
                        : ColorsUtility.errorSnackbarColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Center(
              child: AppElevatedBtn(onPressed: () {}, text: 'Add To Orders'),
            ),
          ],
        ),
      ),
    );
  }
}
