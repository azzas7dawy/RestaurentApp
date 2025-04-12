// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:restrant_app/screens/paymentOptions/payypal.dart';
// import 'dart:convert';

// import 'package:webview_flutter/webview_flutter.dart';

// class CheckoutPage extends StatelessWidget {
//   Future<String?> _createPaypalPayment(BuildContext context) async {
//     final clientId = 'YOUR_CLIENT_ID';
//     final secret = 'YOUR_SECRET';
//     final auth = base64Encode(utf8.encode('$clientId:$secret'));

//     // 1. Get Access Token
//     final authRes = await http.post(
//       Uri.parse('https://api.sandbox.paypal.com/v1/oauth2/token'),
//       headers: {
//         'Authorization': 'Basic $auth',
//         'Content-Type': 'application/x-www-form-urlencoded',
//       },
//       body: 'grant_type=client_credentials',
//     );
//     final accessToken = jsonDecode(authRes.body)['access_token'];

//     // 2. Create Payment
//     final paymentRes = await http.post(
//       Uri.parse('https://api.sandbox.paypal.com/v1/payments/payment'),
//       headers: {
//         'Content-Type': 'application/json',
//         'Authorization': 'Bearer $accessToken',
//       },
//       body: jsonEncode({
//         "intent": "sale",
//         "redirect_urls": {
//           "return_url": "https://example.com/success",
//           "cancel_url": "https://example.com/cancel"
//         },
//         "payer": {"payment_method": "paypal"},
//         "transactions": [
//           {
//             "amount": {
//               "total": "70.00",
//               "currency": "EUR",
//               "details": {
//                 "subtotal": "70.00",
//                 "shipping": "0.00",
//                 "shipping_discount": "0.00"
//               }
//             },
//             "description": "Order payment"
//           }
//         ]
//       }),
//     );

//     final paymentData = jsonDecode(paymentRes.body);
//     final approvalUrl = (paymentData['links'] as List)
//         .firstWhere((e) => e['rel'] == 'approval_url')['href'];

//     return approvalUrl;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: ElevatedButton(
//           child: Text("Checkout with PayPal"),
//           onPressed: () async {
//             final approvalUrl = await _createPaypalPayment(context);
//             if (approvalUrl != null) {
//               final result = await Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => PaypalCheckoutWebview(
//                     approvalUrl: approvalUrl,
//                     returnUrl: "https://example.com/success",
//                     cancelUrl: "https://example.com/cancel",
//                   ),
//                 ),
//               );

//               if (result == "success") {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(content: Text("Payment Successful")));
//               } else {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(content: Text("Payment Cancelled")));
//               }
//             }
//           },
//         ),
//       ),
//     );
//   }
// }
