import 'package:flutter/material.dart';
import 'package:restrant_app/generated/l10n.dart';
import 'package:restrant_app/utils/colors_utility.dart';
import 'package:restrant_app/utils/images_utility.dart';

class ReserveTableCardWidget extends StatelessWidget {
  const ReserveTableCardWidget({super.key, this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          height: 200,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            image: const DecorationImage(
              image: AssetImage(ImagesUtility.reserveTableImage),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                Color.fromRGBO(0, 0, 0, 0.4),
                BlendMode.darken,
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: ColorsUtility.mainBackgroundColor.withAlpha(
                  (0.2 * 255).round(),
                ),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              SizedBox(width: 12),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        S.of(context).reserveCardTitle,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: ColorsUtility.onboardingColor,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        S.of(context).reserveCardDescription,
                        style: TextStyle(
                          fontSize: 14,
                          color: ColorsUtility.onboardingColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: ColorsUtility.onboardingColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
