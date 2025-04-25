import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restrant_app/cubit/OrdersLogic/cubit/orders_cubit.dart';
import 'package:restrant_app/generated/l10n.dart';
import 'package:restrant_app/screens/customScreen/custom_screen.dart';
import 'package:restrant_app/screens/paymentScreen/payment_screen.dart';
import 'package:restrant_app/utils/colors_utility.dart';
import 'package:restrant_app/widgets/app_confirmation_dialog.dart';
import 'package:restrant_app/widgets/app_elevated_btn_widget.dart';
import 'package:restrant_app/widgets/app_snackbar.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});
  static const String id = 'OrdersScreen';

  bool isArabic(BuildContext context) {
    return Localizations.localeOf(context).languageCode == 'ar';
  }

  @override
  Widget build(BuildContext context) {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';
    final theme = Theme.of(context);
    final isDarkTheme = theme.brightness == Brightness.dark;

    return BlocProvider(
      create: (context) => OrdersCubit(
        firestore: FirebaseFirestore.instance,
        userId: currentUserId,
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            S.of(context).yourOrders,
            style: TextStyle(color: ColorsUtility.takeAwayColor),
          ),
          iconTheme: const IconThemeData(
            color: ColorsUtility.takeAwayColor,
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushReplacementNamed(
                context,
                CustomScreen.id,
              );
            },
          ),
          centerTitle: true,
          backgroundColor: theme.scaffoldBackgroundColor,
        ),
        backgroundColor: theme.scaffoldBackgroundColor,
        body: BlocConsumer<OrdersCubit, OrdersState>(
          listener: (context, state) {
            if (state is OrdersSubmissionSuccess) {
              appSnackbar(
                context,
                text: S.of(context).orderSubmit,
                backgroundColor: ColorsUtility.successSnackbarColor,
              );
            }
            if (state is OrdersSubmissionError) {
              appSnackbar(
                context,
                text: state.errorMessage,
                backgroundColor: ColorsUtility.errorSnackbarColor,
              );
            }
          },
          builder: (context, state) {
            if (state is OrdersLoading) {
              return const Center(
                child: CircularProgressIndicator(
                    color: ColorsUtility.progressIndictorColor),
              );
            }

            final cubit = context.read<OrdersCubit>();
            final meals = state is OrdersLoaded ? state.meals : cubit.meals;

            return Column(
              children: [
                Expanded(
                  child: meals.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.food_bank_outlined,
                                size: 60,
                                color: ColorsUtility.progressIndictorColor
                                    .withAlpha(128),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                S.of(context).noOrders,
                                style: TextStyle(
                                  fontSize: 18,
                                  color: ColorsUtility.takeAwayColor,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                S.of(context).noMealsAdded,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: ColorsUtility.textFieldLabelColor
                                      .withAlpha(128),
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          itemCount: meals.length,
                          itemBuilder: (context, index) {
                            final meal = meals[index];
                            final quantity = meal['quantity'] ?? 1;

                            return Card(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              color: isDarkTheme
                                  ? ColorsUtility.elevatedBtnColor
                                  : ColorsUtility.lightTextFieldFillColor,
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Image.network(
                                      meal['image'] ?? '',
                                      width: 80,
                                      height: 80,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              const Icon(Icons.error),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            isArabic(context)
                                                ? meal['title_ar'] ??
                                                    meal['title'] ??
                                                    'No Title'
                                                : meal['title'] ?? 'No Title',
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color:
                                                  ColorsUtility.takeAwayColor,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            '${meal['price'] ?? 0} ${S.of(context).egp}',
                                            style: const TextStyle(
                                              color: ColorsUtility
                                                  .progressIndictorColor,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Row(
                                            children: isArabic(context)
                                                ? [
                                                    IconButton(
                                                      onPressed: () =>
                                                          _showDeleteConfirmationDialog(
                                                              context, index),
                                                      icon: const Icon(
                                                          Icons.delete),
                                                      color: ColorsUtility
                                                          .errorSnackbarColor,
                                                    ),
                                                    const Spacer(),
                                                    IconButton(
                                                      onPressed: () {
                                                        final newQuantity =
                                                            quantity + 1;
                                                        cubit
                                                            .updateMealQuantity(
                                                                index,
                                                                newQuantity);
                                                      },
                                                      icon:
                                                          const Icon(Icons.add),
                                                      iconSize: 20,
                                                      color: ColorsUtility
                                                          .progressIndictorColor,
                                                    ),
                                                    Text(
                                                      '$quantity',
                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                        color: ColorsUtility
                                                            .progressIndictorColor,
                                                      ),
                                                    ),
                                                    IconButton(
                                                      onPressed: () {
                                                        final newQuantity =
                                                            quantity - 1;
                                                        if (newQuantity >= 1) {
                                                          cubit
                                                              .updateMealQuantity(
                                                                  index,
                                                                  newQuantity);
                                                        }
                                                      },
                                                      icon: const Icon(
                                                          Icons.remove),
                                                      iconSize: 20,
                                                      color: ColorsUtility
                                                          .progressIndictorColor,
                                                    ),
                                                  ]
                                                : [
                                                    IconButton(
                                                      onPressed: () {
                                                        final newQuantity =
                                                            quantity - 1;
                                                        if (newQuantity >= 1) {
                                                          cubit
                                                              .updateMealQuantity(
                                                                  index,
                                                                  newQuantity);
                                                        }
                                                      },
                                                      icon: const Icon(
                                                          Icons.remove),
                                                      iconSize: 20,
                                                      color: ColorsUtility
                                                          .progressIndictorColor,
                                                    ),
                                                    Text(
                                                      '$quantity',
                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                        color: ColorsUtility
                                                            .progressIndictorColor,
                                                      ),
                                                    ),
                                                    IconButton(
                                                      onPressed: () {
                                                        final newQuantity =
                                                            quantity + 1;
                                                        cubit
                                                            .updateMealQuantity(
                                                                index,
                                                                newQuantity);
                                                      },
                                                      icon:
                                                          const Icon(Icons.add),
                                                      iconSize: 20,
                                                      color: ColorsUtility
                                                          .progressIndictorColor,
                                                    ),
                                                    const Spacer(),
                                                    IconButton(
                                                      onPressed: () =>
                                                          _showDeleteConfirmationDialog(
                                                              context, index),
                                                      icon: const Icon(
                                                          Icons.delete),
                                                      color: ColorsUtility
                                                          .errorSnackbarColor,
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
                if (meals.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              S.of(context).totalPrice,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: ColorsUtility.progressIndictorColor,
                              ),
                            ),
                            Text(
                              '${cubit.calculateTotal().toStringAsFixed(2)} ${S.of(context).egp}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: ColorsUtility.progressIndictorColor,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        AppElevatedBtn(
                          onPressed: () {
                            final total = cubit.calculateTotal();
                            Navigator.pushNamed(
                              context,
                              PaymentScreen.id,
                              arguments: total,
                            );
                          },
                          text: S.of(context).payBtn,
                        ),
                      ],
                    ),
                  )
              ],
            );
          },
        ),
      ),
    );
  }

  Future<void> _showDeleteConfirmationDialog(
      BuildContext context, int index) async {
    await AppConfirmationDialog.show(
      context: context,
      title: S.of(context).confirmRemoval,
      message: S.of(context).removeMeal,
      confirmText: S.of(context).remove,
      onConfirm: () {
        context.read<OrdersCubit>().removeMeal(index);
      },
    );
  }
}
