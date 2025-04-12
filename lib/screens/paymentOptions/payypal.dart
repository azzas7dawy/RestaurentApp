import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:webview_flutter/webview_flutter.dart';

class PayPalCheckoutScreen extends StatefulWidget {
  const PayPalCheckoutScreen({super.key});

  @override
  State<PayPalCheckoutScreen> createState() => _PayPalCheckoutScreenState();
}

class _PayPalCheckoutScreenState extends State<PayPalCheckoutScreen> {
  final String clientId = 'YOUR_CLIENT_ID';
  final String secret = 'YOUR_SECRET';
  final String returnUrl = 'https://example.com/return';
  final String cancelUrl = 'https://example.com/cancel';

  late WebViewController _controller;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _startPaymentProcess();
  }

  Future<void> _startPaymentProcess() async {
    try {
      // 1. احصل على access token
      final auth = base64Encode(utf8.encode('$clientId:$secret'));
      final tokenRes = await http.post(
        Uri.parse('https://api-m.sandbox.paypal.com/v1/oauth2/token'),
        headers: {
          'Authorization': 'Basic $auth',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: 'grant_type=client_credentials',
      );
      final accessToken = jsonDecode(tokenRes.body)['access_token'];

      // 2. أنشئ order
      final orderRes = await http.post(
        Uri.parse('https://api-m.sandbox.paypal.com/v2/checkout/orders'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode({
          "intent": "CAPTURE",
          "purchase_units": [
            {
              "amount": {
                "currency_code": "USD",
                "value": "10.00",
              }
            }
          ],
          "application_context": {
            "return_url": returnUrl,
            "cancel_url": cancelUrl,
          }
        }),
      );

      final order = jsonDecode(orderRes.body);
      final approvalUrl = order['links']
          .firstWhere((link) => link['rel'] == 'approve')['href'];
      final orderId = order['id'];

      _controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setNavigationDelegate(
          NavigationDelegate(
            onNavigationRequest: (request) async {
              final url = request.url;
              if (url.startsWith(returnUrl)) {
                // 4. المستخدم وافق، نكمل الدفع
                await _captureOrder(accessToken, orderId);
                Navigator.pop(context, 'success');
                return NavigationDecision.prevent;
              } else if (url.startsWith(cancelUrl)) {
                Navigator.pop(context, 'cancel');
                return NavigationDecision.prevent;
              }
              return NavigationDecision.navigate;
            },
          ),
        )
        ..loadRequest(Uri.parse(approvalUrl));

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<void> _captureOrder(String token, String orderId) async {
    final res = await http.post(
      Uri.parse('https://api-m.sandbox.paypal.com/v2/checkout/orders/$orderId/capture'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    final data = jsonDecode(res.body);
    print('Order Captured: $data');
    // ممكن تخزن أو تعرض معلومات الدفع هنا
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Pay with PayPal")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : WebViewWidget(controller: _controller),
    );
  }
}
