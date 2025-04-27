import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:restrant_app/cubit/FavoritesLogic/cubit/favorites_cubit.dart';
import 'package:restrant_app/cubit/OrdersLogic/cubit/orders_cubit.dart';
import 'package:restrant_app/generated/l10n.dart';
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

  Map<String, dynamic> _getMealData() {
    final Map<String, dynamic> meal = widget.meal;
    return {
      'documentId': meal['documentId'] ?? '',
      'title': meal['title'] ?? '',
      'title_ar': meal['title_ar'] ?? meal['title'] ?? '',
      'name': meal['name'] ?? meal['title'] ?? '',
      'name_ar': meal['name_ar'] ??
          meal['title_ar'] ??
          meal['name'] ??
          meal['title'] ??
          '',
      'image': meal['image'] ?? '',
      'rate': meal['rate'] ?? 0.0,
      'price': meal['price'] ?? 0.0,
      'description': meal['description'] ?? meal['desc'] ?? '',
      'desc_ar': meal['desc_ar'] ??
          meal['description_ar'] ??
          meal['description'] ??
          meal['desc'] ??
          '',
      'category': meal['category'] ?? '',
      'category_ar': meal['category_ar'] ?? meal['category'] ?? '',
      'special': meal['special'] ?? false,
    };
  }

  String _getMealName(BuildContext context) {
    final Map<String, dynamic> meal = _getMealData();
    if (isArabic(context)) {
      return meal['title_ar']?.isNotEmpty == true
          ? meal['title_ar']
          : meal['name_ar']?.isNotEmpty == true
              ? meal['name_ar']
              : meal['title']?.isNotEmpty == true
                  ? meal['title']
                  : meal['name'] ?? S.of(context).noTitle;
    } else {
      return meal['title']?.isNotEmpty == true
          ? meal['title']
          : meal['name'] ?? S.of(context).noTitle;
    }
  }

  String _getDescription(BuildContext context) {
    final Map<String, dynamic> meal = _getMealData();
    if (isArabic(context)) {
      return meal['desc_ar']?.isNotEmpty == true
          ? meal['desc_ar']
          : meal['description_ar']?.isNotEmpty == true
              ? meal['description_ar']
              : meal['description']?.isNotEmpty == true
                  ? meal['description']
                  : meal['desc'] ?? '';
    } else {
      return meal['description']?.isNotEmpty == true
          ? meal['description']
          : meal['desc'] ?? '';
    }
  }

  @override
  void initState() {
    super.initState();
    _loadUserRating();
  }

  Future<void> _loadUserRating() async {
    try {
      final String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
      final Map<String, dynamic> meal = _getMealData();

      final DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users2')
          .doc(userId)
          .get();

      if (userDoc.exists) {
        final Map<String, dynamic>? data =
            userDoc.data() as Map<String, dynamic>?;
        if (data != null && data.containsKey('ratings')) {
          final Map<String, dynamic> ratings =
              data['ratings'] as Map<String, dynamic>;
          if (ratings.containsKey(meal['documentId'])) {
            if (!mounted) return;
            setState(() {
              userRating = (ratings[meal['documentId']] as num).toDouble();
            });
          }
        }
      }

      if (userRating == null && meal['rate'] != null) {
        if (!mounted) return;
        setState(() {
          defaultMealRating = (meal['rate'] as num).toDouble();
        });
      }
    } catch (e) {
      debugPrint('Error loading user rating: $e');
    }
  }

  Future<void> _saveUserRating(double rating) async {
    try {
      final String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
      final Map<String, dynamic> meal = _getMealData();
      final DocumentReference docRef =
          FirebaseFirestore.instance.collection('users2').doc(userId);

      await docRef.set({
        'ratings': {
          meal['documentId']: rating,
        }
      }, SetOptions(merge: true));

      if (!mounted) return;
      setState(() {
        userRating = rating;
      });
    } catch (e) {
      debugPrint('Error saving rating: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Map<String, dynamic> meal = _getMealData();
    final bool isDark = theme.brightness == Brightness.dark;
    final Color appBarTextColor = isDark
        ? ColorsUtility.takeAwayColor
        : ColorsUtility.progressIndictorColor;
    final String description = _getDescription(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _getMealName(context),
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
              final bool isFavorite = state is FavoritesLoaded
                  ? state.favorites.any((Map<String, dynamic> favorite) =>
                      favorite['documentId'] == meal['documentId'])
                  : false;
              return IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite
                      ? ColorsUtility.progressIndictorColor
                      : theme.colorScheme.primary,
                ),
                onPressed: () {
                  if (isFavorite) {
                    context
                        .read<FavoritesCubit>()
                        .removeFromFavorites(meal['documentId']);
                    appSnackbar(
                      context,
                      text:
                          '${_getMealName(context)} ${S.of(context).removedFromFavorites}',
                      backgroundColor: ColorsUtility.successSnackbarColor,
                    );
                  } else {
                    context.read<FavoritesCubit>().addToFavorites(meal);
                    appSnackbar(
                      context,
                      text:
                          '${_getMealName(context)} ${S.of(context).addedToFavorites}',
                      backgroundColor: ColorsUtility.successSnackbarColor,
                    );
                  }
                },
              );
            },
          ),
        ],
      ),
      backgroundColor: theme.scaffoldBackgroundColor,
      body: AnimationLimiter(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: AnimationConfiguration.staggeredList(
            position: 0,
            duration: const Duration(milliseconds: 500),
            child: SlideAnimation(
              verticalOffset: 50.0,
              child: FadeInAnimation(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AnimationConfiguration.staggeredList(
                      position: 1,
                      duration: const Duration(milliseconds: 500),
                      child: SlideAnimation(
                        verticalOffset: 50.0,
                        child: FadeInAnimation(
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              maxHeight:
                                  MediaQuery.of(context).size.height * 0.4,
                            ),
                            child: CachedNetworkImage(
                              imageUrl: meal['image'],
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
                          ),
                        ),
                      ),
                    ),
                    if (description.isNotEmpty) ...[
                      AnimationConfiguration.staggeredList(
                        position: 2,
                        duration: const Duration(milliseconds: 500),
                        child: SlideAnimation(
                          verticalOffset: 50.0,
                          child: FadeInAnimation(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                description,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: theme.textTheme.bodyMedium?.color,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                    AnimationConfiguration.staggeredList(
                      position: 3,
                      duration: const Duration(milliseconds: 500),
                      child: SlideAnimation(
                        verticalOffset: 50.0,
                        child: FadeInAnimation(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 16),
                            child: Column(
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
                                    const SizedBox(width: 8),
                                    RatingBar.builder(
                                      initialRating:
                                          userRating ?? defaultMealRating ?? 0,
                                      minRating: 1,
                                      direction: Axis.horizontal,
                                      allowHalfRating: true,
                                      itemCount: 5,
                                      itemSize: 24.0,
                                      itemPadding: const EdgeInsets.symmetric(
                                          horizontal: 4.0),
                                      itemBuilder: (context, _) => Icon(
                                        Icons.star,
                                        color: ColorsUtility.takeAwayColor,
                                      ),
                                      onRatingUpdate: (rating) {
                                        _saveUserRating(rating);
                                        appSnackbar(
                                          context,
                                          text:
                                              '${S.of(context).youRatedThisMeal} $rating ',
                                          backgroundColor: ColorsUtility
                                              .successSnackbarColor,
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
                          ),
                        ),
                      ),
                    ),
                    AnimationConfiguration.staggeredList(
                      position: 4,
                      duration: const Duration(milliseconds: 500),
                      child: SlideAnimation(
                        verticalOffset: 50.0,
                        child: FadeInAnimation(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 16),
                            child: Text(
                              '${meal['price']} ${S.of(context).egp}',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    AnimationConfiguration.staggeredList(
                      position: 5,
                      duration: const Duration(milliseconds: 500),
                      child: SlideAnimation(
                        verticalOffset: 50.0,
                        child: FadeInAnimation(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 24),
                            child: Center(
                              child: AppElevatedBtn(
                                onPressed: () async {
                                  await context
                                      .read<OrdersCubit>()
                                      .addMeal(meal);
                                  if (context.mounted) {
                                    appSnackbar(
                                      context,
                                      text:
                                          '${_getMealName(context)} ${S.of(context).addedToOrders}',
                                      backgroundColor:
                                          ColorsUtility.successSnackbarColor,
                                    );
                                  }
                                },
                                text: S.of(context).addToOrdersBtn,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
