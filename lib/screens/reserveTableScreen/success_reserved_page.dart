import 'package:flutter/material.dart';
import 'package:restrant_app/generated/l10n.dart';
import 'package:restrant_app/utils/colors_utility.dart';

void showReservationSuccess(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => const ReservationSuccessSheet(),
  );
}

class ReservationSuccessSheet extends StatelessWidget {
  const ReservationSuccessSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(
                    Icons.close,
                    color: textTheme.bodyLarge?.color,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Text(
                S.of(context).successReser,
                style: textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                S.of(context).tableReservedMessage,
                style: textTheme.bodyMedium?.copyWith(
                  color: textTheme.bodyMedium?.color?.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 30),
              Text(
                S.of(context).note,
                style: textTheme.bodySmall?.copyWith(
                  color: textTheme.bodySmall?.color?.withOpacity(0.6),
                ),
              ),
            ],
          ),

          // ✅ Success Circle with Icon
          Stack(
            alignment: Alignment.center,
            children: [
              // Fake sparkles (can be animated later)
              Positioned(
                top: 0,
                child: Icon(
                  Icons.star,
                  color: colorScheme.secondary,
                  size: 16,
                ),
              ),
              Positioned(
                left: 0,
                child: Icon(
                  Icons.circle,
                  color: colorScheme.secondary.withOpacity(0.8),
                  size: 10,
                ),
              ),
              Positioned(
                right: 0,
                child: Icon(
                  Icons.circle,
                  color: colorScheme.secondary.withOpacity(0.8),
                  size: 12,
                ),
              ),
              Positioned(
                bottom: 0,
                child: Icon(
                  Icons.star,
                  color: colorScheme.secondary,
                  size: 16,
                ),
              ),

              Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  color: ColorsUtility.successSnackbarColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check,
                  size: 50,
                  color: ColorsUtility.onboardingColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
