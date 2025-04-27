import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:restrant_app/generated/l10n.dart';
import 'package:restrant_app/screens/menuScreens/category_items_screen.dart';
import 'package:restrant_app/utils/colors_utility.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});
  static const String id = 'MenuScreen';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            automaticallyImplyLeading: false,
            title: Text(
              S.of(context).ourMenu,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: ColorsUtility.onboardingColor,
                shadows: [
                  Shadow(
                    blurRadius: 10,
                    color: theme.scaffoldBackgroundColor,
                    offset: const Offset(2, 2),
                  ),
                ],
              ),
            ),
            centerTitle: true,
            pinned: true,
            expandedHeight: 250,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                children: [
                  Positioned.fill(
                    child: CachedNetworkImage(
                      imageUrl:
                          'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4',
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: theme.scaffoldBackgroundColor,
                        child: Center(
                          child: CircularProgressIndicator(
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: theme.scaffoldBackgroundColor,
                        child: Icon(
                          Icons.restaurant_menu,
                          size: 100,
                          color: theme.colorScheme.primary,
                        ),
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
                            ColorsUtility.mainBackgroundColor.withAlpha(200),
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
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('menu').snapshots(),
              builder: (context, menuSnapshot) {
                if (menuSnapshot.connectionState == ConnectionState.waiting) {
                  return SliverFillRemaining(
                    child: Center(
                      child: CircularProgressIndicator(
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  );
                }

                if (!menuSnapshot.hasData || menuSnapshot.data!.docs.isEmpty) {
                  return SliverFillRemaining(
                    child: Center(
                      child: Text(
                        S.of(context).noCatAvailable,
                        style: TextStyle(
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                  );
                }

                return AnimationLimiter(
                  child: SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 15,
                      crossAxisSpacing: 15,
                      childAspectRatio: 0.9,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        var categoryDoc = menuSnapshot.data!.docs[index];
                        return AnimationConfiguration.staggeredGrid(
                          position: index,
                          duration: const Duration(milliseconds: 500),
                          columnCount: 2,
                          child: SlideAnimation(
                            verticalOffset: 50.0,
                            child: FadeInAnimation(
                              child: _buildCategoryCard(categoryDoc, context),
                            ),
                          ),
                        );
                      },
                      childCount: menuSnapshot.data!.docs.length,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(
      DocumentSnapshot categoryDoc, BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return FutureBuilder<int>(
      future: _getItemCount(categoryDoc.reference),
      builder: (context, snapshot) {
        int itemCount = snapshot.hasData ? snapshot.data! : 0;

        return Card(
          color: isDarkMode
              ? ColorsUtility.elevatedBtnColor
              : ColorsUtility.lightMainBackgroundColor,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(15),
            onTap: () {
              Navigator.pushNamed(
                context,
                CategoryItemsScreen.id,
                arguments: categoryDoc,
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    _getCategoryIcon(categoryDoc.id),
                    size: 40,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _getCategoryName(categoryDoc.id, context),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: ColorsUtility.errorSnackbarColor,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '$itemCount items',
                    style: TextStyle(
                      fontSize: 14,
                      color: isDarkMode
                          ? theme.colorScheme.primary.withAlpha(230)
                          : ColorsUtility.lightTextFieldLabelColor,
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

  String _getCategoryName(String categoryId, BuildContext context) {
    return _formatCategoryName(categoryId);
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'beef sandwich':
        return Icons.lunch_dining;
      case 'chicken sandwich':
        return Icons.fastfood;
      case 'desserts':
        return Icons.cake;
      case 'drinks':
        return Icons.local_drink;
      case 'mexican':
        return Icons.restaurant;
      default:
        return Icons.restaurant_menu;
    }
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
}
