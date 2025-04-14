import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_paypal_checkout/flutter_paypal_checkout.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
              ? "Cash on Delivery"
              : "PayPal Checkout",
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
            'You will pay ${widget.totalAmount.toStringAsFixed(2)} EGP when you receive your order',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: ColorsUtility.takeAwayColor,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          const Text(
            'Our delivery agent will collect the payment when your order arrives',
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
                labelText: 'Phone Number',
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
                  return 'Please enter your phone number';
                }
                if (!RegExp(r'^[0-9]{10,15}$').hasMatch(value)) {
                  return 'Please enter a valid phone number';
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
                labelText: 'Delivery Address',
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
                  return 'Please enter your delivery address';
                }
                if (value.length < 10) {
                  return 'Address is too short';
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
            text: 'Confirm Order',
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
          'Total Amount: ${widget.totalAmount.toStringAsFixed(2)} EGP',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: ColorsUtility.takeAwayColor,
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'You will be redirected to PayPal to complete your payment securely',
          style: TextStyle(
            fontSize: 16,
            color: ColorsUtility.progressIndictorColor,
          ),
          textAlign: TextAlign.center,
        ),
        const Spacer(),
        AppElevatedBtn(
          onPressed: () {
            _launchPayPalCheckout(context);
          },
          text: 'Proceed to PayPal',
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

            await context.read<OrdersCubit>()
              ..setDeliveryInfo(phone: phoneNumber, address: address)
              ..submitOrder(
                paymentMethod: 'paypal',
                totalAmount: widget.totalAmount,
                discountAmount: widget.discountAmount,
                isPaid: true,
              );

            Navigator.pop(context);
          },
          onError: (error) {
            print("onError: $error");
            Navigator.pop(context);
          },
          onCancel: () {
            print('cancelled:');
            Navigator.pop(context);
          },
        ),
      ),
    ));
  }
}
