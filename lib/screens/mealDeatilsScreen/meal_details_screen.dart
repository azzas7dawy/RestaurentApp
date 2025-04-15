import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:restrant_app/cubit/FavoritesLogic/cubit/favorites_cubit.dart';
import 'package:restrant_app/screens/ordersScreen/orders_screen.dart';
import 'package:restrant_app/utils/colors_utility.dart';
import 'package:restrant_app/widgets/app_elevated_btn_widget.dart';
import 'package:restrant_app/cubit/OrdersLogic/cubit/orders_cubit.dart';
import 'package:restrant_app/widgets/app_snackbar.dart';

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
            color: ColorsUtility.takeAwayColor,
          ),
        ),
        iconTheme: const IconThemeData(
          color: ColorsUtility.takeAwayColor,
        ),
        actions: [
          BlocBuilder<FavoritesCubit, FavoritesState>(
            builder: (context, state) {
              final isFavorite = state is FavoritesLoaded
                  ? state.favorites.any((fav) => fav['title'] == meal['title'])
                  : false;
              return IconButton(
                icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: ColorsUtility.progressIndictorColor),
                onPressed: () {
                  if (isFavorite) {
                    context
                        .read<FavoritesCubit>()
                        .removeFromFavorites(meal['title']);
                    appSnackbar(
                      context,
                      text: '${meal['title']} removed from favorites',
                      backgroundColor: ColorsUtility.successSnackbarColor,
                    );
                  } else {
                    context.read<FavoritesCubit>().addToFavorites(meal);
                    appSnackbar(
                      context,
                      text: '${meal['title']} added to favorites',
                      backgroundColor: ColorsUtility.successSnackbarColor,
                    );
                  }
                },
              );
            },
          ),
        ],
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
                    borderRadius: BorderRadius.circular(50),
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
                      borderRadius: BorderRadius.circular(50),
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
                    color: ColorsUtility.progressIndictorColor,
                  ),
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
              child: AppElevatedBtn(
                onPressed: meal['is_available']
                    ? () async {
                        if (meal['is_available'] ?? true) {
                          final mealToAdd = {
                            ...meal,
                            'documentId': meal['documentId'],
                            'title': meal['title'],
                            'price': meal['price'],
                            'image': meal['image'],
                            'description': meal['description'],
                            'category': meal['category'],
                          };
                          await context.read<OrdersCubit>().addMeal(mealToAdd);
                          if (context.mounted) {
                            appSnackbar(
                              context,
                              text: '${meal['title']} added to cart',
                              backgroundColor:
                                  ColorsUtility.successSnackbarColor,
                            );
                            Navigator.pushNamed(
                              context,
                              OrdersScreen.id,
                            );
                          }
                        } else {
                          appSnackbar(
                            context,
                            text: '${meal['title']} is not available for now',
                            backgroundColor: ColorsUtility.errorSnackbarColor,
                          );
                        }
                      }
                    : null,
                text: 'Add To Orders',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
