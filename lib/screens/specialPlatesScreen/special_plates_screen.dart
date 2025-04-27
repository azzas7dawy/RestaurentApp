import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restrant_app/cubit/FavoritesLogic/cubit/favorites_cubit.dart';
import 'package:restrant_app/cubit/OrdersLogic/cubit/orders_cubit.dart';
import 'package:restrant_app/generated/l10n.dart';
import 'package:restrant_app/screens/mealDeatilsScreen/meal_details_screen.dart';
import 'package:restrant_app/utils/colors_utility.dart';
import 'package:restrant_app/widgets/app_snackbar.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class SpecialPlatesScreen extends StatefulWidget {
  const SpecialPlatesScreen({super.key, required this.items});
  final List<Map<String, dynamic>> items;
  static const String id = 'SpecialPlatesScreen';

  @override
  State<SpecialPlatesScreen> createState() => _SpecialPlatesScreenState();
}

class _SpecialPlatesScreenState extends State<SpecialPlatesScreen> {
  final ScrollController _scrollController = ScrollController();
  List<Map<String, dynamic>> _displayedItems = [];
  int _currentMax = 3;
  bool _isLoadingMore = false;
  bool _hasMoreData = true;

  bool isArabic(BuildContext context) {
    return Localizations.localeOf(context).languageCode == 'ar';
  }

  @override
  void initState() {
    super.initState();
    _displayedItems = widget.items.take(_currentMax).toList();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 100 &&
          !_isLoadingMore &&
          _hasMoreData) {
        _loadMore();
      }
    });
  }

  void _loadMore() async {
    setState(() {
      _isLoadingMore = true;
    });

    await Future.delayed(const Duration(seconds: 1));

    if (_currentMax < widget.items.length) {
      setState(() {
        _currentMax += 3;
        if (_currentMax >= widget.items.length) {
          _currentMax = widget.items.length;
          _hasMoreData = false;
        }
        _displayedItems = widget.items.take(_currentMax).toList();
      });
    } else {
      setState(() {
        _hasMoreData = false;
      });
    }

    setState(() {
      _isLoadingMore = false;
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkTheme = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        title: Text(
          S.of(context).specialPlates,
          style: TextStyle(
            color: ColorsUtility.takeAwayColor,
            fontSize: theme.textTheme.titleLarge?.fontSize,
          ),
        ),
        iconTheme: IconThemeData(
          color: ColorsUtility.takeAwayColor,
        ),
        centerTitle: true,
      ),
      backgroundColor: theme.scaffoldBackgroundColor,
      body: AnimationLimiter(
        child: ListView.builder(
          controller: _scrollController,
          padding: const EdgeInsets.all(16),
          itemCount: _displayedItems.length + 1,
          itemBuilder: (context, index) {
            if (index < _displayedItems.length) {
              final Map<String, dynamic> item = _displayedItems[index];
              return AnimationConfiguration.staggeredList(
                position: index,
                duration: const Duration(milliseconds: 500),
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
                      child: Container(
                        width: double.infinity,
                        margin: const EdgeInsets.symmetric(vertical: 8),
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
                                  top: Radius.circular(15)),
                              child: CachedNetworkImage(
                                imageUrl: item['image'],
                                height: 180,
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
                                    '${item['price']} ${S.of(context).egp}',
                                    style: TextStyle(
                                      color: theme.colorScheme.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      BlocBuilder<FavoritesCubit,
                                          FavoritesState>(
                                        builder: (context, state) {
                                          final bool isFavorite = state
                                                  is FavoritesLoaded
                                              ? state.favorites.any(
                                                  (favorite) =>
                                                      favorite['documentId'] ==
                                                      item['documentId'])
                                              : false;
                                          return IconButton(
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
                                                        item['documentId']);
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
                                          );
                                        },
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          Icons.add_circle_outline,
                                          color: theme.colorScheme.primary,
                                        ),
                                        onPressed: () {
                                          context
                                              .read<OrdersCubit>()
                                              .addMeal(item);
                                          appSnackbar(
                                            context,
                                            text:
                                                '${isArabic(context) ? item['title_ar'] ?? item['title'] : item['title']} ${S.of(context).addedToOrders}',
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
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            } else {
              if (_isLoadingMore) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: CircularProgressIndicator(),
                  ),
                );
              } else if (!_hasMoreData) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Text(
                      S.of(context).noMoreData,
                      style: TextStyle(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                );
              } else {
                return const SizedBox();
              }
            }
          },
        ),
      ),
    );
  }
}
