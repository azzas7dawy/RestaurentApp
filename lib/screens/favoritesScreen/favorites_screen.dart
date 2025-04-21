import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restrant_app/cubit/FavoritesLogic/cubit/favorites_cubit.dart';
import 'package:restrant_app/cubit/OrdersLogic/cubit/orders_cubit.dart';
import 'package:restrant_app/screens/customScreen/custom_screen.dart';
import 'package:restrant_app/utils/colors_utility.dart';
import 'package:restrant_app/widgets/app_snackbar.dart';

class FavoritesScreen extends StatelessWidget {
  static const String id = 'FavoritesScreen';

  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Your Favorites',
          style: TextStyle(
            color: ColorsUtility.takeAwayColor,
          ),
        ),
        iconTheme: const IconThemeData(
          color: ColorsUtility.takeAwayColor,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacementNamed(
              context,
              CustomScreen.id,
            );
          },
        ),
      ),
      body: BlocBuilder<FavoritesCubit, FavoritesState>(
        builder: (context, state) {
          if (state is FavoritesLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: ColorsUtility.progressIndictorColor,
              ),
            );
          }

          if (state is FavoritesError) {
            return Center(
              child: Text(
                state.errorMessage,
                style: const TextStyle(
                  color: ColorsUtility.errorSnackbarColor,
                  fontSize: 16,
                ),
              ),
            );
          }

          if (state is FavoritesLoaded) {
            final favorites = state.favorites;

            if (favorites.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.favorite_border_rounded,
                      size: 64,
                      color: ColorsUtility.progressIndictorColor.withAlpha(77),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'No favorites yet',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: ColorsUtility.takeAwayColor.withAlpha(178),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Tap the heart icon to add favorites',
                      style: TextStyle(
                        fontSize: 14,
                        color: ColorsUtility.textFieldLabelColor.withAlpha(128),
                      ),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final item = favorites[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: ColorsUtility.elevatedBtnColor,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.horizontal(
                            left: Radius.circular(16),
                          ),
                          child: Image.network(
                            item['image'],
                            width: 120,
                            height: 150,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
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
                                    BlocBuilder<FavoritesCubit, FavoritesState>(
                                      builder: (context, state) {
                                        final isFavorite = state
                                                is FavoritesLoaded
                                            ? state.favorites.any((fav) =>
                                                fav['title'] == item['title'])
                                            : false;
                                        return IconButton(
                                          icon: Icon(
                                            isFavorite
                                                ? Icons.favorite
                                                : Icons.favorite_border,
                                            color: ColorsUtility
                                                .progressIndictorColor,
                                          ),
                                          onPressed: () {
                                            if (isFavorite) {
                                              context
                                                  .read<FavoritesCubit>()
                                                  .removeFromFavorites(
                                                      item['title']);
                                              appSnackbar(
                                                context,
                                                text:
                                                    '${item['title']} removed from favorites',
                                                backgroundColor: ColorsUtility
                                                    .successSnackbarColor,
                                              );
                                            } else {
                                              context
                                                  .read<FavoritesCubit>()
                                                  .addToFavorites(item);
                                              appSnackbar(
                                                context,
                                                text:
                                                    '${item['title']} added to favorites',
                                                backgroundColor: ColorsUtility
                                                    .successSnackbarColor,
                                              );
                                            }
                                          },
                                        );
                                      },
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  item['description'],
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: ColorsUtility.textFieldLabelColor
                                        .withAlpha(
                                      204,
                                    ),
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${item['price']} EGP',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color:
                                            ColorsUtility.progressIndictorColor,
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        Icons.add_circle_outline_rounded,
                                        color: item['is_available'] ?? true
                                            ? ColorsUtility
                                                .progressIndictorColor
                                            : ColorsUtility.textFieldLabelColor,
                                      ),
                                      onPressed: () {
                                        if (item['is_available'] ?? true) {
                                          context
                                              .read<OrdersCubit>()
                                              .addMeal(item);
                                          appSnackbar(
                                            context,
                                            text:
                                                '${item['title']} added to cart',
                                            backgroundColor: ColorsUtility
                                                .successSnackbarColor,
                                          );
                                        } else {
                                          appSnackbar(
                                            context,
                                            text:
                                                '${item['title']} is not available for now',
                                            backgroundColor: ColorsUtility
                                                .errorSnackbarColor,
                                          );
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }

          return const Center(
            child: Text('Loading...'),
          );
        },
      ),
    );
  }
}
