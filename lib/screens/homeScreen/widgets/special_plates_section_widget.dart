import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:restrant_app/cubit/FavoritesLogic/cubit/favorites_cubit.dart';
import 'package:restrant_app/cubit/OrdersLogic/cubit/orders_cubit.dart';
import 'package:restrant_app/screens/mealDeatilsScreen/meal_details_screen.dart';
import 'package:restrant_app/screens/specialPlatesScreen/special_plates_screen.dart';
import 'package:restrant_app/utils/colors_utility.dart';
import 'package:restrant_app/widgets/app_snackbar.dart';
import 'package:shimmer/shimmer.dart';

class SpecialPlatesSectionWidget extends StatelessWidget {
  const SpecialPlatesSectionWidget({super.key});

  Future<List<Map<String, dynamic>>> fetchSpecialPlates() async {
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
  }

  Widget _buildShimmerLoading(BuildContext context, double cardWidth) {
    return SizedBox(
      height: 130,
      width: cardWidth,
      child: Shimmer.fromColors(
        baseColor: ColorsUtility.elevatedBtnColor,
        highlightColor: ColorsUtility.textFieldFillColor,
        child: Container(
          decoration: BoxDecoration(
            color: ColorsUtility.elevatedBtnColor,
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final screenHeight = MediaQuery.sizeOf(context).height;
    final cardWidth = screenWidth * 0.4;
    final cardHeight = screenHeight * 0.32;

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
                        baseColor: ColorsUtility.elevatedBtnColor,
                        highlightColor: ColorsUtility.textFieldFillColor,
                        child: Container(
                          height: 16,
                          width: cardWidth * 0.6,
                          color: ColorsUtility.elevatedBtnColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Shimmer.fromColors(
                        baseColor: ColorsUtility.elevatedBtnColor,
                        highlightColor: ColorsUtility.textFieldFillColor,
                        child: Container(
                          height: 14,
                          width: cardWidth * 0.8,
                          color: ColorsUtility.elevatedBtnColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Shimmer.fromColors(
                        baseColor: ColorsUtility.mainBackgroundColor,
                        highlightColor: ColorsUtility.textFieldFillColor,
                        child: Container(
                          height: 14,
                          width: cardWidth * 0.5,
                          color: ColorsUtility.elevatedBtnColor,
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
          return const Center(child: Text('Something went wrong'));
        }

        final items = snapshot.data ?? [];

        if (items.isEmpty) {
          return const Center(child: Text('No Special Plates found'));
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
                          color: ColorsUtility.elevatedBtnColor,
                          boxShadow: [
                            BoxShadow(
                              color:
                                  ColorsUtility.mainBackgroundColor.withAlpha(
                                (0.2 * 255).round(),
                              ),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Text(
                            'See More',
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
                            color: ColorsUtility.elevatedBtnColor,
                            boxShadow: [
                              BoxShadow(
                                color:
                                    ColorsUtility.mainBackgroundColor.withAlpha(
                                  (0.2 * 255).round(),
                                ),
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
                                child: CachedNetworkImage(
                                  imageUrl: item['image'],
                                  height: 130,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) =>
                                      Shimmer.fromColors(
                                    baseColor: Colors.grey[300]!,
                                    highlightColor: Colors.grey[100]!,
                                    child: Container(
                                      height: 130,
                                      width: double.infinity,
                                      color: Colors.white,
                                    ),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      const Center(
                                    child: Icon(
                                      Icons.fastfood,
                                      size: 40,
                                      color:
                                          ColorsUtility.progressIndictorColor,
                                    ),
                                  ),
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
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${item['price']} EGP',
                                      style: const TextStyle(
                                        color:
                                            ColorsUtility.progressIndictorColor,
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
                                              color: ColorsUtility
                                                  .progressIndictorColor),
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
                                        ),
                                        IconButton(
                                          icon: Icon(
                                            Icons.add_circle_outline,
                                            color: item['is_available'] ?? true
                                                ? ColorsUtility
                                                    .progressIndictorColor
                                                : ColorsUtility
                                                    .textFieldLabelColor,
                                          ),
                                          onPressed: () async {
                                            if (item['is_available'] ?? true) {
                                              final mealToAdd = {
                                                ...item,
                                                'documentId':
                                                    item['documentId'],
                                                'title': item['title'],
                                                'price': item['price'],
                                                'image': item['image'],
                                                'description':
                                                    item['description'],
                                                'category': item['category'],
                                              };
                                              await context
                                                  .read<OrdersCubit>()
                                                  .addMeal(mealToAdd);
                                              if (context.mounted) {
                                                appSnackbar(
                                                  context,
                                                  text:
                                                      '${item['title']} added to orders',
                                                  backgroundColor: ColorsUtility
                                                      .successSnackbarColor,
                                                );
                                              }
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
