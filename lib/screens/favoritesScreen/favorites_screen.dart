import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:restrant_app/cubit/FavoritesLogic/cubit/favorites_cubit.dart';
import 'package:restrant_app/cubit/OrdersLogic/cubit/orders_cubit.dart';
import 'package:restrant_app/generated/l10n.dart';
import 'package:restrant_app/screens/customScreen/custom_screen.dart';
import 'package:restrant_app/screens/mealDeatilsScreen/meal_details_screen.dart';
import 'package:restrant_app/utils/colors_utility.dart';
import 'package:restrant_app/widgets/app_snackbar.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class FavoritesScreen extends StatelessWidget {
  static const String id = 'FavoritesScreen';

  const FavoritesScreen({super.key});

  bool isArabic(BuildContext context) {
    return Localizations.localeOf(context).languageCode == 'ar';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkTheme = theme.brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          S.of(context).yourFavorites,
          style: TextStyle(
            color: theme.colorScheme.primary,
          ),
        ),
        iconTheme: IconThemeData(
          color: theme.colorScheme.primary,
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
        centerTitle: true,
        backgroundColor: theme.scaffoldBackgroundColor,
      ),
      backgroundColor: theme.scaffoldBackgroundColor,
      body: BlocBuilder<FavoritesCubit, FavoritesState>(
        builder: (BuildContext context, FavoritesState state) {
          if (state is FavoritesLoading) {
            return Center(
              child: CircularProgressIndicator(
                color: theme.colorScheme.primary,
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
            final List<Map<String, dynamic>> favorites = state.favorites;

            if (favorites.isEmpty) {
              return AnimationConfiguration.synchronized(
                duration: const Duration(milliseconds: 300),
                child: SlideAnimation(
                  verticalOffset: 50.0,
                  child: FadeInAnimation(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.favorite_border_rounded,
                            size: 64,
                            color:
                                ColorsUtility.errorSnackbarColor.withAlpha(77),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            S.of(context).noFav,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            S.of(context).favTxt,
                            style: TextStyle(
                              fontSize: 14,
                              color: ColorsUtility.textFieldLabelColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }

            return AnimationLimiter(
              child: ListView.builder(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: favorites.length,
                itemBuilder: (BuildContext context, int index) {
                  final Map<String, dynamic> item = favorites[index];
                  final String itemTitle = isArabic(context)
                      ? item['title_ar'] ??
                          item['title'] ??
                          S.of(context).noTitle
                      : item['title'] ?? item['name'] ?? S.of(context).noTitle;
                  final String itemDescription = isArabic(context)
                      ? item['desc_ar'] ?? item['description'] ?? ''
                      : item['description'] ?? '';
                  final String itemImage = item['image'] ?? '';

                  return AnimationConfiguration.staggeredList(
                    position: index,
                    duration: const Duration(milliseconds: 375),
                    child: SlideAnimation(
                      verticalOffset: 50.0,
                      child: FadeInAnimation(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              MealDetailsScreen.id,
                              arguments: item,
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: isDarkTheme
                                    ? ColorsUtility.elevatedBtnColor
                                    : ColorsUtility.lightTextFieldFillColor,
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: const BorderRadius.horizontal(
                                      left: Radius.circular(16),
                                    ),
                                    child: CachedNetworkImage(
                                      imageUrl: itemImage,
                                      width: 120,
                                      height: 150,
                                      fit: BoxFit.cover,
                                      placeholder:
                                          (BuildContext context, String url) =>
                                              Container(
                                        color:
                                            ColorsUtility.mainBackgroundColor,
                                        child: const Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                      ),
                                      errorWidget: (BuildContext context,
                                              String url, dynamic error) =>
                                          Container(
                                        color:
                                            ColorsUtility.mainBackgroundColor,
                                        child: const Icon(
                                          Icons.fastfood,
                                          size: 40,
                                          color: ColorsUtility.onboardingColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(12),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  itemTitle,
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: ColorsUtility
                                                        .errorSnackbarColor,
                                                  ),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              BlocBuilder<FavoritesCubit,
                                                  FavoritesState>(
                                                builder: (BuildContext context,
                                                    FavoritesState state) {
                                                  final bool isFavorite = state
                                                          is FavoritesLoaded
                                                      ? state.favorites.any((Map<
                                                                  String,
                                                                  dynamic>
                                                              favorite) =>
                                                          favorite[
                                                              'documentId'] ==
                                                          item['documentId'])
                                                      : false;
                                                  return IconButton(
                                                    icon: Icon(
                                                      isFavorite
                                                          ? Icons.favorite
                                                          : Icons
                                                              .favorite_border,
                                                      color: ColorsUtility
                                                          .errorSnackbarColor,
                                                    ),
                                                    onPressed: () {
                                                      if (isFavorite) {
                                                        context
                                                            .read<
                                                                FavoritesCubit>()
                                                            .removeFromFavorites(
                                                                item[
                                                                    'documentId']);
                                                        appSnackbar(
                                                          context,
                                                          text:
                                                              '$itemTitle ${S.of(context).removedFromFavorites}',
                                                          backgroundColor:
                                                              ColorsUtility
                                                                  .successSnackbarColor,
                                                        );
                                                      } else {
                                                        context
                                                            .read<
                                                                FavoritesCubit>()
                                                            .addToFavorites(
                                                                item);
                                                        appSnackbar(
                                                          context,
                                                          text:
                                                              '$itemTitle ${S.of(context).addedToFavorites}',
                                                          backgroundColor:
                                                              ColorsUtility
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
                                          if (itemDescription.isNotEmpty)
                                            Text(
                                              itemDescription,
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: ColorsUtility
                                                    .textFieldLabelColor
                                                    .withAlpha(204),
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
                                                '${item['price']} ${S.of(context).egp}',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color:
                                                      theme.colorScheme.primary,
                                                ),
                                              ),
                                              IconButton(
                                                icon: Icon(
                                                  Icons
                                                      .add_circle_outline_rounded,
                                                  color:
                                                      theme.colorScheme.primary,
                                                ),
                                                onPressed: () {
                                                  context
                                                      .read<OrdersCubit>()
                                                      .addMeal(item);
                                                  appSnackbar(
                                                    context,
                                                    text:
                                                        '$itemTitle ${S.of(context).addedToOrders}',
                                                    backgroundColor: ColorsUtility
                                                        .successSnackbarColor,
                                                  );
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
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
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
