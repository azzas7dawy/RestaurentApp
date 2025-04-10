import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:restrant_app/screens/mealDeatilsScreen/meal_details_screen.dart';
import 'package:restrant_app/screens/specialPlatesScreen/special_plates_screen.dart';
import 'package:restrant_app/utils/colors_utility.dart';

class SpecialPlatesSectionWidget extends StatelessWidget {
  const SpecialPlatesSectionWidget({super.key});

  Future<List<Map<String, dynamic>>> fetchSpecialPlates() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final List<String> menuDocs = [
      'beef sandwich',
      'chicken sandwich',
      'desserts',
      'mexican',
      'drinks',
    ];

    List<Map<String, dynamic>> specialItems = [];

    for (String docName in menuDocs) {
      QuerySnapshot snapshot = await firestore
          .collection('menu')
          .doc(docName)
          .collection('items')
          .where('special', isEqualTo: true)
          .get();

      for (var doc in snapshot.docs) {
        specialItems.add(doc.data() as Map<String, dynamic>);
      }
    }

    return specialItems;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final screenHeight = MediaQuery.sizeOf(context).height;
    final cardWidth = screenWidth * 0.4;
    final cardHeight = screenHeight * 0.32;

    return FutureBuilder<List<Map<String, dynamic>>>(
      future: fetchSpecialPlates(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              color: ColorsUtility.progressIndictorColor,
            ),
          );
        }

        if (snapshot.hasError) {
          return const Center(child: Text('Something went wrong'));
        }

        final items = snapshot.data ?? [];

        if (items.isEmpty) {
          return const Center(child: Text('No Special Plates found'));
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            SizedBox(
              height: cardHeight,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: items.length > 4 ? 5 : items.length,
                itemBuilder: (context, index) {
                  if (index == 4 && items.length > 4) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          SpecialPlatesScreen.id,
                          arguments: items,
                        );
                      },
                      child: Container(
                        width: cardWidth,
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: ColorsUtility.elevatedBtnColor,
                          boxShadow: [
                            BoxShadow(
                              color:
                                  ColorsUtility.mainBackgroundColor.withAlpha(
                                (0.2 * 255).round(),
                              ),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Text(
                            'See More',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: ColorsUtility.takeAwayColor,
                            ),
                          ),
                        ),
                      ),
                    );
                  }

                  final item = items[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        MealDetailsScreen.id,
                        arguments: item,
                      );
                    },
                    child: Container(
                      width: cardWidth,
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: ColorsUtility.elevatedBtnColor,
                        boxShadow: [
                          BoxShadow(
                            color: ColorsUtility.mainBackgroundColor.withAlpha(
                              (0.2 * 255).round(),
                            ),
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
                              top: Radius.circular(15),
                            ),
                            child: Image.network(
                              item['image'],
                              height: 130,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              item['title'],
                              style: const TextStyle(
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
                              item['description'],
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 14,
                                color: ColorsUtility.textFieldLabelColor,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 4.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${item['price']} EGP',
                                  style: const TextStyle(
                                    color: ColorsUtility.progressIndictorColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(
                                        Icons.favorite_border,
                                        color:
                                            ColorsUtility.progressIndictorColor,
                                      ),
                                      onPressed: () {
                                        // Handle favorite logic
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.add_circle_outline,
                                        color:
                                            ColorsUtility.progressIndictorColor,
                                      ),
                                      onPressed: () {
                                        // Handle add to cart logic
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
              ),
            ),
          ],
        );
      },
    );
  }
}
