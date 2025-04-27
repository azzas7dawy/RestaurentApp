import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paymob_payment/paymob_payment.dart';
import 'package:restrant_app/generated/l10n.dart';
import 'package:restrant_app/screens/paymentScreen/payment_screen.dart';
import 'package:restrant_app/screens/trackOrdersScreen/track_orders_screen.dart';
import 'package:restrant_app/cubit/OrdersLogic/cubit/orders_cubit.dart';
import 'package:restrant_app/widgets/app_elevated_btn_widget.dart';
import 'package:restrant_app/widgets/app_snackbar.dart';
import 'package:restrant_app/utils/icons_utility.dart';

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
  bool _isProcessingPayment = false;

  @override
  void initState() {
    super.initState();
    _loadEnvVariables();
  }

  Future<void> _loadEnvVariables() async {
    await dotenv.load(fileName: ".env");
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.paymentMethod == 'cash'
              ? S.of(context).cashOnDelivery
              : S.of(context).payWithCard,
          style: TextStyle(
            fontSize: 20,
            color: colorScheme.secondary,
          ),
        ),
        iconTheme: IconThemeData(color: colorScheme.secondary),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacementNamed(
              context,
              PaymentScreen.id,
              arguments: widget.totalAmount,
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: widget.paymentMethod == 'cash'
              ? _buildCashOnDeliveryContent()
              : _buildPaymobContent(),
        ),
      ),
    );
  }

  Widget _buildCashOnDeliveryContent() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Form(
      key: _formKey,
      child: SizedBox(
        height: MediaQuery.of(context).size.height -
            kToolbarHeight -
            MediaQuery.of(context).padding.top,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              IconsUtility.cashOnDeliveryIcon,
              width: 100,
              height: 100,
              colorFilter: ColorFilter.mode(
                colorScheme.primary,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              '${S.of(context).txtp1} ${widget.totalAmount.toStringAsFixed(2)} ${S.of(context).egp} ${S.of(context).txtp2}',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: colorScheme.secondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Text(
              S.of(context).subTitle,
              style: TextStyle(
                fontSize: 16,
                color: colorScheme.primary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextFormField(
                style: TextStyle(color: theme.textTheme.bodyMedium?.color),
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  labelText: S.of(context).phoneLabel,
                  labelStyle: TextStyle(
                    color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
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
                  prefixIcon: Icon(
                    Icons.phone,
                    color: colorScheme.secondary,
                  ),
                  filled: true,
                  fillColor: theme.cardColor,
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
                style: TextStyle(color: theme.textTheme.bodyMedium?.color),
                controller: _addressController,
                keyboardType: TextInputType.streetAddress,
                maxLines: 3,
                decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  labelText: S.of(context).deliveryAddress,
                  labelStyle: TextStyle(
                    color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
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
                  prefixIcon: Icon(
                    Icons.location_on,
                    color: colorScheme.secondary,
                  ),
                  filled: true,
                  fillColor: theme.cardColor,
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
                    Navigator.pushReplacementNamed(
                        context, TrackOrdersScreen.id);
                  }
                }
              },
              text: S.of(context).confirmOrder,
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymobContent() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Form(
      key: _formKey,
      child: SizedBox(
        height: MediaQuery.of(context).size.height -
            kToolbarHeight -
            MediaQuery.of(context).padding.top,
        child: Column(
          children: [
            SvgPicture.asset(
              IconsUtility.creditCardIcon,
              width: 100,
              height: 100,
              colorFilter: ColorFilter.mode(
                colorScheme.primary,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              '${S.of(context).totalAmount} ${widget.totalAmount.toStringAsFixed(2)} ${S.of(context).egp}',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: colorScheme.secondary,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              S.of(context).payWithCard,
              style: TextStyle(
                fontSize: 16,
                color: colorScheme.primary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextFormField(
                style: TextStyle(color: theme.textTheme.bodyMedium?.color),
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  labelText: S.of(context).phoneLabel,
                  labelStyle: TextStyle(
                    color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
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
                  prefixIcon: Icon(
                    Icons.phone,
                    color: colorScheme.secondary,
                  ),
                  filled: true,
                  fillColor: theme.cardColor,
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
                style: TextStyle(color: theme.textTheme.bodyMedium?.color),
                controller: _addressController,
                keyboardType: TextInputType.streetAddress,
                maxLines: 3,
                decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  labelText: S.of(context).deliveryAddress,
                  labelStyle: TextStyle(
                    color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
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
                  prefixIcon: Icon(
                    Icons.location_on,
                    color: colorScheme.secondary,
                  ),
                  filled: true,
                  fillColor: theme.cardColor,
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
            _isProcessingPayment
                ? CircularProgressIndicator(color: colorScheme.secondary)
                : AppElevatedBtn(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        await _initiatePaymobPayment();
                      }
                    },
                    text: S.of(context).proceedWithPaymob,
                  ),
          ],
        ),
      ),
    );
  }

  Future<void> _initiatePaymobPayment() async {
    if (!mounted) return;

    setState(() {
      _isProcessingPayment = true;
    });

    try {
      final apiKey = dotenv.env['apiKey'];
      final integrationId = dotenv.env['integrationID'];
      final iframeId = dotenv.env['iFrameID'];

      if (apiKey == null || integrationId == null || iframeId == null) {
        throw Exception('Paymob configuration is missing');
      }

      await PaymobPayment.instance.initialize(
        apiKey: apiKey,
        integrationID: int.parse(integrationId),
        iFrameID: int.parse(iframeId),
      );

      String firstName = 'Guest';
      String lastName = 'User';

      final fullName = FirebaseAuth.instance.currentUser?.displayName;
      if (fullName != null && fullName.trim().isNotEmpty) {
        final parts = fullName.trim().split(' ');
        if (parts.length > 1) {
          firstName = parts.first;
          lastName = parts.sublist(1).join(' ');
        } else {
          firstName = fullName;
        }
      }

      final billingData = PaymobBillingData(
        firstName: firstName,
        lastName: lastName,
        email: FirebaseAuth.instance.currentUser?.email ?? '',
        phoneNumber: _phoneController.text,
        street: _addressController.text,
      );

      if (!mounted) return;

      final paymentResponse = await PaymobPayment.instance.pay(
        context: context,
        amountInCents: (widget.totalAmount * 100).toStringAsFixed(0),
        currency: 'EGP',
        billingData: billingData,
      );

      if (!mounted) return;

      if (paymentResponse != null && paymentResponse.success) {
        final phoneNumber = _phoneController.text;
        final address = _addressController.text;

        final ordersCubit = context.read<OrdersCubit>();
        ordersCubit.setDeliveryInfo(phone: phoneNumber, address: address);
        await ordersCubit.submitOrder(
          discountAmount: widget.discountAmount,
          isPaid: true,
          paymentMethod: 'card',
          totalAmount: widget.totalAmount,
        );

        if (mounted) {
          Navigator.pushReplacementNamed(context, TrackOrdersScreen.id);
        }
      } else {
        appSnackbar(
          context,
          text: S.of(context).paymentFailed,
          backgroundColor: Theme.of(context).colorScheme.error,
        );
      }
    } catch (e) {
      if (!mounted) return;
      appSnackbar(
        context,
        text: 'Payment Error: ${e.toString()}',
        backgroundColor: Theme.of(context).colorScheme.error,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isProcessingPayment = false;
        });
      }
    }
  }
}
