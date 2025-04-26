import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restrant_app/screens/mealDeatilsScreen/meal_details_screen.dart';
import 'package:restrant_app/utils/colors_utility.dart';
import 'package:restrant_app/cubit/FavoritesLogic/cubit/favorites_cubit.dart';
import 'package:restrant_app/cubit/OrdersLogic/cubit/orders_cubit.dart';
import 'package:restrant_app/widgets/app_snackbar.dart';

class CategoryItemsScreen extends StatelessWidget {
  const CategoryItemsScreen({super.key, required this.categoryDoc, required String categoryId});
  final DocumentSnapshot categoryDoc;
  static const String id = 'CategoryItemsScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _formatCategoryName(categoryDoc.id),
          style: const TextStyle(
            color: ColorsUtility.takeAwayColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(
          color: ColorsUtility.takeAwayColor,
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: categoryDoc.reference.collection('items').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(
              color: ColorsUtility.progressIndictorColor,
            ));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                'No items available in this category',
                style: TextStyle(
                  color: ColorsUtility.progressIndictorColor,
                ),
              ),
            );
          }

          var items = snapshot.data!.docs;

          return GridView.builder(
            padding: const EdgeInsets.all(15),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 15,
              crossAxisSpacing: 15,
              childAspectRatio: 0.8,
            ),
            itemCount: items.length,
            itemBuilder: (context, index) {
              var item = items[index];
              return _buildItemCard(item, context);
            },
          );
        },
      ),
    );
  }

  Widget _buildItemCard(QueryDocumentSnapshot item, BuildContext context) {
    final ordersCubit = BlocProvider.of<OrdersCubit>(context);
    final favoritesCubit = BlocProvider.of<FavoritesCubit>(context);
    bool isAvailable = item['is_available'] ?? false;

    return BlocBuilder<FavoritesCubit, FavoritesState>(
      builder: (context, state) {
        final isFavorite = state is FavoritesLoaded
            ? state.favorites.any((fav) => fav['title'] == item['title'])
            : false;

        return Card(
          color: ColorsUtility.elevatedBtnColor,
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              // if (!isAvailable) return;
              Navigator.pushNamed(
                context,
                MealDetailsScreen.id,
                arguments: item.data() as Map<String, dynamic>,
              );
            },
            child: Opacity(
              opacity: isAvailable ? 1.0 : 0.6,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(12)),
                      child: Stack(
                        children: [
                          CachedNetworkImage(
                            imageUrl: item['image'],
                            height: 120,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            placeholder: (context, url) => const Center(
                              child: CircularProgressIndicator(),
                            ),
                            errorWidget: (context, url, error) => const Center(
                                child: Icon(Icons.fastfood, size: 40)),
                          ),
                          if (item['special'] == true)
                            Positioned(
                              top: 8,
                              right: 8,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: ColorsUtility.takeAwayColor,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Text(
                                  'SPECIAL',
                                  style: TextStyle(
                                    color: ColorsUtility.onboardingColor,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          if (!isAvailable)
                            Positioned(
                              top: 8,
                              left: 8,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.red.shade700,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Text(
                                  'NOT AVAILABLE',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['title'],
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: ColorsUtility.takeAwayColor),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(
                              Icons.star,
                              color: ColorsUtility.takeAwayColor,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              item['rate'].toString(),
                              style: const TextStyle(
                                fontSize: 12,
                                color: ColorsUtility.progressIndictorColor,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              'EGP ${item['price']}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: ColorsUtility.progressIndictorColor,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item['description'],
                          style: const TextStyle(
                            color: ColorsUtility.textFieldLabelColor,
                            fontSize: 12,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.add_circle_outline,
                                color: isAvailable
                                    ? ColorsUtility.progressIndictorColor
                                    : ColorsUtility.textFieldLabelColor,
                              ),
                              onPressed: () async {
                                if (isAvailable) {
                                  final mealToAdd = {
                                    ...item.data() as Map<String, dynamic>,
                                    'documentId': item.id,
                                  };
                                  await ordersCubit.addMeal(mealToAdd);
                                  if (context.mounted) {
                                    appSnackbar(
                                      context,
                                      text: '${item['title']} added to orders',
                                      backgroundColor:
                                          ColorsUtility.successSnackbarColor,
                                    );
                                  }
                                } else {
                                  appSnackbar(
                                    context,
                                    text: '${item['title']} is not available',
                                    backgroundColor:
                                        ColorsUtility.errorSnackbarColor,
                                  );
                                }
                              },
                            ),
                            IconButton(
                              icon: Icon(
                                isFavorite
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: ColorsUtility.progressIndictorColor,
                              ),
                              onPressed: () {
                                final itemData =
                                    item.data() as Map<String, dynamic>;
                                if (isFavorite) {
                                  favoritesCubit
                                      .removeFromFavorites(item['title']);
                                  appSnackbar(
                                    context,
                                    text:
                                        '${item['title']} removed from favorites',
                                    backgroundColor:
                                        ColorsUtility.successSnackbarColor,
                                  );
                                } else {
                                  favoritesCubit.addToFavorites(itemData);
                                  appSnackbar(
                                    context,
                                    text: '${item['title']} added to favorites',
                                    backgroundColor:
                                        ColorsUtility.successSnackbarColor,
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
          ),
        );
      },
    );
  }

  String _formatCategoryName(String name) {
    return name
        .split(' ')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }
}
