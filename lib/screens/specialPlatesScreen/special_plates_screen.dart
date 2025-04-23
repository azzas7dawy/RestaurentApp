import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restrant_app/cubit/FavoritesLogic/cubit/favorites_cubit.dart';
import 'package:restrant_app/cubit/OrdersLogic/cubit/orders_cubit.dart';
import 'package:restrant_app/generated/l10n.dart';
import 'package:restrant_app/screens/customScreen/widgets/custom_app_bar.dart';
import 'package:restrant_app/screens/mealDeatilsScreen/meal_details_screen.dart';
import 'package:restrant_app/utils/colors_utility.dart';
<<<<<<< HEAD
=======
// import 'package:restrant_app/utils/colors_utility.dart';
>>>>>>> master
import 'package:restrant_app/widgets/app_snackbar.dart';

class SpecialPlatesScreen extends StatelessWidget {
  const SpecialPlatesScreen({super.key, required this.items});
  final List<Map<String, dynamic>> items;
  static const String id = 'SpecialPlatesScreen';

  // bool isArabic() {
  //   return Localizations.localeOf(navigatorKey.currentContext!).languageCode == 'ar';
  // }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final Color appBarTextColor = isDark
        ? ColorsUtility.takeAwayColor
        : ColorsUtility.progressIndictorColor;
    return Scaffold(
      appBar: AppBar(
<<<<<<< HEAD
        title: Text(
          S.of(context).specialPlates,
          style: TextStyle(
            color: ColorsUtility.takeAwayColor,
          ),
        ),
        iconTheme: const IconThemeData(
          color: ColorsUtility.takeAwayColor,
=======
        backgroundColor: theme.scaffoldBackgroundColor,
        title: Text(
          S.of(context).specialPlates,
          style: TextStyle(
            color: appBarTextColor,
            fontSize: theme.textTheme.titleLarge?.fontSize,
          ),
        ),
        iconTheme: IconThemeData(
          color: appBarTextColor,
>>>>>>> master
        ),
        centerTitle: true,
      ),
      backgroundColor: theme.scaffoldBackgroundColor,
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
                color: theme.scaffoldBackgroundColor,
                boxShadow: [
                  BoxShadow(
                    color: theme.shadowColor.withAlpha((0.2 * 255).round()),
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
                    child: CachedNetworkImage(
                      imageUrl: item['image'],
                      height: 180,
                      width: double.infinity,
                      fit: BoxFit.cover,
<<<<<<< HEAD
                      placeholder: (context, url) => const Center(
                        child: CircularProgressIndicator(
                          color: ColorsUtility.progressIndictorColor,
                        ),
                      ),
                      errorWidget: (context, url, error) => const Center(
                        child: Icon(
                          Icons.fastfood,
                          size: 40,
                          color: ColorsUtility.progressIndictorColor,
=======
                      placeholder: (context, url) => Center(
                        child: CircularProgressIndicator(
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      errorWidget: (context, url, error) => Center(
                        child: Icon(
                          Icons.fastfood,
                          size: 40,
                          color: theme.colorScheme.primary,
>>>>>>> master
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      isArabic()
                          ? item['title_ar']
                          : item['title'] ?? 'No Title',
<<<<<<< HEAD
                      style: const TextStyle(
=======
                      style: TextStyle(
>>>>>>> master
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
                      isArabic()
                          ? item['desc_ar']
                          : item['description'] ?? 'No Description',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        color: theme.textTheme.bodyMedium?.color,
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
                          '${item['price']} ${S.of(context).egp}',
<<<<<<< HEAD
                          style: const TextStyle(
                            color: ColorsUtility.progressIndictorColor,
=======
                          style: TextStyle(
                            color: theme.colorScheme.primary,
>>>>>>> master
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
<<<<<<< HEAD
                                      isFavorite
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      color:
                                          ColorsUtility.progressIndictorColor),
=======
                                    isFavorite
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: theme.colorScheme.primary,
                                  ),
>>>>>>> master
                                  onPressed: () {
                                    if (isFavorite) {
                                      context
                                          .read<FavoritesCubit>()
                                          .removeFromFavorites(item['title']);
                                      appSnackbar(
                                        context,
                                        text:
                                            '${isArabic() ? item['title_ar'] : item['title']} ${S.of(context).removedFromFavorites}',
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
                                            '${isArabic() ? item['title_ar'] : item['title']} ${S.of(context).addedToFavorites}',
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
<<<<<<< HEAD
                                    ? ColorsUtility.progressIndictorColor
                                    : ColorsUtility.textFieldLabelColor,
=======
                                    ? theme.colorScheme.primary
                                    : theme.disabledColor,
>>>>>>> master
                              ),
                              onPressed: () {
                                if (item['is_available'] ?? true) {
                                  context.read<OrdersCubit>().addMeal(item);
                                  appSnackbar(
                                    context,
                                    text:
                                        '${isArabic() ? item['title_ar'] : item['title']} ${S.of(context).addedToOrders}',
                                    backgroundColor:
                                        ColorsUtility.successSnackbarColor,
                                  );
                                } else {
                                  appSnackbar(
                                    context,
                                    text:
                                        '${isArabic() ? item['title_ar'] : item['title']} ${S.of(context).notAvailable}',
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
