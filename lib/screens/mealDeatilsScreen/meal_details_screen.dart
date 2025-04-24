import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:restrant_app/cubit/FavoritesLogic/cubit/favorites_cubit.dart';
import 'package:restrant_app/cubit/OrdersLogic/cubit/orders_cubit.dart';
import 'package:restrant_app/generated/l10n.dart';
// import 'package:restrant_app/screens/customScreen/widgets/custom_app_bar.dart';
import 'package:restrant_app/utils/colors_utility.dart';
import 'package:restrant_app/widgets/app_elevated_btn_widget.dart';
import 'package:restrant_app/widgets/app_snackbar.dart';

class MealDetailsScreen extends StatefulWidget {
  const MealDetailsScreen({
    super.key,
    required this.meal,
  });

  final Map<String, dynamic> meal;
  static const String id = 'MealDetailsScreen';

  @override
  State<MealDetailsScreen> createState() => _MealDetailsScreenState();
}

class _MealDetailsScreenState extends State<MealDetailsScreen> {
  double? userRating;
  double? defaultMealRating;

  bool isArabic(BuildContext context) {
    return Localizations.localeOf(context).languageCode == 'ar';
  }

  @override
  void initState() {
    super.initState();
    _loadUserRating();
  }

  Future<void> _loadUserRating() async {
    final userId = FirebaseAuth.instance.currentUser?.uid ?? '';

    final userDoc =
        await FirebaseFirestore.instance.collection('users2').doc(userId).get();
    final ratings = userDoc.data()?['ratings'] as Map<String, dynamic>?;

    if (!mounted) return;

    if (ratings != null && ratings.containsKey(widget.meal['documentId'])) {
      setState(() {
        userRating = (ratings[widget.meal['documentId']] as num).toDouble();
      });
    }

    if (userRating == null && widget.meal['rate'] != null) {
      if (!mounted) return;
      setState(() {
        defaultMealRating = (widget.meal['rate'] as num).toDouble();
      });
    }
  }

  Future<void> _saveUserRating(double rating) async {
    final userId = FirebaseAuth.instance.currentUser?.uid ?? '';
    final docRef = FirebaseFirestore.instance.collection('users2').doc(userId);

    await docRef.set({
      'ratings': {
        widget.meal['documentId']: rating,
      }
    }, SetOptions(merge: true));

    if (!mounted) return;
    setState(() {
      userRating = rating;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final meal = widget.meal;

    final isDark = theme.brightness == Brightness.dark;

    final Color appBarTextColor = isDark
        ? ColorsUtility.takeAwayColor
        : ColorsUtility.progressIndictorColor;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isArabic(context)
              ? meal['title_ar'] ?? meal['title'] ?? 'No Title'
              : meal['title'] ?? 'No Title',
          style: TextStyle(
            color: appBarTextColor,
            fontSize: theme.textTheme.titleLarge?.fontSize,
          ),
        ),
        iconTheme: IconThemeData(
          color: appBarTextColor,
        ),
        backgroundColor: theme.scaffoldBackgroundColor,
        centerTitle: true,
        actions: [
          BlocBuilder<FavoritesCubit, FavoritesState>(
            builder: (context, state) {
              final isFavorite = state is FavoritesLoaded
                  ? state.favorites.any((fav) => fav['title'] == meal['title'])
                  : false;
              return IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Colors.red : theme.colorScheme.primary,
                ),
                onPressed: () {
                  if (isFavorite) {
                    context
                        .read<FavoritesCubit>()
                        .removeFromFavorites(meal['title']);
                    appSnackbar(
                      context,
                      text:
                          '${isArabic(context) ? meal['title_ar'] ?? meal['title'] : meal['title']} ${S.of(context).removedFromFavorites}',
                      backgroundColor: Colors.red,
                    );
                  } else {
                    context.read<FavoritesCubit>().addToFavorites(meal);
                    appSnackbar(
                      context,
                      text:
                          '${isArabic(context) ? meal['title_ar'] ?? meal['title'] : meal['title']} ${S.of(context).addedToFavorites}',
                      backgroundColor: theme.colorScheme.primary,
                    );
                  }
                },
              );
            },
          ),
        ],
      ),
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CachedNetworkImage(
              imageUrl: meal['image'],
              height: 250,
              width: double.infinity,
              fit: BoxFit.cover,
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
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Chip(
                  label: Text(
                    isArabic(context)
                        ? meal['category_ar'] ?? meal['category'] ?? ''
                        : meal['category'] ?? '',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  backgroundColor: theme.scaffoldBackgroundColor,
                  side: BorderSide(
                    color: theme.colorScheme.primary,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              isArabic(context)
                  ? meal['desc_ar'] ?? meal['description']
                  : meal['description'] ?? '',
              style: TextStyle(
                fontSize: 16,
                color: theme.textTheme.bodyMedium?.color,
              ),
            ),
            const SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      S.of(context).rating,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    RatingBar.builder(
                      initialRating: userRating ?? defaultMealRating ?? 0,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemSize: 24.0,
                      itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                      itemBuilder: (context, _) => Icon(
                        Icons.star,
                        color: ColorsUtility.takeAwayColor,
                      ),
                      onRatingUpdate: (rating) {
                        _saveUserRating(rating);
                        appSnackbar(
                          context,
                          text: '${S.of(context).youRatedThisMeal} $rating ',
                          backgroundColor: ColorsUtility.successSnackbarColor,
                        );
                      },
                    ),
                  ],
                ),
                if (userRating != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    '${S.of(context).youRated} ${userRating!.toStringAsFixed(1)}',
                    style: TextStyle(
                      fontSize: 16,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ]
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${meal['price']} ${S.of(context).egp}',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
                Text(
                  meal['is_available']
                      ? S.of(context).available
                      : S.of(context).notAvailableTxt,
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
                        final mealToAdd = {
                          ...meal,
                          'documentId': meal['documentId'],
                          'title': meal['title'] ?? S.of(context).noTitle,
                          'title_ar': meal['title_ar'] ??
                              meal['title'] ??
                              S.of(context).noTitle,
                          'price': meal['price'],
                          'image': meal['image'],
                          'description': meal['description'],
                          'desc_ar': meal['desc_ar'] ?? meal['description'],
                          'category': meal['category'],
                          'category_ar':
                              meal['category_ar'] ?? meal['category'],
                        };
                        await context.read<OrdersCubit>().addMeal(mealToAdd);
                        if (context.mounted) {
                          appSnackbar(
                            context,
                            text:
                                '${isArabic(context) ? mealToAdd['title_ar'] : mealToAdd['title']} ${S.of(context).addedToOrders}',
                            backgroundColor: ColorsUtility.successSnackbarColor,
                          );
                        }
                      }
                    : null,
                text: S.of(context).addToOrdersBtn,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
