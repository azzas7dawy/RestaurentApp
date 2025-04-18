//
// import 'package:flutter/material.dart';
// import 'package:webview_flutter/webview_flutter.dart';
//
// class PaypalCheckoutWebview extends StatefulWidget {
//   final String approvalUrl;
//   final String returnUrl;
//   final String cancelUrl;
//
//   const PaypalCheckoutWebview({
//     Key? key,
//     required this.approvalUrl,
//     required this.returnUrl,
//     required this.cancelUrl,
//   }) : super(key: key);
//
//   @override
//   State<PaypalCheckoutWebview> createState() => _PaypalCheckoutWebviewState();
// }
//
// class _PaypalCheckoutWebviewState extends State<PaypalCheckoutWebview> {
//   late final WebViewController _controller;
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = WebViewController()
//       ..setJavaScriptMode(JavaScriptMode.unrestricted)
//       ..setNavigationDelegate(
//         NavigationDelegate(
//           onNavigationRequest: (request) {
//             final url = request.url;
//
//             if (url.startsWith(widget.returnUrl)) {
//               Navigator.pop(context, 'success');
//               return NavigationDecision.prevent;
//             } else if (url.startsWith(widget.cancelUrl)) {
//               Navigator.pop(context, 'cancel');
//               return NavigationDecision.prevent;
//             }
//
//             return NavigationDecision.navigate;
//           },
//         ),
//       )
//       ..loadRequest(
//         Uri.parse(widget.approvalUrl),
//       );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Pay with PayPal")),
//       body: WebViewWidget(controller: _controller),
//     );
//   }
// }
