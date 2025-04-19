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
  // final List<String> searchSuggestions = [
  //   "Pizza",
  //   "Burger",
  //   "Pasta",
  //   "Sushi",
  //   "Salad",
  //   "Steak",
  //   "Sandwich",
  // ];

  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _searchResults = [];
  bool _isSearching = false;
  bool _hasSearched = false;

// fetcg data from fs
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
// =================================================================================================

// search query
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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
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
            ],
          ),
        ),
      ),
    );
  }

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

// ==================================================================================================
// search results
  Widget _buildSearchResults() {
    if (_isSearching) {
      return const Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: ColorsUtility.progressIndictorColor,
        ),
      );
    }

    if (!_hasSearched) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Try different meal names",
              style: TextStyle(
                color: ColorsUtility.textFieldLabelColor,
                fontSize: 14,
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
        return Container(
          decoration: BoxDecoration(
            color: ColorsUtility.elevatedBtnColor,
            borderRadius: BorderRadius.circular(15),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(12),
            leading: _buildMealImage(meal['image']),
            title: Text(
              meal['title'],
              style: const TextStyle(
                color: ColorsUtility.takeAwayColor,
                fontWeight: FontWeight.w500,
              ),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    meal['category'],
                    style: TextStyle(
                      color: ColorsUtility.textFieldLabelColor,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        '\$${meal['price'].toStringAsFixed(2)}',
                        style: const TextStyle(
                          color: ColorsUtility.progressIndictorColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      if (meal['rate'] > 0) ...[
                        const SizedBox(width: 16),
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
                        ),
                      ],
                    ],
                  ),
                  if (meal['description']?.isNotEmpty == true)
                    Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(
                        meal['description'],
                        style: TextStyle(
                          color: ColorsUtility.textFieldLabelColor,
                          fontSize: 12,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                ],
              ),
            ),
            trailing: Icon(
              Icons.chevron_right,
              color: ColorsUtility.textFieldLabelColor,
            ),
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
}
