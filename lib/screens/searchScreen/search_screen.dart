import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:restrant_app/generated/l10n.dart';
import 'package:restrant_app/screens/mealDeatilsScreen/meal_details_screen.dart';
import 'package:restrant_app/utils/colors_utility.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class SearchScreen extends StatefulWidget {
  static const String id = "SearchScreen";

  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<Map<String, dynamic>> _allSearchResults = [];
  List<Map<String, dynamic>> _displayedResults = [];
  bool _isSearching = false;
  bool _hasSearched = false;
  int _currentMax = 5;
  bool _isLoadingMore = false;
  bool _hasMoreData = true;

  dynamic _getLocalizedValue(Map<String, dynamic> data, String field) {
    final locale = Localizations.localeOf(context);

    if (field == 'description') {
      if (locale.languageCode == 'ar' && data['desc_ar'] != null) {
        return data['desc_ar'];
      }
      return data['description'] ?? data['desc'] ?? '';
    }

    if (locale.languageCode == 'ar' && data['${field}_ar'] != null) {
      return data['${field}_ar'];
    }
    return data[field] ?? '';
  }

  Future<List<Map<String, dynamic>>> _fetchMealsOnly(String query) async {
    if (query.isEmpty) return [];

    final firestore = FirebaseFirestore.instance;
    final List<Map<String, dynamic>> results = [];

    try {
      final menuSnapshot = await firestore.collection('menu').get();

      for (final menuDoc in menuSnapshot.docs) {
        final categoryData = menuDoc.data();
        final categoryName = categoryData['category'] ?? menuDoc.id;
        final categoryNameAr = categoryData['category_ar'] ?? categoryName;

        final itemsSnapshot = await menuDoc.reference.collection('items').get();
        for (final itemDoc in itemsSnapshot.docs) {
          final itemData = itemDoc.data();

          final title = itemData['title']?.toString().toLowerCase() ?? '';
          final titleAr = itemData['title_ar']?.toString().toLowerCase() ?? '';
          final name = itemData['name']?.toString().toLowerCase() ?? '';
          final nameAr = itemData['name_ar']?.toString().toLowerCase() ?? '';

          final queryLower = query.toLowerCase();

          if (title.contains(queryLower) ||
              titleAr.contains(queryLower) ||
              name.contains(queryLower) ||
              nameAr.contains(queryLower)) {
            final currentLocale = Localizations.localeOf(context);
            final displayCategory = currentLocale.languageCode == 'ar'
                ? categoryNameAr
                : categoryName;

            results.add({
              'id': itemDoc.id,
              'title': _getLocalizedValue(itemData, 'title') ??
                  _getLocalizedValue(itemData, 'name') ??
                  '',
              'category': displayCategory,
              'image': itemData['image'] ?? '',
              'price': itemData['price'] ?? 0.0,
              'description': _getLocalizedValue(itemData, 'description'),
              'rate': itemData['rate']?.toDouble() ?? 0.0,
              'is_available': itemData['is_available'] ?? true,
              'documentId': itemDoc.id,
            });
          }
        }
      }
    } catch (e) {
      debugPrint('Error fetching meals: $e');
    }

    return results;
  }

  void _loadMore() {
    if (_isLoadingMore || !_hasMoreData) return;

    setState(() {
      _isLoadingMore = true;
    });

    Future.delayed(const Duration(milliseconds: 500), () {
      if (_currentMax < _allSearchResults.length) {
        setState(() {
          _currentMax += 5;
          if (_currentMax >= _allSearchResults.length) {
            _currentMax = _allSearchResults.length;
            _hasMoreData = false;
          }
          _displayedResults = _allSearchResults.take(_currentMax).toList();
        });
      } else {
        setState(() {
          _hasMoreData = false;
        });
      }

      setState(() {
        _isLoadingMore = false;
      });
    });
  }

  Future<void> _performSearch(String query) async {
    if (query.isEmpty) {
      setState(() {
        _allSearchResults = [];
        _displayedResults = [];
        _hasSearched = false;
        _currentMax = 5;
        _hasMoreData = true;
      });
      return;
    }

    setState(() {
      _isSearching = true;
      _hasSearched = true;
      _currentMax = 5;
      _hasMoreData = true;
    });

    final results = await _fetchMealsOnly(query);

    setState(() {
      _allSearchResults = results;
      _displayedResults = results.take(_currentMax).toList();
      _isSearching = false;
      _hasMoreData = results.length > _currentMax;
    });
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 100 &&
          !_isLoadingMore &&
          _hasMoreData) {
        _loadMore();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context);
    final isArabic = locale.languageCode == 'ar';

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildSearchField(theme, isArabic),
              const SizedBox(height: 16),
              Expanded(child: _buildSearchResults(theme)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchField(ThemeData theme, bool isArabic) {
    return TextField(
      controller: _searchController,
      style: theme.textTheme.bodyMedium,
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      decoration: InputDecoration(
        filled: true,
        fillColor: theme.inputDecorationTheme.fillColor,
        hintText: isArabic ? 'ابحث عن وجبات...' : 'Search for meals...',
        hintStyle: theme.inputDecorationTheme.hintStyle,
        prefixIcon: Icon(Icons.search, color: theme.iconTheme.color),
        suffixIcon: _searchController.text.isNotEmpty
            ? IconButton(
                icon: Icon(Icons.clear, color: theme.iconTheme.color),
                onPressed: () {
                  _searchController.clear();
                  _performSearch('');
                },
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 15),
      ),
      onChanged: (value) {
        _performSearch(value);
      },
    );
  }

  Widget _buildSearchResults(ThemeData theme) {
    if (_isSearching) {
      return Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: theme.colorScheme.primary,
        ),
      );
    }

    if (!_hasSearched) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search,
                size: 80, color: ColorsUtility.lightOnboardingDescriptionColor),
            const SizedBox(height: 20),
            Text(
              S.of(context).searchMeals,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontSize: 18,
                color: ColorsUtility.lightOnboardingDescriptionColor,
              ),
            ),
          ],
        ),
      );
    }

    if (_displayedResults.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off,
                size: 80, color: ColorsUtility.lightOnboardingDescriptionColor),
            const SizedBox(height: 20),
            Text(
              S.of(context).noMealsFound,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontSize: 18,
                color: ColorsUtility.lightOnboardingDescriptionColor,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              S.of(context).tryDifferentMealsName,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: 14,
                color: ColorsUtility.lightOnboardingDescriptionColor,
              ),
            ),
          ],
        ),
      );
    }

    return AnimationLimiter(
      child: ListView.separated(
        controller: _scrollController,
        padding: const EdgeInsets.only(top: 16),
        itemCount: _displayedResults.length + 1,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          if (index < _displayedResults.length) {
            final meal = _displayedResults[index];

            return AnimationConfiguration.staggeredList(
              position: index,
              duration: const Duration(milliseconds: 500),
              child: SlideAnimation(
                verticalOffset: 50.0,
                child: FadeInAnimation(
                  child: Container(
                    decoration: BoxDecoration(
                      color: theme.scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(12),
                      leading: _buildMealImage(meal['image'], theme),
                      title: Text(
                        meal['title'],
                        style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: ColorsUtility.errorSnackbarColor),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              meal['category'].toString(),
                              style: theme.textTheme.bodySmall,
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Text(
                                  '\$${meal['price'].toStringAsFixed(2)}',
                                  style: theme.textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: theme.colorScheme.primary,
                                  ),
                                ),
                                if (meal['rate'] > 0) ...[
                                  const SizedBox(width: 16),
                                  Icon(
                                    Icons.star,
                                    color: ColorsUtility.takeAwayColor,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    meal['rate'].toStringAsFixed(1),
                                    style: theme.textTheme.bodySmall,
                                  ),
                                ],
                              ],
                            ),
                            if (meal['description']?.isNotEmpty == true)
                              Padding(
                                padding: const EdgeInsets.only(top: 6),
                                child: Text(
                                  meal['description'],
                                  style: theme.textTheme.bodySmall
                                      ?.copyWith(fontSize: 12),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                          ],
                        ),
                      ),
                      trailing: Icon(Icons.chevron_right,
                          color: theme.iconTheme.color),
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          MealDetailsScreen.id,
                          arguments: meal,
                        );
                      },
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
            } else if (!_hasMoreData && _allSearchResults.isNotEmpty) {
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
    );
  }

  Widget _buildMealImage(String imageUrl, ThemeData theme) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: imageUrl.isEmpty
          ? Container(
              width: 70,
              height: 70,
              color: theme.scaffoldBackgroundColor,
              child: Icon(Icons.fastfood, color: theme.scaffoldBackgroundColor),
            )
          : CachedNetworkImage(
              imageUrl: imageUrl,
              width: 70,
              height: 70,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                color: theme.cardColor,
                child: Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
              errorWidget: (context, url, error) => Container(
                color: theme.disabledColor,
                child: Icon(Icons.fastfood, color: theme.cardColor),
              ),
            ),
    );
  }
}
