import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restrant_app/cubit/OrdersLogic/cubit/orders_cubit.dart';
import 'package:restrant_app/generated/l10n.dart';
import 'package:restrant_app/screens/ordersScreen/orders_screen.dart';
import 'package:restrant_app/screens/paymentScreen/complete_payment_screen.dart';
import 'package:restrant_app/utils/colors_utility.dart';
import 'package:restrant_app/widgets/app_elevated_btn_widget.dart';
import 'package:restrant_app/widgets/app_snackbar.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({
    super.key,
    required this.initialTotal,
  });
  static const String id = 'PaymentScreen';
  final double initialTotal;

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String? _selectedPaymentMethod;
  final TextEditingController _couponController = TextEditingController();
  double _discountAmount = 0.0;
  bool _isCouponApplied = false;
  String _couponMessage = '';
  Color _couponMessageColor = Colors.green;

  @override
  void dispose() {
    _couponController.dispose();
    super.dispose();
  }

  void _applyCoupon(double totalPrice) {
    final couponCode = _couponController.text.trim();

    if (couponCode.isEmpty) {
      setState(() {
        _couponMessage = S.of(context).enterCoupon;
        _couponMessageColor = Theme.of(context).colorScheme.error;
      });
      return;
    }

    if (couponCode == 'iti10') {
      setState(() {
        _discountAmount = totalPrice * 0.1;
        _isCouponApplied = true;
        _couponMessage = S.of(context).validCoupon;
        _couponMessageColor = Colors.green;
      });
    } else if (couponCode == 'iti20') {
      setState(() {
        _discountAmount = totalPrice * 0.2;
        _isCouponApplied = true;
        _couponMessage = S.of(context).validCoupon;
        _couponMessageColor = Colors.green;
      });
    } else {
      setState(() {
        _discountAmount = 0.0;
        _isCouponApplied = false;
        _couponMessage = S.of(context).invalidCoupon;
        _couponMessageColor = Theme.of(context).colorScheme.error;
      });
    }
  }

  void _removeCoupon() {
    setState(() {
      _couponController.clear();
      _discountAmount = 0.0;
      _isCouponApplied = false;
      _couponMessage = '';
    });
  }

  void _handleContinueButton(double totalPrice) {
    if (_selectedPaymentMethod == null) {
      appSnackbar(
        context,
        text: S.of(context).payMethod,
        backgroundColor: Theme.of(context).colorScheme.error,
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CompletePaymentScreen(
            paymentMethod: _selectedPaymentMethod!,
            totalAmount: totalPrice - _discountAmount,
            discountAmount: _discountAmount,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final totalPrice = ModalRoute.of(context)!.settings.arguments as double? ??
        widget.initialTotal;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          S.of(context).paymentMethod,
          style: TextStyle(color: colorScheme.secondary),
        ),
        iconTheme: IconThemeData(color: colorScheme.secondary),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacementNamed(context, OrdersScreen.id);
          },
        ),
      ),
      body: BlocBuilder<OrdersCubit, OrdersState>(
        builder: (context, state) {
          final finalPrice = totalPrice - _discountAmount;

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        S.of(context).favPayMethod,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.textTheme.bodyMedium?.color
                              ?.withOpacity(0.7),
                        ),
                      ),
                      const SizedBox(height: 24),
                      _buildPaymentMethodCard(
                        context,
                        icon: Icons.money,
                        title: S.of(context).cashOnDelivery,
                        subtitle: S.of(context).cashTxt,
                        value: "cash",
                      ),
                      const SizedBox(height: 16),
                      _buildPaymentMethodCard(
                        context,
                        icon: Icons.payment,
                        title: S.of(context).paymobTxt,
                        subtitle: S.of(context).paymobSubtitle,
                        value: "paymob",
                      ),
                      const SizedBox(height: 24),
                      _buildCouponSection(context, totalPrice),
                      const SizedBox(height: 24),
                      _buildOrderSummary(context, totalPrice, finalPrice),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: AppElevatedBtn(
                  onPressed: () => _handleContinueButton(totalPrice),
                  text: S.of(context).continueBtn,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCouponSection(BuildContext context, double totalPrice) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          S.of(context).applyCoupon,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: TextField(
                      style:
                          TextStyle(color: theme.textTheme.bodyMedium?.color),
                      controller: _couponController,
                      decoration: InputDecoration(
                        hintText: S.of(context).enterCouponCode,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: colorScheme.primary.withOpacity(0.5),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: theme.dividerColor,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: colorScheme.secondary,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  _isCouponApplied
                      ? IconButton(
                          onPressed: _removeCoupon,
                          icon: const Icon(Icons.close),
                          color: colorScheme.secondary,
                        )
                      : Expanded(
                          flex: 1,
                          child: SizedBox(
                            height: 45,
                            child: ElevatedButton(
                              onPressed: () => _applyCoupon(totalPrice),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: colorScheme.secondary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                  horizontal: 16,
                                ),
                              ),
                              child: Text(
                                S.of(context).apply,
                                style: TextStyle(
                                    color: theme.colorScheme.onSecondary),
                              ),
                            ),
                          ),
                        ),
                ],
              ),
              if (_couponMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    _couponMessage,
                    style: TextStyle(
                      color: _couponMessageColor,
                      fontSize: 14,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentMethodCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required String value,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return InkWell(
      onTap: () {
        setState(() {
          _selectedPaymentMethod = value;
        });
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _selectedPaymentMethod == value
                ? colorScheme.secondary
                : theme.cardColor,
            width: _selectedPaymentMethod == value ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: colorScheme.secondary.withAlpha(26),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: colorScheme.secondary,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.secondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color:
                          theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
            Radio<String>(
              value: value,
              groupValue: _selectedPaymentMethod,
              onChanged: (String? value) {
                setState(() {
                  _selectedPaymentMethod = value;
                });
              },
              activeColor: colorScheme.secondary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderSummary(
      BuildContext context, double totalPrice, double finalPrice) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          S.of(context).orderSummary,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              _buildSummaryRow(S.of(context).subtotal,
                  '${totalPrice.toStringAsFixed(2)} ${S.of(context).egp}'),
              const SizedBox(height: 8),
              _buildSummaryRow(S.of(context).fees, '0.00 ${S.of(context).egp}'),
              if (_isCouponApplied) ...[
                const SizedBox(height: 8),
                _buildSummaryRow(
                  S.of(context).discount,
                  '-${_discountAmount.toStringAsFixed(2)} ${S.of(context).egp}',
                  isDiscount: true,
                ),
              ],
              const SizedBox(height: 8),
              Divider(height: 1, color: theme.dividerColor),
              const SizedBox(height: 8),
              _buildSummaryRow(
                S.of(context).total,
                '${finalPrice.toStringAsFixed(2)} ${S.of(context).egp}',
                isTotal: true,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryRow(String label, String value,
      {bool isTotal = false, bool isDiscount = false}) {
    final theme = Theme.of(context);
    // final colorScheme = theme.colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
          ),
        ),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            color: isDiscount
                ? ColorsUtility.successSnackbarColor
                : theme.textTheme.bodyMedium?.color,
          ),
        ),
      ],
    );
  }
}
