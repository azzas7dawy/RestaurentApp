import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restrant_app/cubit/OrdersLogic/cubit/orders_cubit.dart';
import 'package:restrant_app/utils/colors_utility.dart';
import 'package:restrant_app/widgets/app_confirmation_dialog.dart';
import 'package:restrant_app/widgets/app_elevated_btn_widget.dart';
import 'package:restrant_app/widgets/app_snackbar.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});
  static const String id = 'OrdersScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Your Orders',
          style: TextStyle(color: ColorsUtility.takeAwayColor),
        ),
        iconTheme: const IconThemeData(
          color: ColorsUtility.takeAwayColor,
        ),
      ),
      body: BlocConsumer<OrdersCubit, OrdersState>(
        listener: (context, state) {
          if (state is OrdersSubmissionSuccess) {
            appSnackbar(
              context,
              text: 'Order submitted successfully',
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
                color: ColorsUtility.progressIndictorColor,
              ),
            );
          }

          final cubit = context.read<OrdersCubit>();
          final meals = cubit.meals;

          return Column(
            children: [
              Expanded(
                child: meals.isEmpty
                    ? const Center(
                        child: Text(
                          'No meals added yet',
                          style: TextStyle(
                            color: ColorsUtility.progressIndictorColor,
                          ),
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
                            color: ColorsUtility.elevatedBtnColor,
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Image.network(
                                    meal['image'],
                                    width: 80,
                                    height: 80,
                                    fit: BoxFit.cover,
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          meal['title'],
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: ColorsUtility.takeAwayColor,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '${meal['price']} EGP',
                                          style: const TextStyle(
                                            color: ColorsUtility
                                                .progressIndictorColor,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          children: [
                                            IconButton(
                                              onPressed: () => cubit
                                                  .decrementQuantity(index),
                                              icon: const Icon(Icons.remove),
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
                                              onPressed: () => cubit
                                                  .incrementQuantity(index),
                                              icon: const Icon(Icons.add),
                                              iconSize: 20,
                                              color: ColorsUtility
                                                  .progressIndictorColor,
                                            ),
                                            const Spacer(),
                                            IconButton(
                                              onPressed: () =>
                                                  _showDeleteConfirmationDialog(
                                                      context, index),
                                              icon: const Icon(Icons.delete),
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
                          const Text(
                            'Total Price:',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: ColorsUtility.progressIndictorColor,
                            ),
                          ),
                          Text(
                            '${cubit.calculateTotal().toStringAsFixed(2)} EGP',
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
                        onPressed: () => cubit.submitOrder(),
                        text: 'Proceed to Payment',
                      ),
                    ],
                  ),
                )
            ],
          );
        },
      ),
    );
  }

  Future<void> _showDeleteConfirmationDialog(
      BuildContext context, int index) async {
    await CustomConfirmationDialog.show(
      context: context,
      title: 'Confirm Removal',
      message: 'Are you sure you want to remove this meal?',
      confirmText: 'Remove',
      onConfirm: () {
        context.read<OrdersCubit>().removeMeal(index);
      },
    );
  }
}
