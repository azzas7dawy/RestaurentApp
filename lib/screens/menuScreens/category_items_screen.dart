import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restrant_app/screens/mealDeatilsScreen/meal_details_screen.dart';
import 'package:restrant_app/utils/colors_utility.dart';
import 'package:restrant_app/cubit/FavoritesLogic/cubit/favorites_cubit.dart';
import 'package:restrant_app/cubit/OrdersLogic/cubit/orders_cubit.dart';
import 'package:restrant_app/widgets/app_snackbar.dart';
import 'package:restrant_app/generated/l10n.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class CategoryItemsScreen extends StatelessWidget {
  const CategoryItemsScreen({super.key, required this.categoryDoc});
  final DocumentSnapshot categoryDoc;
  static const String id = 'CategoryItemsScreen';

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _formatCategoryName(categoryDoc.id),
          style: TextStyle(
            color: theme.colorScheme.primary,
            fontSize: theme.textTheme.titleLarge?.fontSize,
          ),
        ),
        iconTheme: IconThemeData(
          color: theme.colorScheme.primary,
        ),
        centerTitle: true,
        backgroundColor: theme.scaffoldBackgroundColor,
      ),
      backgroundColor: theme.scaffoldBackgroundColor,
      body: StreamBuilder<QuerySnapshot>(
        stream: categoryDoc.reference.collection('items').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: CircularProgressIndicator(
              color: theme.colorScheme.primary,
            ));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text(
                S.of(context).noItemInCat,
                style: TextStyle(
                  color: theme.colorScheme.primary,
                ),
              ),
            );
          }

          final List<QueryDocumentSnapshot> items = snapshot.data!.docs;

          return AnimationLimiter(
            child: GridView.builder(
              padding: const EdgeInsets.all(15),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 15,
                crossAxisSpacing: 15,
                childAspectRatio: 0.8,
              ),
              itemCount: items.length,
              itemBuilder: (BuildContext context, int index) {
                final QueryDocumentSnapshot item = items[index];
                return AnimationConfiguration.staggeredGrid(
                  position: index,
                  duration: const Duration(milliseconds: 500),
                  columnCount: 2,
                  child: SlideAnimation(
                    verticalOffset: 50.0,
                    child: FadeInAnimation(
                      child: _buildItemCard(item, context),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildItemCard(QueryDocumentSnapshot item, BuildContext context) {
    final OrdersCubit ordersCubit = BlocProvider.of<OrdersCubit>(context);
    final FavoritesCubit favoritesCubit =
        BlocProvider.of<FavoritesCubit>(context);
    final bool isArabic = Localizations.localeOf(context).languageCode == 'ar';

    Map<String, dynamic> getItemData(Map<String, dynamic> itemData) {
      return {
        'documentId': item.id,
        'title': itemData['title'] ?? itemData['name'] ?? '',
        'title_ar': itemData['title_ar'] ??
            itemData['name_ar'] ??
            itemData['title'] ??
            itemData['name'] ??
            '',
        'image': itemData['image'] ?? '',
        'rate': itemData['rate'] ?? 0.0,
        'price': itemData['price'] ?? 0.0,
        'description': itemData['description'] ?? itemData['desc'] ?? '',
        'desc_ar': itemData['desc_ar'] ??
            itemData['description_ar'] ??
            itemData['description'] ??
            itemData['desc'] ??
            '',
        'category': itemData['category'] ?? '',
        'category_ar': itemData['category_ar'] ?? itemData['category'] ?? '',
        'special': itemData['special'] ?? false,
      };
    }

    final Map<String, dynamic> itemData =
        getItemData(item.data() as Map<String, dynamic>);
    final String itemName = isArabic
        ? (itemData['title_ar']?.isNotEmpty == true
                ? itemData['title_ar']
                : itemData['title']) ??
            S.of(context).noTitle
        : (itemData['title']?.isNotEmpty == true
                ? itemData['title']
                : itemData['name']) ??
            S.of(context).noTitle;
    final String image = itemData['image'];
    final String rate = itemData['rate'].toString();
    final String price = itemData['price'].toString();
    final String description = isArabic
        ? (itemData['desc_ar']?.isNotEmpty == true
                ? itemData['desc_ar']
                : itemData['description']) ??
            ''
        : (itemData['description']?.isNotEmpty == true
            ? itemData['description']
            : '');
    final bool isSpecial = itemData['special'] == true;

    return BlocBuilder<FavoritesCubit, FavoritesState>(
      builder: (BuildContext context, FavoritesState state) {
        final bool isFavorite = state is FavoritesLoaded
            ? state.favorites.any((Map<String, dynamic> favorite) =>
                favorite['documentId'] == item.id)
            : false;

        final ThemeData theme = Theme.of(context);
        final bool isDark = theme.brightness == Brightness.dark;

        return Card(
          color: isDark
              ? ColorsUtility.elevatedBtnColor
              : ColorsUtility.lightMainBackgroundColor,
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              Navigator.pushNamed(
                context,
                MealDetailsScreen.id,
                arguments: itemData,
              );
            },
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
                          imageUrl: image,
                          height: 120,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          placeholder: (BuildContext context, String url) =>
                              const Center(
                            child: CircularProgressIndicator(),
                          ),
                          errorWidget: (BuildContext context, String url,
                                  dynamic error) =>
                              const Center(
                                  child: Icon(Icons.fastfood, size: 40)),
                        ),
                        if (isSpecial)
                          Positioned(
                            top: 8,
                            right: 8,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primary,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                S.of(context).special,
                                style: TextStyle(
                                  color: ColorsUtility.onboardingColor,
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
                        itemName,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: ColorsUtility.errorSnackbarColor),
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
                            rate,
                            style: TextStyle(
                              fontSize: 12,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            '${S.of(context).egp} $price',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                      if (description.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          description,
                          style: const TextStyle(
                            color: ColorsUtility.textFieldLabelColor,
                            fontSize: 12,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.add_circle_outline,
                              color: theme.colorScheme.primary,
                            ),
                            onPressed: () async {
                              await ordersCubit.addMeal(itemData);
                              if (context.mounted) {
                                appSnackbar(
                                  context,
                                  text:
                                      '$itemName ${S.of(context).addedToOrders}',
                                  backgroundColor:
                                      ColorsUtility.successSnackbarColor,
                                );
                              }
                            },
                          ),
                          IconButton(
                            icon: Icon(
                              isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: ColorsUtility.errorSnackbarColor,
                            ),
                            onPressed: () {
                              if (isFavorite) {
                                favoritesCubit.removeFromFavorites(item.id);
                                appSnackbar(
                                  context,
                                  text:
                                      '$itemName ${S.of(context).removedFromFavorites}',
                                  backgroundColor:
                                      ColorsUtility.successSnackbarColor,
                                );
                              } else {
                                favoritesCubit.addToFavorites(itemData);
                                appSnackbar(
                                  context,
                                  text:
                                      '$itemName ${S.of(context).addedToFavorites}',
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
        );
      },
    );
  }

  String _formatCategoryName(String name) {
    return name
        .split(' ')
        .map((String word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }
}
