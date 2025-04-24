import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:restrant_app/cubit/FavoritesLogic/cubit/favorites_cubit.dart';
import 'package:restrant_app/cubit/OrdersLogic/cubit/orders_cubit.dart';
import 'package:restrant_app/generated/l10n.dart';
import 'package:restrant_app/screens/mealDeatilsScreen/meal_details_screen.dart';
import 'package:restrant_app/screens/specialPlatesScreen/special_plates_screen.dart';
import 'package:restrant_app/utils/colors_utility.dart';
import 'package:restrant_app/widgets/app_snackbar.dart';
import 'package:shimmer/shimmer.dart';

class SpecialPlatesSectionWidget extends StatelessWidget {
  const SpecialPlatesSectionWidget({super.key});

  bool isArabic(BuildContext context) {
    return Localizations.localeOf(context).languageCode == 'ar';
  }

  Future<List<Map<String, dynamic>>> fetchSpecialPlates() async {
    try {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      final List<String> menuDocs = [
        'beef sandwich',
        'chicken sandwich',
        'desserts',
        'mexican',
        'drinks',
      ];

      List<Map<String, dynamic>> specialItems = [];

      for (String docName in menuDocs) {
        QuerySnapshot snapshot = await firestore
            .collection('menu')
            .doc(docName)
            .collection('items')
            .where('special', isEqualTo: true)
            .get();

        for (var doc in snapshot.docs) {
          var data = doc.data() as Map<String, dynamic>;
          data['documentId'] = doc.id;
          data['category'] = docName;
          specialItems.add(data);
        }
      }
      return specialItems;
    } catch (e) {
      debugPrint('Error fetching special plates: $e');
      return [];
    }
  }

  Widget _buildShimmerLoading(BuildContext context, double cardWidth) {
    final theme = Theme.of(context);
    return SizedBox(
      height: 130,
      width: cardWidth,
      child: Shimmer.fromColors(
        baseColor: theme.cardColor,
        highlightColor: theme.highlightColor,
        child: Container(
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
    );
  }

  Widget _buildImageWidget(String imageUrl, BuildContext context) {
    final theme = Theme.of(context);
    if (imageUrl.isEmpty) {
      return Container(
        height: 130,
        width: double.infinity,
        color: theme.dividerColor,
        child: Icon(
          Icons.fastfood,
          size: 40,
          color: theme.colorScheme.primary,
        ),
      );
    }

    return CachedNetworkImage(
      imageUrl: imageUrl,
      height: 130,
      width: double.infinity,
      fit: BoxFit.cover,
      placeholder: (context, url) => Container(
        color: theme.dividerColor,
      ),
      errorWidget: (context, url, error) => Container(
        color: theme.dividerColor,
        child: Icon(
          Icons.fastfood,
          size: 40,
          color: theme.colorScheme.primary,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.sizeOf(context).width;
    final screenHeight = MediaQuery.sizeOf(context).height;
    final cardWidth = screenWidth * 0.4;
    final cardHeight = screenHeight * 0.32;
    final isDarkTheme = theme.brightness == Brightness.dark;

    return FutureBuilder<List<Map<String, dynamic>>>(
      future: fetchSpecialPlates(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SizedBox(
            height: cardHeight,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 5,
              itemBuilder: (context, index) {
                return Container(
                  width: cardWidth,
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildShimmerLoading(context, cardWidth),
                      const SizedBox(height: 8),
                      Shimmer.fromColors(
                        baseColor: theme.cardColor,
                        highlightColor: theme.highlightColor,
                        child: Container(
                          height: 16,
                          width: cardWidth * 0.6,
                          color: theme.cardColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Shimmer.fromColors(
                        baseColor: theme.cardColor,
                        highlightColor: theme.highlightColor,
                        child: Container(
                          height: 14,
                          width: cardWidth * 0.8,
                          color: theme.cardColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Shimmer.fromColors(
                        baseColor: theme.cardColor,
                        highlightColor: theme.highlightColor,
                        child: Container(
                          height: 14,
                          width: cardWidth * 0.5,
                          color: theme.cardColor,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        }

        if (snapshot.hasError) {
          debugPrint('Error in special plates: ${snapshot.error}');
          return Center(
            child: Text(
              S.of(context).somethingWentWrong,
              style: TextStyle(color: theme.colorScheme.error),
            ),
          );
        }

        final items = snapshot.data ?? [];

        if (items.isEmpty) {
          return Center(
            child: Text(
              S.of(context).noSpecialPlates,
              style: TextStyle(color: theme.colorScheme.secondary),
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            SizedBox(
              height: cardHeight,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: items.length > 4 ? 5 : items.length,
                itemBuilder: (context, index) {
                  if (index == 4 && items.length > 4) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          SpecialPlatesScreen.id,
                          arguments: items,
                        );
                      },
                      child: Container(
                        width: cardWidth,
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: isDarkTheme
                              ? ColorsUtility.elevatedBtnColor
                              : ColorsUtility.lightTextFieldFillColor,
                          boxShadow: [
                            BoxShadow(
                              color: theme.shadowColor
                                  .withAlpha((0.2 * 255).round()),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            S.of(context).seeMore,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: ColorsUtility.takeAwayColor,
                            ),
                          ),
                        ),
                      ),
                    );
                  }

                  final item = items[index];
                  return BlocBuilder<FavoritesCubit, FavoritesState>(
                    builder: (context, state) {
                      final isFavorite = state is FavoritesLoaded
                          ? state.favorites
                              .any((fav) => fav['title'] == item['title'])
                          : false;

                      return GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            MealDetailsScreen.id,
                            arguments: item,
                          );
                        },
                        child: Container(
                          width: cardWidth,
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: isDarkTheme
                                ? ColorsUtility.elevatedBtnColor
                                : ColorsUtility.lightTextFieldFillColor,
                            boxShadow: [
                              BoxShadow(
                                color: theme.shadowColor
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
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(15),
                                ),
                                child: _buildImageWidget(
                                    item['image'] ?? '', context),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  isArabic(context)
                                      ? item['title_ar'] ??
                                          item['title'] ??
                                          'No Title'
                                      : item['title'] ?? 'No Title',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: ColorsUtility.takeAwayColor,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text(
                                  isArabic(context)
                                      ? item['desc_ar'] ??
                                          item['description'] ??
                                          'No Description'
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${item['price'] ?? '0'} ${S.of(context).egp}',
                                      style: TextStyle(
                                        color: theme.colorScheme.primary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        IconButton(
                                          icon: Icon(
                                            isFavorite
                                                ? Icons.favorite
                                                : Icons.favorite_border,
                                            color: theme.colorScheme.primary,
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
                                                    '${isArabic(context) ? item['title_ar'] ?? item['title'] : item['title']} ${S.of(context).removedFromFavorites}',
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
                                                    '${isArabic(context) ? item['title_ar'] ?? item['title'] : item['title']} ${S.of(context).addedToFavorites}',
                                                backgroundColor: ColorsUtility
                                                    .successSnackbarColor,
                                              );
                                            }
                                          },
                                        ),
                                        IconButton(
                                          icon: Icon(
                                            Icons.add_circle_outline,
                                            color: item['is_available'] ?? true
                                                ? theme.colorScheme.primary
                                                : theme.disabledColor,
                                          ),
                                          onPressed: () async {
                                            if (item['is_available'] ?? true) {
                                              final mealToAdd = {
                                                ...item,
                                                'documentId':
                                                    item['documentId'],
                                                'title':
                                                    item['title'] ?? 'No Title',
                                                'title_ar': item['title_ar'] ??
                                                    item['title'] ??
                                                    'No Title',
                                                'price': item['price'],
                                                'image': item['image'],
                                                'description':
                                                    item['description'],
                                                'desc_ar': item['desc_ar'] ??
                                                    item['description'],
                                                'category': item['category'],
                                                'category_ar':
                                                    item['category_ar'] ??
                                                        item['category'],
                                              };
                                              await context
                                                  .read<OrdersCubit>()
                                                  .addMeal(mealToAdd);
                                              if (context.mounted) {
                                                appSnackbar(
                                                  context,
                                                  text:
                                                      '${isArabic(context) ? mealToAdd['title_ar'] : mealToAdd['title']} ${S.of(context).addedToOrders}',
                                                  backgroundColor: ColorsUtility
                                                      .successSnackbarColor,
                                                );
                                              }
                                            } else {
                                              appSnackbar(
                                                context,
                                                text:
                                                    '${isArabic(context) ? item['title_ar'] ?? item['title'] : item['title']} ${S.of(context).notAvailable}',
                                                backgroundColor:
                                                    theme.colorScheme.error,
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
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
