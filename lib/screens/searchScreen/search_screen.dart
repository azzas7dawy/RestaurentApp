import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:restrant_app/screens/mealDeatilsScreen/meal_details_screen.dart';
import 'package:restrant_app/utils/colors_utility.dart';

class SearchScreen extends StatefulWidget {
  static const String id = "SearchScreen";

  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
<<<<<<< HEAD
  // final List<String> searchSuggestions = [
  //   "Pizza",
  //   "Burger",
  //   "Pasta",
  //   "Sushi",
  //   "Salad",
  //   "Steak",
  //   "Sandwich",
  // ];

=======
>>>>>>> master
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _searchResults = [];
  bool _isSearching = false;
  bool _hasSearched = false;

<<<<<<< HEAD
// fetcg data from fs
=======
>>>>>>> master
  Future<List<Map<String, dynamic>>> _fetchMealsOnly(String query) async {
    if (query.isEmpty) return [];

    final firestore = FirebaseFirestore.instance;
    final List<Map<String, dynamic>> results = [];

    try {
      final menuSnapshot = await firestore.collection('menu').get();

      for (final menuDoc in menuSnapshot.docs) {
        final itemsSnapshot = await menuDoc.reference.collection('items').get();
        for (final itemDoc in itemsSnapshot.docs) {
          final itemData = itemDoc.data();
          if (itemData['title']
                  ?.toString()
                  .toLowerCase()
                  .contains(query.toLowerCase()) ??
              false) {
            results.add({
              'id': itemDoc.id,
              'title': itemData['title'],
              'category': menuDoc.id,
              'image': itemData['image'] ?? '',
              'price': itemData['price'] ?? 0.0,
              'description': itemData['description'] ?? '',
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
<<<<<<< HEAD
// =================================================================================================

// search query
=======

>>>>>>> master
  Future<void> _performSearch(String query) async {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
        _hasSearched = false;
      });
      return;
    }

    setState(() {
      _isSearching = true;
      _hasSearched = true;
    });

    final results = await _fetchMealsOnly(query);

    setState(() {
      _searchResults = results;
      _isSearching = false;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    return Scaffold(
      //  backgroundColor: Colors.black,
      // appBar: AppBar(
      //   backgroundColor: Colors.black,
      //   leading: IconButton(
      //     icon: Icon(Icons.arrow_back, color: Colors.white),
      //     onPressed: () => Navigator.pop(context),
      //   ),
      //   title: Text("Search"),
      // ),
=======
    final theme = Theme.of(context);

    return Scaffold(
>>>>>>> master
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
<<<<<<< HEAD
              _buildSearchField(),
              const SizedBox(height: 16),
              Expanded(
                child: _buildSearchResults(),
              ),

              // SizedBox(height: 20),

              // // ⏳ "Repeat last order" & "Help me choose"
              // Row(
              //   children: [
              //     Icon(Icons.refresh, color: Colors.white),
              //     SizedBox(width: 10),
              //     Text("Repeat last order",
              //         style: TextStyle(color: Colors.white)),
              //   ],
              // ),
              // SizedBox(height: 10),
              // Row(
              //   children: [
              //     Icon(Icons.help_outline, color: Colors.white),
              //     SizedBox(width: 10),
              //     Text("Help me choose", style: TextStyle(color: Colors.white)),
              //   ],
              // ),

              // SizedBox(height: 20),

              // 🖼️ نتائج البحث أو اقتراحات أخرى (وهمية حالياً)
              // Expanded(
              //   child: ListView(
              //     children: searchSuggestions.map((item) {
              //       return ListTile(
              //         title: Text(item, style: TextStyle(color: Colors.white)),
              //         leading: Icon(Icons.fastfood, color: Colors.white),
              //         onTap: () {
              //           print("Selected: $item");
              //         },
              //       );
              //     }).toList(),
              //   ),
              // ),
=======
              _buildSearchField(theme),
              const SizedBox(height: 16),
              Expanded(child: _buildSearchResults(theme)),
>>>>>>> master
            ],
          ),
        ),
      ),
    );
  }

<<<<<<< HEAD
// meal img
  Widget _buildMealImage(String imageUrl) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: imageUrl.isEmpty
          ? Container(
              width: 70,
              height: 70,
              color: ColorsUtility.elevatedBtnColor,
              child: const Icon(
                Icons.fastfood,
                color: ColorsUtility.mainBackgroundColor,
              ),
            )
          : CachedNetworkImage(
              imageUrl: imageUrl,
              width: 70,
              height: 70,
              fit: BoxFit.cover,
              placeholder: (context, url) {
                return Container(
                  color: ColorsUtility.elevatedBtnColor,
                  child: const Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: ColorsUtility.progressIndictorColor,
                    ),
                  ),
                );
              },
              errorWidget: (context, url, error) {
                return Container(
                  color: ColorsUtility.onboardingDescriptionColor,
                  child: const Icon(
                    Icons.fastfood,
                    color: ColorsUtility.mainBackgroundColor,
                  ),
                );
              },
            ),
    );
  }

// ==================================================================================================
// search
  Widget _buildSearchField() {
    return TextField(
      controller: _searchController,
      style: const TextStyle(color: ColorsUtility.textFieldLabelColor),
      decoration: InputDecoration(
        filled: true,
        fillColor: ColorsUtility.textFieldFillColor,
        hintText: 'Search for meals...',
        hintStyle: const TextStyle(color: ColorsUtility.textFieldLabelColor),
        prefixIcon:
            const Icon(Icons.search, color: ColorsUtility.textFieldLabelColor),
        suffixIcon: _searchController.text.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.clear,
                    color: ColorsUtility.textFieldLabelColor),
=======
  Widget _buildSearchField(ThemeData theme) {
    return TextField(
      controller: _searchController,
      style: theme.textTheme.bodyMedium,
      decoration: InputDecoration(
        filled: true,
        fillColor: theme.inputDecorationTheme.fillColor,
        hintText: 'Search for meals...',
        hintStyle: theme.inputDecorationTheme.hintStyle,
        prefixIcon: Icon(Icons.search, color: theme.iconTheme.color),
        suffixIcon: _searchController.text.isNotEmpty
            ? IconButton(
                icon: Icon(Icons.clear, color: theme.iconTheme.color),
>>>>>>> master
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

<<<<<<< HEAD
// ==================================================================================================
// search results
  Widget _buildSearchResults() {
    if (_isSearching) {
      return const Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: ColorsUtility.progressIndictorColor,
=======
  Widget _buildSearchResults(ThemeData theme) {
    if (_isSearching) {
      return Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: theme.colorScheme.primary,
>>>>>>> master
        ),
      );
    }

    if (!_hasSearched) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
<<<<<<< HEAD
            Icon(
              Icons.search,
              size: 80,
              color: ColorsUtility.textFieldLabelColor,
            ),
            const SizedBox(height: 20),
            Text(
              "Search for meals by name",
              style: TextStyle(
                color: ColorsUtility.textFieldLabelColor,
                fontSize: 18,
=======
            Icon(Icons.search,
                size: 80, color: ColorsUtility.lightOnboardingDescriptionColor),
            const SizedBox(height: 20),
            Text(
              "Search for meals by name",
              style: theme.textTheme.bodyLarge?.copyWith(
                fontSize: 18,
                color: ColorsUtility.lightOnboardingDescriptionColor,
>>>>>>> master
              ),
            ),
          ],
        ),
      );
    }

    if (_searchResults.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
<<<<<<< HEAD
            Icon(
              Icons.search_off,
              size: 80,
              color: ColorsUtility.textFieldLabelColor,
            ),
            const SizedBox(height: 20),
            Text(
              "No meals found",
              style: TextStyle(
                color: ColorsUtility.textFieldLabelColor,
                fontSize: 18,
=======
            Icon(Icons.search_off,
                size: 80, color: ColorsUtility.lightOnboardingDescriptionColor),
            const SizedBox(height: 20),
            Text(
              "No meals found",
              style: theme.textTheme.bodyLarge?.copyWith(
                fontSize: 18,
                color: ColorsUtility.lightOnboardingDescriptionColor,
>>>>>>> master
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Try different meal names",
<<<<<<< HEAD
              style: TextStyle(
                color: ColorsUtility.textFieldLabelColor,
                fontSize: 14,
=======
              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: 14,
                color: ColorsUtility.lightOnboardingDescriptionColor,
>>>>>>> master
              ),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.only(top: 16),
      itemCount: _searchResults.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final meal = _searchResults[index];
<<<<<<< HEAD
        return Container(
          decoration: BoxDecoration(
            color: ColorsUtility.elevatedBtnColor,
=======

        return Container(
          decoration: BoxDecoration(
            color: theme.scaffoldBackgroundColor,
>>>>>>> master
            borderRadius: BorderRadius.circular(15),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(12),
<<<<<<< HEAD
            leading: _buildMealImage(meal['image']),
            title: Text(
              meal['title'],
              style: const TextStyle(
                color: ColorsUtility.takeAwayColor,
                fontWeight: FontWeight.w500,
=======
            leading: _buildMealImage(meal['image'], theme),
            title: Text(
              meal['title'],
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: ColorsUtility.takeAwayColor,
>>>>>>> master
              ),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    meal['category'],
<<<<<<< HEAD
                    style: TextStyle(
                      color: ColorsUtility.textFieldLabelColor,
                      fontSize: 13,
                    ),
=======
                    style: theme.textTheme.bodySmall,
>>>>>>> master
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        '\$${meal['price'].toStringAsFixed(2)}',
<<<<<<< HEAD
                        style: const TextStyle(
                          color: ColorsUtility.progressIndictorColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
=======
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: ColorsUtility.progressIndictorColor,
>>>>>>> master
                        ),
                      ),
                      if (meal['rate'] > 0) ...[
                        const SizedBox(width: 16),
<<<<<<< HEAD
                        const Icon(
                          Icons.star,
                          color: ColorsUtility.takeAwayColor,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          meal['rate'].toStringAsFixed(1),
                          style: TextStyle(
                            color: ColorsUtility.textFieldLabelColor,
                            fontSize: 14,
                          ),
=======
                        Icon(Icons.star, color: theme.colorScheme.primary),
                        const SizedBox(width: 4),
                        Text(
                          meal['rate'].toStringAsFixed(1),
                          style: theme.textTheme.bodySmall,
>>>>>>> master
                        ),
                      ],
                    ],
                  ),
                  if (meal['description']?.isNotEmpty == true)
                    Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(
                        meal['description'],
<<<<<<< HEAD
                        style: TextStyle(
                          color: ColorsUtility.textFieldLabelColor,
                          fontSize: 12,
                        ),
=======
                        style:
                            theme.textTheme.bodySmall?.copyWith(fontSize: 12),
>>>>>>> master
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                ],
              ),
            ),
<<<<<<< HEAD
            trailing: Icon(
              Icons.chevron_right,
              color: ColorsUtility.textFieldLabelColor,
            ),
=======
            trailing: Icon(Icons.chevron_right, color: theme.iconTheme.color),
>>>>>>> master
            onTap: () {
              Navigator.pushNamed(
                context,
                MealDetailsScreen.id,
                arguments: meal,
              );
            },
          ),
        );
      },
    );
  }
<<<<<<< HEAD
=======

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
>>>>>>> master
}
