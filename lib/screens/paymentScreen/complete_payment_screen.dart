import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:restrant_app/generated/l10n.dart';
import 'package:restrant_app/screens/paymentScreen/payment_screen.dart';
import 'package:restrant_app/screens/trackOrdersScreen/track_orders_screen.dart';
import 'package:restrant_app/utils/colors_utility.dart';
import 'package:restrant_app/utils/icons_utility.dart';
import 'package:restrant_app/widgets/app_elevated_btn_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restrant_app/cubit/OrdersLogic/cubit/orders_cubit.dart';
import 'package:restrant_app/widgets/app_snackbar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:webview_flutter/webview_flutter.dart';

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
  String? _paymentToken;
  String? _orderId;
  String? _finalToken;
  bool _showWebView = false;
  String _webViewUrl = '';

  @override
  void initState() {
    super.initState();
    // Initialize any required setup
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_showWebView) {
      return _buildPaymobWebView();
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.paymentMethod == 'cash'
              ? S.of(context).cashOnDelivery
              : S.of(context).payWithCard,
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
            Navigator.pushReplacementNamed(
              context,
              PaymentScreen.id,
              arguments: widget.totalAmount,
            );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: widget.paymentMethod == 'cash'
            ? _buildCashOnDeliveryContent()
            : _buildPaymobContent(),
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

  Widget _buildPaymobContent() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          SvgPicture.asset(
            IconsUtility.creditCardIcon,
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
            S.of(context).payWithCard,
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
          _isProcessingPayment
              ? const CircularProgressIndicator()
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
    );
  }

  Widget _buildPaymobWebView() {
    return Scaffold(
      appBar: AppBar(
        title: Text('payment'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            setState(() {
              _showWebView = false;
            });
          },
        ),
      ),
      body: WebViewWidget(
        controller: WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setNavigationDelegate(
            NavigationDelegate(
              onNavigationRequest: (NavigationRequest request) {
                // Handle payment success/failure by checking the URL
                if (request.url.contains('success')) {
                  _handlePaymentSuccess();
                  return NavigationDecision.prevent;
                } else if (request.url.contains('fail')) {
                  _handlePaymentFailure();
                  return NavigationDecision.prevent;
                }
                return NavigationDecision.navigate;
              },
            ),
          )
          ..loadRequest(Uri.parse(_webViewUrl)),
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

      _paymentToken = await _getPaymentToken(apiKey);

      _orderId = await _createOrder(apiKey, _paymentToken!);

      _finalToken = await _getPaymentKey(
        apiKey: apiKey,
        integrationId: integrationId,
        orderId: _orderId!,
        paymentToken: _paymentToken!,
      );

      if (!mounted) return;

      setState(() {
        _webViewUrl =
            'https://accept.paymob.com/api/acceptance/iframes/$iframeId?payment_token=$_finalToken';
        _showWebView = true;
        _isProcessingPayment = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isProcessingPayment = false;
      });
      appSnackbar(
        context,
        text: 'Payment Error: ${e.toString()}',
        backgroundColor: ColorsUtility.errorSnackbarColor,
      );
    }
  }

  Future<String> _getPaymentToken(String apiKey) async {
    final url = Uri.parse('https://accept.paymob.com/api/auth/tokens');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({'api_key': apiKey});

    final response = await http.post(url, headers: headers, body: body);
    final responseData = jsonDecode(response.body);

    if (response.statusCode == 201) {
      return responseData['token'];
    } else {
      throw Exception('Failed to get payment token: ${responseData['detail']}');
    }
  }

  Future<String> _createOrder(String apiKey, String paymentToken) async {
    final url = Uri.parse('https://accept.paymob.com/api/ecommerce/orders');
    final headers = {'Content-Type': 'application/json'};
    // final user = FirebaseAuth.instance.currentUser;

    final body = jsonEncode({
      'auth_token': paymentToken,
      'delivery_needed': false,
      'amount_cents': (widget.totalAmount * 100).toStringAsFixed(0),
      'currency': 'EGP',
      'items': [],
    });

    final response = await http.post(url, headers: headers, body: body);
    final responseData = jsonDecode(response.body);

    if (response.statusCode == 201) {
      return responseData['id'].toString();
    } else {
      throw Exception('Failed to create order: ${response.body}');
    }
  }

  Future<String> _getPaymentKey({
    required String apiKey,
    required String integrationId,
    required String orderId,
    required String paymentToken,
  }) async {
    final url =
        Uri.parse('https://accept.paymob.com/api/acceptance/payment_keys');
    final headers = {'Content-Type': 'application/json'};
    final user = FirebaseAuth.instance.currentUser;

    final body = jsonEncode({
      'auth_token': paymentToken,
      'amount_cents': (widget.totalAmount * 100).round(),
      'expiration': 3600,
      'order_id': orderId,
      'billing_data': {
        'first_name': user?.displayName?.split(' ').first ?? 'Guest',
        'last_name': user?.displayName?.split(' ').last ?? 'User',
        'email': user?.email ?? 'guest@example.com',
        'phone_number': _phoneController.text,
        'street': _addressController.text,
        'building': 'NA',
        'floor': 'NA',
        'apartment': 'NA',
        'city': 'Cairo',
        'state': 'Cairo',
        'country': 'EG',
        'postal_code': '0000',
      },
      'currency': 'EGP',
      'integration_id': int.parse(integrationId),
    });

    final response = await http.post(url, headers: headers, body: body);
    final responseData = jsonDecode(response.body);

    if (response.statusCode == 201) {
      return responseData['token'];
    } else {
      print('Payment key error response: ${response.body}');
      throw Exception('Failed to get payment key: ${response.body}');
    }
  }

  Future<void> _handlePaymentSuccess() async {
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
  }

  void _handlePaymentFailure() {
    if (!mounted) return;

    setState(() {
      _showWebView = false;
    });

    appSnackbar(
      context,
      text: S.of(context).paymentFailed,
      backgroundColor: ColorsUtility.errorSnackbarColor,
    );
  }
}
