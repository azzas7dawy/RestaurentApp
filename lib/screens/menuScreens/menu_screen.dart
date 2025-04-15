import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:restrant_app/utils/colors_utility.dart';
import 'package:restrant_app/screens/menuScreens/category_items_screen.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});
  static const String id = 'MenuScreen';

  final List<String> categories = const [
    'beef sandwich',
    'chicken sandwich',
    'desserts',
    'drinks',
    'mexican'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: const Text(
              'Our Menu',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: ColorsUtility.onboardingColor,
                shadows: [
                  Shadow(
                    blurRadius: 10,
                    color: ColorsUtility.mainBackgroundColor,
                    offset: Offset(2, 2),
                  ),
                ],
              ),
            ),
            centerTitle: true,
            pinned: true,
            expandedHeight: 200,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                children: [
                  // Header image
                  Positioned.fill(
                    child: CachedNetworkImage(
                      imageUrl:
                          'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4',
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const Center(
                        child: CircularProgressIndicator(
                          color: ColorsUtility.progressIndictorColor,
                        ),
                      ),
                      errorWidget: (context, url, error) => const Icon(
                        Icons.restaurant,
                        size: 50,
                        color: ColorsUtility.onboardingColor,
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            ColorsUtility.mainBackgroundColor.withAlpha(153),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('menu').snapshots(),
            builder: (context, menuSnapshot) {
              if (menuSnapshot.connectionState == ConnectionState.waiting) {
                return const SliverFillRemaining(
                  child: Center(
                      child: CircularProgressIndicator(
                    color: ColorsUtility.progressIndictorColor,
                  )),
                );
              }

              if (!menuSnapshot.hasData || menuSnapshot.data!.docs.isEmpty) {
                return const SliverFillRemaining(
                  child: Center(
                      child: Text(
                    'No menus available currently',
                    style: TextStyle(
                      color: ColorsUtility.progressIndictorColor,
                    ),
                  )),
                );
              }

              var filteredDocs = menuSnapshot.data!.docs
                  .where((doc) => categories.contains(doc.id))
                  .toList();

              if (filteredDocs.isEmpty) {
                return const SliverFillRemaining(
                  child: Center(
                    child: Text(
                      'No matching categories found',
                      style: TextStyle(
                        color: ColorsUtility.progressIndictorColor,
                      ),
                    ),
                  ),
                );
              }
              return SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 15,
                  crossAxisSpacing: 15,
                  childAspectRatio: 0.9,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    var categoryDoc = filteredDocs[index];
                    return _buildCategoryCard(categoryDoc, context);
                  },
                  childCount: filteredDocs.length,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(
      DocumentSnapshot categoryDoc, BuildContext context) {
    return FutureBuilder<int>(
      future: _getItemCount(categoryDoc.reference),
      builder: (context, snapshot) {
        int itemCount = snapshot.hasData ? snapshot.data! : 0;

        return Card(
          color: ColorsUtility.elevatedBtnColor,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: const BorderSide(
              color: ColorsUtility.mainBackgroundColor,
            ),
          ),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () {
              Navigator.pushNamed(
                context,
                CategoryItemsScreen.id,
                arguments: categoryDoc,
              );

              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) =>
              //         CategoryItemsScreen(categoryDoc: categoryDoc),
              //   ),
              // );
            },
            child: Stack(
              children: [
                Positioned.fill(
                  child: CachedNetworkImage(
                    imageUrl: _getCategoryImage(categoryDoc.id),
                    fit: BoxFit.cover,
                    placeholder: (context, url) => const Center(
                      child: CircularProgressIndicator(
                        color: ColorsUtility.progressIndictorColor,
                      ),
                    ),
                    errorWidget: (context, url, error) => const Center(
                      child: Icon(Icons.fastfood, size: 50),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          ColorsUtility.mainBackgroundColor.withAlpha(179),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 10,
                  left: 10,
                  right: 10,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _formatCategoryName(categoryDoc.id),
                        style: const TextStyle(
                          color: ColorsUtility.takeAwayColor,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        '$itemCount items',
                        style: TextStyle(
                          color: ColorsUtility.onboardingColor.withAlpha(230),
                          fontSize: 14,
                        ),
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

  Future<int> _getItemCount(DocumentReference categoryRef) async {
    var items = await categoryRef.collection('items').get();
    return items.size;
  }

  String _formatCategoryName(String name) {
    return name
        .split(' ')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }

  String _getCategoryImage(String category) {
    switch (category) {
      case 'beef sandwich':
        return 'https://images.unsplash.com/photo-1551615593-ef5fe247e8f7';
      case 'chicken sandwich':
        return 'https://images.unsplash.com/photo-1606755456206-b25206cde27e';
      case 'desserts':
        return 'https://images.unsplash.com/photo-1551024506-0bccd828d307';
      case 'drinks':
        return 'https://images.unsplash.com/photo-1513558161293-cdaf765ed2fd';
      case 'mexican':
        return 'https://images.unsplash.com/photo-1513456852971-30c0b8199d4d';
      default:
        return 'https://images.unsplash.com/photo-1504674900247-0877df9cc836';
    }
  }
}
