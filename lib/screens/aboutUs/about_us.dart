import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:restrant_app/cubit/ThemeLogic/cubit/theme_cubit.dart';
// import 'package:restrant_app/screens/adminDashbord/chat.dart';
import 'package:restrant_app/generated/l10n.dart';
import 'package:restrant_app/screens/adminDashbord/admin/chat_screen.dart';
import 'package:restrant_app/screens/adminDashbord/chat.dart';
import 'package:restrant_app/utils/colors_utility.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class AboutSupportPage extends StatelessWidget {
  const AboutSupportPage({super.key});
  static const String id = 'AboutSupportPage';

  final String googleMapsUrl =
      "https://www.google.com/maps/place/Minya,+Menia,+Egypt";

  void _openMap() async {
    final Uri url = Uri.parse(googleMapsUrl);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkTheme = theme.brightness == Brightness.dark;
    // final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        title: Text(
          S.of(context).aboutRestaurant,
          style: TextStyle(
            color: theme.colorScheme.primary,
          ),
        ),
        iconTheme: IconThemeData(
          color: theme.colorScheme.primary,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: AnimationLimiter(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: AnimationConfiguration.toStaggeredList(
              duration: const Duration(milliseconds: 375),
              childAnimationBuilder: (widget) => SlideAnimation(
                horizontalOffset: 50.0,
                child: FadeInAnimation(
                  child: widget,
                ),
              ),
              children: [
                // ✨ About Restaurant Section
                AnimationConfiguration.staggeredList(
                  position: 0,
                  duration: const Duration(milliseconds: 375),
                  child: SlideAnimation(
                    verticalOffset: 50.0,
                    child: FadeInAnimation(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${S.of(context).about} ${S.of(context).splashTitle} 🍔",
                            style: TextStyle(
                              color: ColorsUtility.failedStatusColor,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            S.of(context).aboutRestaurantDescription,
                            style: TextStyle(
                              color: isDarkTheme
                                  ? ColorsUtility.textFieldLabelColor
                                  : ColorsUtility.lightTextFieldLabelColor,
                              fontSize: 15,
                              height: 1.5,
                            ),
                            textAlign: TextAlign.justify,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // 💬 Chat Section
                AnimationConfiguration.staggeredList(
                  position: 1,
                  duration: const Duration(milliseconds: 425),
                  child: SlideAnimation(
                    verticalOffset: 50.0,
                    child: FadeInAnimation(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChatScreenn(
                                  otherUserEmail: FirebaseAuth
                                          .instance.currentUser?.email ??
                                      '', myId: FirebaseAuth.instance.currentUser?.uid ?? '',
                                  
                                  otherId: 'adminUID',
                                ),
                              ),
                            ),
                            child: Text(
                              "${S.of(context).askAdmin} 💬",
                              style: TextStyle(
                                color: theme.colorScheme.primary,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: isDarkTheme
                                  ? ColorsUtility.elevatedBtnColor
                                  : ColorsUtility.lightMainBackgroundColor,
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: theme.colorScheme.primary,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                S.of(context).askAdminDescription,
                                style: TextStyle(
                                  color: isDarkTheme
                                      ? ColorsUtility.textFieldLabelColor
                                      : ColorsUtility.lightTextFieldLabelColor,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // 📍 Location Section
                AnimationConfiguration.staggeredList(
                  position: 2,
                  duration: const Duration(milliseconds: 475),
                  child: SlideAnimation(
                    verticalOffset: 50.0,
                    child: FadeInAnimation(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "📍 ${S.of(context).location}",
                            style: TextStyle(
                              color: theme.colorScheme.primary,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: isDarkTheme
                                  ? ColorsUtility.elevatedBtnColor
                                  : ColorsUtility.lightMainBackgroundColor,
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: ColorsUtility.errorSnackbarColor
                                    .withOpacity(0.3),
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.location_on,
                                  color: ColorsUtility.failedStatusColor,
                                  size: 30,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    S.of(context).restaurantLocation,
                                    style: TextStyle(
                                      color: isDarkTheme
                                          ? ColorsUtility.textFieldLabelColor
                                          : ColorsUtility
                                              .lightTextFieldLabelColor,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: _openMap,
                                  icon: Icon(
                                    Icons.map,
                                    color: ColorsUtility.failedStatusColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
