import 'package:flutter/material.dart';

import '../../utils/colors_utility.dart';
import '../../widgets/app_elevated_btn_widget.dart';


class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key, this.orderedMeals});
  final List<Map<String, dynamic>>? orderedMeals;
  static const String id = 'OrdersScreen';

  static List<Map<String, dynamic>> allOrdersMeals = [];

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  void initState() {
    super.initState();
    // تحديث القائمة فقط إذا تم تمرير وجبات جديدة
    if (widget.orderedMeals != null) {
      OrdersScreen.allOrdersMeals = List.from(widget.orderedMeals!);
    }
  }

  void _incrementQuantity(int index) {
    setState(() {
      OrdersScreen.allOrdersMeals[index]['quantity'] =
          (OrdersScreen.allOrdersMeals[index]['quantity'] ?? 1) + 1;
    });
  }

  void _decrementQuantity(int index) {
    setState(() {
      final currentQuantity =
          OrdersScreen.allOrdersMeals[index]['quantity'] ?? 1;
      if (currentQuantity > 1) {
        OrdersScreen.allOrdersMeals[index]['quantity'] = currentQuantity - 1;
      }
    });
  }

  void _removeMeal(int index) {
    setState(() {
      OrdersScreen.allOrdersMeals.removeAt(index);
    });
  }

  double _calculateTotalPrice() {
    double total = 0;
    for (var meal in OrdersScreen.allOrdersMeals) {
      final price = meal['price'] is int
          ? (meal['price'] as int).toDouble()
          : meal['price'] as double;
      final quantity = meal['quantity'] ?? 1;
      total += price * quantity;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Your Orders',
          style: TextStyle(color: ColorsUtility.textFieldLabelColor),
        ),
        iconTheme: const IconThemeData(
          color: ColorsUtility.textFieldLabelColor,
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: OrdersScreen.allOrdersMeals.isEmpty
                ? const Center(
                    child: Text('No meals added to your order yet'),
                  )
                : ListView.builder(
                    itemCount: OrdersScreen.allOrdersMeals.length,
                    itemBuilder: (context, index) {
                      final meal = OrdersScreen.allOrdersMeals[index];
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                        color:
                                            ColorsUtility.progressIndictorColor,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        IconButton(
                                          onPressed: () =>
                                              _decrementQuantity(index),
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
                                          onPressed: () =>
                                              _incrementQuantity(index),
                                          icon: const Icon(Icons.add),
                                          iconSize: 20,
                                          color: ColorsUtility
                                              .progressIndictorColor,
                                        ),
                                        const Spacer(),
                                        IconButton(
                                          onPressed: () => _removeMeal(index),
                                          icon: const Icon(Icons.delete),
                                          color:
                                              ColorsUtility.errorSnackbarColor,
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
          if (OrdersScreen.allOrdersMeals.isNotEmpty)
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
                        '${_calculateTotalPrice().toStringAsFixed(2)} EGP',
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
                      // logic
                    },
                    text: 'Proceed to Payment',
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
