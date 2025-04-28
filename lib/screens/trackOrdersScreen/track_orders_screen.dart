import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restrant_app/cubit/OrdersLogic/cubit/orders_cubit.dart';
import 'package:restrant_app/generated/l10n.dart';
import 'package:restrant_app/screens/customScreen/custom_screen.dart';
import 'package:restrant_app/utils/colors_utility.dart';
import 'package:intl/intl.dart';
import 'package:restrant_app/widgets/app_snackbar.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class TrackOrdersScreen extends StatelessWidget {
  const TrackOrdersScreen({super.key});
  static const String id = 'TrackOrdersScreen';

  bool _isArabic(BuildContext context) {
    return Localizations.localeOf(context).languageCode == 'ar';
  }

  String _translatePaymentMethod(String method, BuildContext context) {
    switch (method.toLowerCase()) {
      case 'cash':
        return S.of(context).cash;
      case 'credit':
        return S.of(context).paymobTxt;
      default:
        return method;
    }
  }

  String _getItemTitle(Map<String, dynamic> item, BuildContext context) {
    final isArabic = _isArabic(context);
    if (isArabic) {
      return item['title_ar'] ?? item['title'] ?? '';
    } else {
      return item['title'] ?? '';
    }
  }

  String _getTranslatedStatus(String status, BuildContext context) {
    if (_isArabic(context)) {
      switch (status.toLowerCase()) {
        case 'pending':
          return 'معلق';
        case 'accepted':
          return 'مقبول';
        case 'rejected':
          return 'مرفوض';
        case 'cancelled':
          return 'ملغى';
        case 'failed':
          return 'فشل';
        default:
          return status;
      }
    } else {
      return _capitalizeFirstLetter(status);
    }
  }

  String _getTranslatedTrackingStatus(String status, BuildContext context) {
    if (_isArabic(context)) {
      switch (status.toLowerCase()) {
        case 'order_placed':
          return 'تم تقديم الطلب';
        case 'processing':
          return 'قيد التجهيز';
        case 'out_for_delivery':
          return 'في الطريق';
        case 'delivered':
          return 'تم التسليم';
        default:
          return status;
      }
    } else {
      return _capitalizeFirstLetter(status);
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';
    final theme = Theme.of(context);
    final isDarkTheme = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          S.of(context).trackYourOrders,
          style: TextStyle(
            fontSize: 20,
            color: theme.colorScheme.primary,
          ),
        ),
        iconTheme: IconThemeData(
          color: theme.colorScheme.primary,
        ),
        backgroundColor: theme.scaffoldBackgroundColor,
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
      backgroundColor: theme.scaffoldBackgroundColor,
      body: BlocBuilder<OrdersCubit, OrdersState>(
        builder: (context, state) {
          if (state is OrdersLoading) {
            return Center(
              child: CircularProgressIndicator(
                color: theme.colorScheme.primary,
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
                    style: TextStyle(
                      color: ColorsUtility.errorSnackbarColor,
                    ),
                  ),
                );
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(
                    color: theme.colorScheme.primary,
                  ),
                );
              }

              if (snapshot.data!.docs.isEmpty) {
                return AnimationConfiguration.synchronized(
                  duration: const Duration(milliseconds: 300),
                  child: SlideAnimation(
                    verticalOffset: 50.0,
                    child: FadeInAnimation(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.receipt_long,
                              size: 60,
                              color: ColorsUtility.errorSnackbarColor
                                  .withAlpha(128),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              S.of(context).noOrdersYet,
                              style: TextStyle(
                                fontSize: 18,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              S.of(context).yourOrdersWillAppearHere,
                              style: TextStyle(
                                fontSize: 14,
                                color: ColorsUtility.textFieldLabelColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }

              return AnimationLimiter(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final order = snapshot.data!.docs[index];
                    final data = order.data() as Map<String, dynamic>;
                    final items = List<Map<String, dynamic>>.from(
                        data['orderItems'] ?? []);
                    final total = data['total'] ?? 0.0;
                    final orderStatus = data['status'] ?? 'pending';
                    final trackStatus =
                        data['trackingStatus'] ?? 'order_placed';
                    final timestamp =
                        data['timestamp']?.toDate() ?? DateTime.now();
                    final paymentMethod = data['paymentMethod'] ?? 'cash';
                    final shipping = data['shipping'] ?? {};
                    final phoneNumber = data['phoneNumber'] ?? '';

                    return AnimationConfiguration.staggeredList(
                      position: index,
                      duration: const Duration(milliseconds: 500),
                      child: SlideAnimation(
                        verticalOffset: 50.0,
                        child: FadeInAnimation(
                          child: GestureDetector(
                            onTap: () {
                              _showOrderDetailsBottomSheet(
                                context,
                                orderId: order.id,
                                items: items,
                                total: total,
                                orderStatus: orderStatus,
                                trackStatus: trackStatus,
                                timestamp: timestamp,
                                paymentMethod: paymentMethod,
                                shipping: shipping,
                                phoneNumber: phoneNumber,
                              );
                            },
                            child: Card(
                              color: isDarkTheme
                                  ? ColorsUtility.elevatedBtnColor
                                  : ColorsUtility.lightMainBackgroundColor,
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '${S.of(context).order} #${order.id.substring(0, 8).toUpperCase()}',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: ColorsUtility
                                                .errorSnackbarColor,
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 6,
                                          ),
                                          decoration: BoxDecoration(
                                            color: _getOrderStatusColor(
                                                    orderStatus)
                                                .withAlpha(51),
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            border: Border.all(
                                              color: _getOrderStatusColor(
                                                  orderStatus),
                                            ),
                                          ),
                                          child: Text(
                                            _getTranslatedStatus(
                                                orderStatus, context),
                                            style: TextStyle(
                                              color: _getOrderStatusColor(
                                                  orderStatus),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          DateFormat('MMM dd, yyyy - hh:mm a')
                                              .format(timestamp),
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: ColorsUtility
                                                .lightOnboardingDescriptionColor,
                                          ),
                                        ),
                                        if (orderStatus.toLowerCase() ==
                                            'pending') ...[
                                          IconButton(
                                            onPressed: () {
                                              _showCancelConfirmationDialog(
                                                  context, order.id);
                                            },
                                            icon: const Icon(
                                              Icons.delete,
                                              color: ColorsUtility
                                                  .errorSnackbarColor,
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      '${items.fold(0, (sum, item) => sum + (item['quantity'] as int))} ${S.of(context).item}${items.length > 1 && !_isArabic(context) ? 's' : ''}',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: isDarkTheme
                                            ? ColorsUtility.textFieldLabelColor
                                            : ColorsUtility
                                                .lightTextFieldLabelColor,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${S.of(context).total2} ${total.toStringAsFixed(2)} ${S.of(context).egp}',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: theme.colorScheme.primary,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    _buildTrackStatusIndicator(
                                        trackStatus, context),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showCancelConfirmationDialog(BuildContext context, String orderId) {
    final theme = Theme.of(context);
    final isDarkTheme = theme.brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AnimationConfiguration.staggeredList(
          position: 0,
          duration: const Duration(milliseconds: 375),
          child: SlideAnimation(
            verticalOffset: 50.0,
            child: FadeInAnimation(
              child: AlertDialog(
                backgroundColor: isDarkTheme
                    ? ColorsUtility.elevatedBtnColor
                    : ColorsUtility.lightMainBackgroundColor,
                title: Text(
                  S.of(context).cancelOrder,
                  style: TextStyle(
                    color: theme.colorScheme.primary,
                  ),
                ),
                content: Text(
                  S.of(context).cancelOrderMessage,
                  style: TextStyle(
                    color: isDarkTheme
                        ? ColorsUtility.onboardingColor
                        : ColorsUtility.lightTextFieldLabelColor,
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(dialogContext).pop(),
                    child: Text(
                      S.of(context).no,
                      style: TextStyle(
                        color: isDarkTheme
                            ? ColorsUtility.onboardingColor
                            : ColorsUtility.lightTextFieldLabelColor,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      Navigator.of(dialogContext).pop();
                      await _deleteOrder(context, orderId);
                    },
                    child: Text(
                      S.of(context).yes,
                      style: TextStyle(
                        color: ColorsUtility.errorSnackbarColor,
                      ),
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

  Future<void> _deleteOrder(BuildContext context, String orderId) async {
    try {
      final ordersCubit = context.read<OrdersCubit>();
      await ordersCubit.deleteOrder(orderId);
      if (context.mounted) {
        appSnackbar(
          context,
          text: S.of(context).orderCancelled,
          backgroundColor: ColorsUtility.successSnackbarColor,
        );
      }
    } catch (e) {
      if (context.mounted) {
        appSnackbar(
          context,
          text: '${S.of(context).orderCancelFailed} $e',
          backgroundColor: ColorsUtility.errorSnackbarColor,
        );
      }
    }
  }

  Widget _buildTrackStatusIndicator(String trackStatus, BuildContext context) {
    return AnimationConfiguration.synchronized(
      duration: const Duration(milliseconds: 300),
      child: SlideAnimation(
        horizontalOffset: 50.0,
        child: FadeInAnimation(
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _getTrackStatusColor(trackStatus).withAlpha(26),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: _getTrackStatusColor(trackStatus),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  _getTrackStatusIcon(trackStatus),
                  color: _getTrackStatusColor(trackStatus),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '${S.of(context).trackStatus} ${_getTranslatedTrackingStatus(trackStatus, context)}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: _getTrackStatusColor(trackStatus),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getOrderStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return ColorsUtility.progressIndictorColor;
      case 'accepted':
        return ColorsUtility.successSnackbarColor;
      case 'rejected':
        return ColorsUtility.errorSnackbarColor;
      case 'cancelled':
        return ColorsUtility.errorSnackbarColor;
      case 'failed':
        return ColorsUtility.failedStatusColor;
      default:
        return ColorsUtility.takeAwayColor;
    }
  }

  Color _getTrackStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'order_placed':
        return ColorsUtility.progressIndictorColor;
      case 'processing':
        return ColorsUtility.processingStatusColor;
      case 'out_for_delivery':
        return ColorsUtility.onTheWayStatusColor;
      case 'delivered':
        return ColorsUtility.successSnackbarColor;
      default:
        return ColorsUtility.takeAwayColor;
    }
  }

  String _capitalizeFirstLetter(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).replaceAll('_', ' ');
  }

  void _showOrderDetailsBottomSheet(
    BuildContext context, {
    required String orderId,
    required List<Map<String, dynamic>> items,
    required double total,
    required String orderStatus,
    required String trackStatus,
    required DateTime timestamp,
    required String paymentMethod,
    required dynamic shipping,
    required String phoneNumber,
  }) {
    final theme = Theme.of(context);
    final isDarkTheme = theme.brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return AnimationConfiguration.synchronized(
          duration: const Duration(milliseconds: 400),
          child: SlideAnimation(
            verticalOffset: 50.0,
            child: FadeInAnimation(
              child: Container(
                decoration: BoxDecoration(
                  color: isDarkTheme
                      ? ColorsUtility.elevatedBtnColor
                      : ColorsUtility.lightMainBackgroundColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                padding: const EdgeInsets.only(
                  bottom: 20,
                  left: 16,
                  right: 16,
                  top: 16,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: AnimationConfiguration.toStaggeredList(
                      duration: const Duration(milliseconds: 300),
                      childAnimationBuilder: (widget) => SlideAnimation(
                        horizontalOffset: 50.0,
                        child: FadeInAnimation(
                          child: widget,
                        ),
                      ),
                      children: [
                        Center(
                          child: Container(
                            width: 40,
                            height: 4,
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              S.of(context).orderDetails,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () => Navigator.pop(context),
                              color: theme.colorScheme.primary,
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color:
                                _getOrderStatusColor(orderStatus).withAlpha(26),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: _getOrderStatusColor(orderStatus),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                _getOrderStatusIcon(orderStatus),
                                color: _getOrderStatusColor(orderStatus),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '${S.of(context).orderStatus} ${_getTranslatedStatus(orderStatus, context)}',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: _getOrderStatusColor(orderStatus),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color:
                                _getTrackStatusColor(trackStatus).withAlpha(26),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: _getTrackStatusColor(trackStatus),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                _getTrackStatusIcon(trackStatus),
                                color: _getTrackStatusColor(trackStatus),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '${S.of(context).trackStatus} ${_getTranslatedTrackingStatus(trackStatus, context)}',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: _getTrackStatusColor(trackStatus),
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
                              '${S.of(context).orderId} #${orderId.substring(0, 8).toUpperCase()}',
                              style: TextStyle(
                                fontSize: 14,
                                color: ColorsUtility.failedStatusColor,
                              ),
                            ),
                            if (orderStatus.toLowerCase() == 'pending') ...[
                              IconButton(
                                onPressed: () {
                                  Navigator.of(context, rootNavigator: true)
                                      .pop();
                                  _showCancelConfirmationDialog(
                                      context, orderId);
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
                          '${S.of(context).orderedOn} ${DateFormat('MMM dd, yyyy - hh:mm a').format(timestamp)}',
                          style: TextStyle(
                            fontSize: 14,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          S.of(context).customer,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isDarkTheme
                                ? ColorsUtility.textFieldLabelColor
                                : ColorsUtility.lightTextFieldLabelColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          FirebaseAuth.instance.currentUser?.displayName ??
                              S.of(context).unknown,
                          style: TextStyle(
                            fontSize: 14,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          S.of(context).items,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isDarkTheme
                                ? ColorsUtility.textFieldLabelColor
                                : ColorsUtility.lightTextFieldLabelColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ...items.map((item) => Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      '${item['quantity']} x ${_getItemTitle(item, context)}',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: isDarkTheme
                                            ? ColorsUtility.textFieldLabelColor
                                            : ColorsUtility
                                                .lightTextFieldLabelColor,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    '${(item['price'] * item['quantity']).toStringAsFixed(2)} ${S.of(context).egp}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: theme.colorScheme.primary,
                                    ),
                                  ),
                                ],
                              ),
                            )),
                        const Divider(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${S.of(context).subtotal}:',
                              style: TextStyle(
                                fontSize: 14,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                            Text(
                              '${total.toStringAsFixed(2)} ${S.of(context).egp}',
                              style: TextStyle(
                                fontSize: 14,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${S.of(context).fees}:',
                              style: TextStyle(
                                fontSize: 14,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                            Text(
                              '0.00 ${S.of(context).egp}',
                              style: TextStyle(
                                fontSize: 14,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              S.of(context).total2,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                            Text(
                              '${total.toStringAsFixed(2)} ${S.of(context).egp}',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          '${S.of(context).paymentMethod}:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isDarkTheme
                                ? ColorsUtility.textFieldLabelColor
                                : ColorsUtility.lightTextFieldLabelColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _translatePaymentMethod(paymentMethod, context),
                          style: TextStyle(
                              fontSize: 14,
                              color: ColorsUtility.lightTextFieldLabelColor),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          S.of(context).deliveryInfo,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isDarkTheme
                                ? ColorsUtility.textFieldLabelColor
                                : ColorsUtility.lightTextFieldLabelColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${S.of(context).phone}: $phoneNumber',
                          style: TextStyle(
                            fontSize: 14,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${S.of(context).city}: ${shipping is Map ? shipping['city'] ?? 'N/A' : 'N/A'}',
                          style: TextStyle(
                            fontSize: 14,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${S.of(context).address}: ${shipping is Map ? shipping['details'] ?? 'N/A' : 'N/A'}',
                          style: TextStyle(
                            fontSize: 14,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  IconData _getOrderStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Icons.access_time;
      case 'accepted':
        return Icons.check_circle;
      case 'rejected':
        return Icons.cancel;
      case 'cancelled':
        return Icons.cancel;
      case 'failed':
        return Icons.error;
      default:
        return Icons.receipt;
    }
  }

  IconData _getTrackStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'order_placed':
        return Icons.shopping_bag;
      case 'processing':
        return Icons.restaurant;
      case 'out_for_delivery':
        return Icons.delivery_dining;
      case 'delivered':
        return Icons.check_circle;
      default:
        return Icons.receipt;
    }
  }
}
