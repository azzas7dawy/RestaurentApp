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
  Color _couponMessageColor = ColorsUtility.progressIndictorColor;

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
        _couponMessageColor = ColorsUtility.errorSnackbarColor;
      });
      return;
    }

    if (couponCode == 'iti10') {
      setState(() {
        _discountAmount = totalPrice * 0.1;
        _isCouponApplied = true;
        _couponMessage = S.of(context).validCoupon;
        _couponMessageColor = ColorsUtility.successSnackbarColor;
      });
    } else if (couponCode == 'iti20') {
      setState(() {
        _discountAmount = totalPrice * 0.2;
        _isCouponApplied = true;
        _couponMessage = S.of(context).validCoupon;
        _couponMessageColor = ColorsUtility.successSnackbarColor;
      });
    } else {
      setState(() {
        _discountAmount = 0.0;
        _isCouponApplied = false;
        _couponMessage = S.of(context).invalidCoupon;
        _couponMessageColor = ColorsUtility.errorSnackbarColor;
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
        backgroundColor: ColorsUtility.errorSnackbarColor,
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
    final totalPrice = ModalRoute.of(context)!.settings.arguments as double? ??
        widget.initialTotal;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          S.of(context).paymentMethod,
          style: TextStyle(color: ColorsUtility.takeAwayColor),
        ),
        iconTheme: const IconThemeData(
          color: ColorsUtility.takeAwayColor,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacementNamed(context, OrdersScreen.id);
          },
        ),
      ),
      body: BlocBuilder<OrdersCubit, OrdersState>(
        builder: (context, state) {
          // final cubit = context.read<OrdersCubit>();
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
                        style: TextStyle(
                          fontSize: 14,
                          color: ColorsUtility.textFieldLabelColor,
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
                        title: S.of(context).paypalTxt,
                        subtitle: S.of(context).paypalSubtitle,
                        value: "paypal",
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          S.of(context).applyCoupon,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: ColorsUtility.textFieldLabelColor,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: ColorsUtility.elevatedBtnColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: TextField(
                      style: const TextStyle(
                          color: ColorsUtility.textFieldLabelColor),
                      controller: _couponController,
                      decoration: InputDecoration(
                        hintText: S.of(context).enterCouponCode,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: ColorsUtility.progressIndictorColor,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: ColorsUtility.onboardingDescriptionColor,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: ColorsUtility.takeAwayColor,
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
                          color: ColorsUtility.takeAwayColor,
                        )
                      : Expanded(
                          flex: 1,
                          child: SizedBox(
                            height: 45,
                            child: ElevatedButton(
                              onPressed: () => _applyCoupon(totalPrice),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: ColorsUtility.takeAwayColor,
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
                                    color: ColorsUtility.onboardingColor),
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
          color: ColorsUtility.elevatedBtnColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _selectedPaymentMethod == value
                ? ColorsUtility.takeAwayColor
                : ColorsUtility.mainBackgroundColor,
            width: _selectedPaymentMethod == value ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: ColorsUtility.takeAwayColor.withAlpha(26),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: ColorsUtility.takeAwayColor,
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
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: ColorsUtility.takeAwayColor),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 14,
                      color: ColorsUtility.progressIndictorColor,
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
              activeColor: ColorsUtility.takeAwayColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderSummary(
      BuildContext context, double totalPrice, double finalPrice) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          S.of(context).orderSummary,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: ColorsUtility.textFieldLabelColor,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: ColorsUtility.elevatedBtnColor,
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
              const Divider(height: 1),
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            color: ColorsUtility.progressIndictorColor,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            color: isDiscount
                ? ColorsUtility.successSnackbarColor
                : ColorsUtility.textFieldLabelColor,
          ),
        ),
      ],
    );
  }
}
