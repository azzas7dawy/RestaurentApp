import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_paypal_checkout/flutter_paypal_checkout.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:restrant_app/generated/l10n.dart';
import 'package:restrant_app/screens/ordersScreen/orders_screen.dart';
import 'package:restrant_app/screens/trackOrdersScreen/track_orders_screen.dart';
import 'package:restrant_app/utils/colors_utility.dart';
import 'package:restrant_app/utils/icons_utility.dart';
import 'package:restrant_app/widgets/app_elevated_btn_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restrant_app/cubit/OrdersLogic/cubit/orders_cubit.dart';

class CompletePaymentScreen extends StatefulWidget {
  const CompletePaymentScreen({
    super.key,
    required this.paymentMethod,
    required this.totalAmount,
    required this.discountAmount,
  });
  final String paymentMethod;
  final double totalAmount;
  final double discountAmount;
  static const String id = 'CompletePaymentScreen';

  @override
  State<CompletePaymentScreen> createState() => _CompletePaymentScreenState();
}

class _CompletePaymentScreenState extends State<CompletePaymentScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.paymentMethod == 'cash'
              ? S.of(context).cashOnDelivery
              : S.of(context).paypal,
          style: const TextStyle(
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
            Navigator.pushReplacementNamed(context, OrdersScreen.id);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: widget.paymentMethod == 'cash'
            ? _buildCashOnDeliveryContent()
            : _buildPayPalContent(),
      ),
    );
  }

  Widget _buildCashOnDeliveryContent() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            IconsUtility.cashOnDeliveryIcon,
            width: 100,
            height: 100,
            colorFilter: const ColorFilter.mode(
              ColorsUtility.progressIndictorColor,
              BlendMode.srcIn,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            '${S.of(context).txtp1} ${widget.totalAmount.toStringAsFixed(2)} ${S.of(context).egp} ${S.of(context).txtp2}',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: ColorsUtility.takeAwayColor,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Text(
            S.of(context).subTitle,
            style: TextStyle(
              fontSize: 16,
              color: ColorsUtility.progressIndictorColor,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextFormField(
              style: const TextStyle(color: ColorsUtility.onboardingColor),
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                floatingLabelBehavior: FloatingLabelBehavior.never,
                labelText: S.of(context).phoneLabel,
                labelStyle: const TextStyle(
                  color: ColorsUtility.textFieldLabelColor,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
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
                prefixIcon: const Icon(
                  Icons.phone,
                  color: ColorsUtility.takeAwayColor,
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return S.of(context).enterPhone;
                }
                if (!RegExp(r'^[0-9]{10,15}$').hasMatch(value)) {
                  return S.of(context).validPhone;
                }
                return null;
              },
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextFormField(
              style: const TextStyle(color: ColorsUtility.onboardingColor),
              controller: _addressController,
              keyboardType: TextInputType.streetAddress,
              maxLines: 3,
              decoration: InputDecoration(
                floatingLabelBehavior: FloatingLabelBehavior.never,
                labelText: S.of(context).deliveryAddress,
                labelStyle: const TextStyle(
                  color: ColorsUtility.textFieldLabelColor,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
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
                prefixIcon: const Icon(
                  Icons.location_on,
                  color: ColorsUtility.takeAwayColor,
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return S.of(context).enterAddress;
                }
                if (value.length < 10) {
                  return S.of(context).shortAddress;
                }
                return null;
              },
            ),
          ),
          const Spacer(),
          AppElevatedBtn(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                final phoneNumber = _phoneController.text;
                final address = _addressController.text;

                final ordersCubit = context.read<OrdersCubit>();

                ordersCubit.setDeliveryInfo(
                    phone: phoneNumber, address: address);

                await ordersCubit.submitOrder(
                  paymentMethod: 'cash',
                  totalAmount: widget.totalAmount,
                  discountAmount: widget.discountAmount,
                  isPaid: false,
                );

                if (mounted) {
                  Navigator.pushReplacementNamed(context, TrackOrdersScreen.id);
                }
              }
            },
            text: S.of(context).confirmOrder,
          ),
        ],
      ),
    );
  }

  Widget _buildPayPalContent() {
    return Column(
      children: [
        SvgPicture.asset(
          IconsUtility.paypalIcon,
          width: 100,
          height: 100,
          colorFilter: const ColorFilter.mode(
            ColorsUtility.progressIndictorColor,
            BlendMode.srcIn,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          '${S.of(context).totalAmount} ${widget.totalAmount.toStringAsFixed(2)} ${S.of(context).egp}',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: ColorsUtility.takeAwayColor,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          S.of(context).paypalTitle,
          style: TextStyle(
            fontSize: 16,
            color: ColorsUtility.progressIndictorColor,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 30),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: TextFormField(
            style: const TextStyle(color: ColorsUtility.onboardingColor),
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              floatingLabelBehavior: FloatingLabelBehavior.never,
              labelText: S.of(context).phoneLabel,
              labelStyle: const TextStyle(
                color: ColorsUtility.textFieldLabelColor,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
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
              prefixIcon: const Icon(
                Icons.phone,
                color: ColorsUtility.takeAwayColor,
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return S.of(context).enterPhone;
              }
              if (!RegExp(r'^[0-9]{10,15}$').hasMatch(value)) {
                return S.of(context).validPhone;
              }
              return null;
            },
          ),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: TextFormField(
            style: const TextStyle(color: ColorsUtility.onboardingColor),
            controller: _addressController,
            keyboardType: TextInputType.streetAddress,
            maxLines: 3,
            decoration: InputDecoration(
              floatingLabelBehavior: FloatingLabelBehavior.never,
              labelText: S.of(context).deliveryAddress,
              labelStyle: const TextStyle(
                color: ColorsUtility.textFieldLabelColor,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
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
              prefixIcon: const Icon(
                Icons.location_on,
                color: ColorsUtility.takeAwayColor,
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return S.of(context).enterAddress;
              }
              if (value.length < 10) {
                return S.of(context).shortAddress;
              }
              return null;
            },
          ),
        ),
        const Spacer(),
        AppElevatedBtn(
          onPressed: () {
            if (_formKey.currentState == null ||
                _formKey.currentState!.validate()) {
              _launchPayPalCheckout(context);
            }
          },
          text: S.of(context).paypalBtn,
        ),
      ],
    );
  }

  void _launchPayPalCheckout(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (BuildContext context) => Theme(
        data: ThemeData.light().copyWith(
          scaffoldBackgroundColor: ColorsUtility.onboardingColor,
          appBarTheme: const AppBarTheme(
            backgroundColor: ColorsUtility.onboardingColor,
          ),
        ),
        child: PaypalCheckout(
          sandboxMode: true,
          clientId: dotenv.env['PAYPAL_CLIENT_ID'] ?? '',
          secretKey: dotenv.env['PAYPAL_SECRET_KEY'] ?? '',
          returnURL: "https://samplesite.com/return",
          cancelURL: "https://samplesite.com/cancel",
          transactions: [
            {
              "amount": {
                "total": widget.totalAmount.toString(),
                "currency": "USD",
                "details": {
                  "subtotal": widget.totalAmount.toString(),
                  "shipping": '0',
                  "shipping_discount": 0
                }
              },
              "description": "Restaurant Order Payment",
              "item_list": {
                "items": [
                  {
                    "name": "Restaurant Order",
                    "quantity": 1,
                    "price": widget.totalAmount.toString(),
                    "currency": "USD"
                  }
                ],
              }
            }
          ],
          note: "Contact us for any questions on your order.",
          onSuccess: (Map params) async {
            final phoneNumber = _phoneController.text;
            final address = _addressController.text;

            context.read<OrdersCubit>()
              ..setDeliveryInfo(phone: phoneNumber, address: address)
              ..submitOrder(
                  discountAmount: widget.discountAmount,
                  isPaid: true,
                  paymentMethod: 'paypal',
                  totalAmount: widget.totalAmount);
          },
        ),
      ),
    ));
  }
}
