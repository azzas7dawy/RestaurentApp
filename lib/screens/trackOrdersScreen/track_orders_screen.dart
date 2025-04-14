import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restrant_app/cubit/OrdersLogic/cubit/orders_cubit.dart';
import 'package:restrant_app/screens/customScreen/custom_screen.dart';
import 'package:restrant_app/utils/colors_utility.dart';
import 'package:intl/intl.dart';
import 'package:restrant_app/widgets/app_snackbar.dart';

class TrackOrdersScreen extends StatelessWidget {
  const TrackOrdersScreen({super.key});
  static const String id = 'TrackOrdersScreen';

  @override
  Widget build(BuildContext context) {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Track Yours Orders',
          style: TextStyle(
            fontSize: 20,
            color: ColorsUtility.takeAwayColor,
          ),
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
      ),
      body: BlocBuilder<OrdersCubit, OrdersState>(
        builder: (context, state) {
          if (state is OrdersLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: ColorsUtility.takeAwayColor,
              ),
            );
          }

          return StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('orders')
                .where('userId', isEqualTo: currentUserId)
                .orderBy('timestamp', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'Error: ${snapshot.error}',
                    style: const TextStyle(
                      color: ColorsUtility.errorSnackbarColor,
                    ),
                  ),
                );
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: ColorsUtility.takeAwayColor,
                  ),
                );
              }

              if (snapshot.data!.docs.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.receipt_long,
                        size: 60,
                        color:
                            ColorsUtility.progressIndictorColor.withAlpha(128),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'No orders yet',
                        style: TextStyle(
                          fontSize: 18,
                          color: ColorsUtility.takeAwayColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Your orders will appear here',
                        style: TextStyle(
                          fontSize: 14,
                          color: ColorsUtility.progressIndictorColor
                              .withAlpha(179),
                        ),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final order = snapshot.data!.docs[index];
                  final data = order.data() as Map<String, dynamic>;
                  final items =
                      List<Map<String, dynamic>>.from(data['items'] ?? []);
                  final total = data['total'] ?? 0.0;
                  final status = data['status'] ?? 'pending';
                  final timestamp =
                      data['timestamp']?.toDate() ?? DateTime.now();
                  final paymentMethod = data['paymentMethod'] ?? 'cash';
                  final deliveryAddress = data['deliveryAddress'] ?? '';
                  final phoneNumber = data['phoneNumber'] ?? '';

                  return GestureDetector(
                    onTap: () {
                      _showOrderDetailsDialog(
                        context,
                        orderId: order.id,
                        items: items,
                        total: total,
                        status: status,
                        timestamp: timestamp,
                        paymentMethod: paymentMethod,
                        deliveryAddress: deliveryAddress ?? 'Unknown',
                        phoneNumber: phoneNumber ?? 'Unknown',
                      );
                    },
                    child: Card(
                      color: ColorsUtility.elevatedBtnColor,
                      margin: const EdgeInsets.only(bottom: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Order #${order.id.substring(0, 8).toUpperCase()}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: ColorsUtility.takeAwayColor,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color:
                                        _getStatusColor(status).withAlpha(51),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: _getStatusColor(status),
                                    ),
                                  ),
                                  child: Text(
                                    _capitalizeFirstLetter(status),
                                    style: TextStyle(
                                      color: _getStatusColor(status),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  DateFormat('MMM dd, yyyy - hh:mm a')
                                      .format(timestamp),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: ColorsUtility.progressIndictorColor,
                                  ),
                                ),
                                if (status == 'pending') ...[
                                  IconButton(
                                    onPressed: () {
                                      _showCancelConfirmationDialog(
                                          context, order.id);
                                    },
                                    icon: const Icon(
                                      Icons.delete,
                                      color: ColorsUtility.errorSnackbarColor,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              '${items.length} item${items.length > 1 ? 's' : ''}',
                              style: const TextStyle(
                                fontSize: 14,
                                color: ColorsUtility.textFieldLabelColor,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Total: ${total.toStringAsFixed(2)} EGP',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: ColorsUtility.takeAwayColor,
                              ),
                            ),
                            const SizedBox(height: 8),
                            _buildStatusIndicator(status),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

// ==============================================================================================================
  void _showCancelConfirmationDialog(BuildContext context, String orderId) {
    final scaffoldContext = context; // حفظ الـ context الأصلي

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: ColorsUtility.elevatedBtnColor,
          title: const Text(
            'Cancel Order',
            style: TextStyle(
              color: ColorsUtility.takeAwayColor,
            ),
          ),
          content: const Text(
            'Are you sure you want to cancel this order?',
            style: TextStyle(
              color: ColorsUtility.progressIndictorColor,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text(
                'No',
                style: TextStyle(
                  color: ColorsUtility.progressIndictorColor,
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(dialogContext).pop();
                await _cancelOrder(scaffoldContext, orderId);
              },
              child: const Text(
                'Yes',
                style: TextStyle(
                  color: ColorsUtility.failedStatusColor,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

// ==============================================================================================================
  Future<void> _cancelOrder(BuildContext context, String orderId) async {
    try {
      await FirebaseFirestore.instance
          .collection('orders')
          .doc(orderId)
          .update({'status': 'cancelled'});
      if (context.mounted) {
        appSnackbar(
          context,
          text: 'Order has been cancelled',
          backgroundColor: ColorsUtility.successSnackbarColor,
        );
      }
    } catch (e) {
      if (context.mounted) {
        appSnackbar(
          context,
          text: 'Failed to cancel order: $e',
          backgroundColor: ColorsUtility.errorSnackbarColor,
        );
      }
    }
  }

// ==============================================================================================================
  Widget _buildStatusIndicator(String status) {
    const activeColor = ColorsUtility.takeAwayColor;
    const inactiveColor = ColorsUtility.progressIndictorColor;
    const lineHeight = 2.0;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildStatusStep(
              'Pending',
              isActive: status != 'cancelled' && status != 'failed',
              isCompleted: status != 'pending',
            ),
            _buildStatusStep(
              'Processing',
              isActive: status == 'processing' ||
                  status == 'on_the_way' ||
                  status == 'delivered',
              isCompleted: status == 'on_the_way' || status == 'delivered',
            ),
            _buildStatusStep(
              'On the way',
              isActive: status == 'on_the_way' || status == 'delivered',
              isCompleted: status == 'delivered',
            ),
            _buildStatusStep(
              'Delivered',
              isActive: status == 'delivered',
              isCompleted: false,
            ),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Expanded(
              child: Container(
                height: lineHeight,
                color: status != 'pending' &&
                        status != 'cancelled' &&
                        status != 'failed'
                    ? activeColor
                    : inactiveColor,
              ),
            ),
            Container(
              width: 8,
              height: lineHeight,
              color: (status == 'processing' ||
                          status == 'on_the_way' ||
                          status == 'delivered') &&
                      status != 'cancelled' &&
                      status != 'failed'
                  ? activeColor
                  : inactiveColor,
            ),
            Expanded(
              child: Container(
                height: lineHeight,
                color: (status == 'on_the_way' || status == 'delivered') &&
                        status != 'cancelled' &&
                        status != 'failed'
                    ? activeColor
                    : inactiveColor,
              ),
            ),
            Container(
              width: 8,
              height: lineHeight,
              color: status == 'delivered' &&
                      status != 'cancelled' &&
                      status != 'failed'
                  ? activeColor
                  : inactiveColor,
            ),
            Expanded(
              child: Container(
                height: lineHeight,
                color: status == 'delivered' &&
                        status != 'cancelled' &&
                        status != 'failed'
                    ? activeColor
                    : inactiveColor,
              ),
            ),
          ],
        ),
      ],
    );
  }

// ==============================================================================================================
  Widget _buildStatusStep(String label,
      {required bool isActive, required bool isCompleted}) {
    return Column(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive
                ? ColorsUtility.takeAwayColor
                : ColorsUtility.progressIndictorColor.withAlpha(51),
            border: Border.all(
              color: isCompleted
                  ? ColorsUtility.takeAwayColor
                  : isActive
                      ? ColorsUtility.takeAwayColor
                      : ColorsUtility.progressIndictorColor,
              width: isCompleted ? 0 : 2,
            ),
          ),
          child: isCompleted
              ? const Icon(
                  Icons.check,
                  size: 16,
                  color: ColorsUtility.textFieldLabelColor,
                )
              : null,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: isActive
                ? ColorsUtility.takeAwayColor
                : ColorsUtility.progressIndictorColor,
          ),
        ),
      ],
    );
  }

// ==============================================================================================================
  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return ColorsUtility.progressIndictorColor;
      case 'processing':
        return ColorsUtility.processingStatusColor;
      case 'on_the_way':
        return ColorsUtility.onTheWayStatusColor;
      case 'delivered':
        return ColorsUtility.successSnackbarColor;
      case 'cancelled':
        return ColorsUtility.errorSnackbarColor;
      case 'failed':
        return ColorsUtility.failedStatusColor;
      default:
        return ColorsUtility.takeAwayColor;
    }
  }

// ==============================================================================================================
  String _capitalizeFirstLetter(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).replaceAll('_', ' ');
  }

// ==============================================================================================================
  void _showOrderDetailsDialog(
    BuildContext context, {
    required String orderId,
    required List<Map<String, dynamic>> items,
    required double total,
    required String status,
    required DateTime timestamp,
    required String paymentMethod,
    required String deliveryAddress,
    required String phoneNumber,
  }) {
    final scaffoldContext = context;

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: ColorsUtility.elevatedBtnColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          insetPadding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Order Details',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: ColorsUtility.takeAwayColor,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                        color: ColorsUtility.takeAwayColor,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: _getStatusColor(status).withAlpha(26),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: _getStatusColor(status),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          _getStatusIcon(status),
                          color: _getStatusColor(status),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Status: ${_capitalizeFirstLetter(status)}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: _getStatusColor(status),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Order ID: #${orderId.substring(0, 8).toUpperCase()}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: ColorsUtility.progressIndictorColor,
                        ),
                      ),
                      if (status == 'pending') ...[
                        IconButton(
                          onPressed: () {
                            Navigator.of(context, rootNavigator: true).pop();
                            _showCancelConfirmationDialog(
                                scaffoldContext, orderId);
                          },
                          icon: const Icon(
                            Icons.delete,
                            color: ColorsUtility.errorSnackbarColor,
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Ordered on ${DateFormat('MMM dd, yyyy - hh:mm a').format(timestamp)}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: ColorsUtility.progressIndictorColor,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Customer:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: ColorsUtility.textFieldLabelColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    FirebaseAuth.instance.currentUser?.displayName ?? 'Unknown',
                    style: const TextStyle(
                      fontSize: 14,
                      color: ColorsUtility.progressIndictorColor,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Items:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: ColorsUtility.textFieldLabelColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...items.map((item) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                '${item['quantity']} x ${item['title']}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: ColorsUtility.textFieldLabelColor,
                                ),
                              ),
                            ),
                            Text(
                              '${(item['price'] * item['quantity']).toStringAsFixed(2)} EGP',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: ColorsUtility.takeAwayColor,
                              ),
                            ),
                          ],
                        ),
                      )),
                  const Divider(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Subtotal:',
                        style: TextStyle(
                          fontSize: 14,
                          color: ColorsUtility.progressIndictorColor,
                        ),
                      ),
                      Text(
                        '${total.toStringAsFixed(2)} EGP',
                        style: const TextStyle(
                          fontSize: 14,
                          color: ColorsUtility.textFieldLabelColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Delivery Fee:',
                        style: TextStyle(
                          fontSize: 14,
                          color: ColorsUtility.progressIndictorColor,
                        ),
                      ),
                      Text(
                        '0.00 EGP',
                        style: TextStyle(
                          fontSize: 14,
                          color: ColorsUtility.textFieldLabelColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: ColorsUtility.textFieldLabelColor,
                        ),
                      ),
                      Text(
                        '${total.toStringAsFixed(2)} EGP',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: ColorsUtility.takeAwayColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Payment Method:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: ColorsUtility.textFieldLabelColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _capitalizeFirstLetter(paymentMethod),
                    style: const TextStyle(
                      fontSize: 14,
                      color: ColorsUtility.progressIndictorColor,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Delivery Information:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: ColorsUtility.textFieldLabelColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Phone: $phoneNumber',
                    style: const TextStyle(
                      fontSize: 14,
                      color: ColorsUtility.progressIndictorColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Address: $deliveryAddress',
                    style: const TextStyle(
                      fontSize: 14,
                      color: ColorsUtility.progressIndictorColor,
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

// ==============================================================================================================
  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'pending':
        return Icons.access_time;
      case 'processing':
        return Icons.restaurant;
      case 'on_the_way':
        return Icons.delivery_dining;
      case 'delivered':
        return Icons.check_circle;
      case 'cancelled':
        return Icons.cancel;
      case 'failed':
        return Icons.error;
      default:
        return Icons.receipt;
    }
  }
}
