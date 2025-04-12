import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restrant_app/cubit/FavoritesLogic/cubit/favorites_cubit.dart';
import 'package:restrant_app/cubit/OrdersLogic/cubit/orders_cubit.dart';
import 'package:restrant_app/screens/mealDeatilsScreen/meal_details_screen.dart';
import 'package:restrant_app/utils/colors_utility.dart';
import 'package:restrant_app/widgets/app_snackbar.dart';

class SpecialPlatesScreen extends StatelessWidget {
  const SpecialPlatesScreen({super.key, required this.items});
  final List<Map<String, dynamic>> items;
  static const String id = 'SpecialPlatesScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'All Special Plates',
          style: TextStyle(
            color: ColorsUtility.takeAwayColor,
          ),
        ),
        iconTheme: const IconThemeData(
          color: ColorsUtility.takeAwayColor,
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return GestureDetector(
            onTap: () {
              Navigator.pushNamed(
                context,
                MealDetailsScreen.id,
                arguments: item,
              );
            },
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: ColorsUtility.elevatedBtnColor,
                boxShadow: [
                  BoxShadow(
                    color: ColorsUtility.mainBackgroundColor
                        .withAlpha((0.2 * 255).round()),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(15)),
                    child: Image.network(
                      item['image'],
                      height: 180,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      item['title'],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: ColorsUtility.takeAwayColor,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      item['description'],
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        color: ColorsUtility.textFieldLabelColor,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${item['price']} EGP',
                          style: const TextStyle(
                            color: ColorsUtility.progressIndictorColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          children: [
                            BlocBuilder<FavoritesCubit, FavoritesState>(
                              builder: (context, state) {
                                final isFavorite = state is FavoritesLoaded
                                    ? state.favorites.any(
                                        (fav) => fav['title'] == item['title'])
                                    : false;
                                return IconButton(
                                  icon: Icon(
                                      isFavorite
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      color:
                                          ColorsUtility.progressIndictorColor),
                                  onPressed: () {
                                    if (isFavorite) {
                                      context
                                          .read<FavoritesCubit>()
                                          .removeFromFavorites(item['title']);
                                      appSnackbar(
                                        context,
                                        text:
                                            '${item['title']} removed from favorites',
                                        backgroundColor:
                                            ColorsUtility.successSnackbarColor,
                                      );
                                    } else {
                                      context
                                          .read<FavoritesCubit>()
                                          .addToFavorites(item);
                                      appSnackbar(
                                        context,
                                        text:
                                            '${item['title']} added to favorites',
                                        backgroundColor:
                                            ColorsUtility.successSnackbarColor,
                                      );
                                    }
                                  },
                                );
                              },
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.add_circle_outline,
                                color: item['is_available'] ?? true
                                    ? ColorsUtility.progressIndictorColor
                                    : ColorsUtility.textFieldLabelColor,
                              ),
                              onPressed: () {
                                if (item['is_available'] ?? true) {
                                  context.read<OrdersCubit>().addMeal(item);
                                  appSnackbar(
                                    context,
                                    text: '${item['title']} added to cart',
                                    backgroundColor:
                                        ColorsUtility.successSnackbarColor,
                                  );
                                } else {
                                  appSnackbar(
                                    context,
                                    text:
                                        '${item['title']} is not available for now',
                                    backgroundColor:
                                        ColorsUtility.errorSnackbarColor,
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
