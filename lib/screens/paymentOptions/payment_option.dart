import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

import 'package:http/http.dart' as http;
import 'package:restrant_app/screens/paymentOptions/paypal.dart';
import 'package:restrant_app/screens/paymentOptions/successs_screen.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});
  static const String id = "PaymentScreen";

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  Map<String, dynamic>? paymentIntentData;

  // Future<void> makePayment() async {
  //   try {
  //     paymentIntentData = await createPaymentIntent("10", "USD");
  //
  //     await Stripe.instance.initPaymentSheet(
  //       paymentSheetParameters: SetupPaymentSheetParameters(
  //         paymentIntentClientSecret: paymentIntentData!['client_secret'],
  //         merchantDisplayName: 'My Restaurant App',
  //       ),
  //     );
  //
  //     await Stripe.instance.presentPaymentSheet();
  //
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text("✅ تم الدفع بنجاح!")),
  //     );
  //   } catch (e) {
  //     print("❌ خطأ أثناء الدفع: $e");
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text("❌ فشلت عملية الدفع")),
  //     );
  //   }
  // }
  Future<void> makePayment() async {
    try {
      // إنشاء Payment Intent
      paymentIntentData = await createPaymentIntent("10", "USD");
      await Stripe.instance.presentPaymentSheet();

      // تهيئة ورقة الدفع
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntentData!['client_secret'],
          merchantDisplayName: 'My Restaurant App',
        ),
      );

      // عرض ورقة الدفع
      await Stripe.instance.presentPaymentSheet();

      // ✅ إذا لم يحدث أي خطأ هنا، فالدفع ناجح
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✅ تم الدفع بنجاح!")),
      );

      // 🔥 تحديث الواجهة أو التنقل لصفحة Success
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SuccessScreen()),
      );

    } catch (e) {
      // ❌ التعامل مع الأخطاء أثناء الدفع
      print("❌ خطأ أثناء الدفع: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("❌ فشلت عملية الدفع")),
      );
    }
  }

  Future<Map<String, dynamic>> createPaymentIntent(
      String amount, String currency) async {
    try {
      var body = {
        "amount": (int.parse(amount) * 100).toString(),
        "currency": currency,
        "payment_method_types[]": "card",
      };

      var response = await http.post(
        Uri.parse("https://api.stripe.com/v1/payment_intents"),
        headers: {
          "Authorization": "Bearer sk_test_51QCzsRBLVMLT5b6WTIhwBP5KBTF68AVHaNC8duQgCG85WzGoFYYkTa7BKeAJeoLAk5zFsiRmy8oHLp94oZJcLYEq00bFX6IWFQ",

          "Content-Type": "application/x-www-form-urlencoded"
        },
        body: body,
      );
      print("🔍 Stripe API Response: ${response.body}");
      return jsonDecode(response.body);
    } catch (e) {
      throw Exception("❌ حدث خطأ أثناء إنشاء PaymentIntent");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('Payment Options', style: TextStyle(color: Colors.white)),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _orderSummary(),
            _orderSummary(),
            _sectionTitle('Credit & Debit Cards'),
            GestureDetector(
                onTap: (){
                  print("object");

                  CheckoutPage();
                },
                child: InkWell(
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => CheckoutPage())),
                    child: _paymentOption('PayPal', './assets/images/paypal.jpg', null))),
            _paymentOption('Stripe', './assets/images/strip.png', makePayment),
            const SizedBox(height: 16),
            _sectionTitle('More Payment Options'),
            _morePaymentOptions(),
            const SizedBox(height: 16),

          ],
        ),
      ),
    );
  }

  Widget _orderSummary() {
    return Material(
      color: Colors.grey[900],
      child: ListTile(
        leading: Image.asset('./assets/images/dosa.jpg'),
        title: const Text('Order summary', style: TextStyle(color: Colors.white)),
        subtitle: const Text('Plain Dosa Qty: 1 ₹92', style: TextStyle(color: Colors.white70)),
        trailing: const Icon(Icons.location_on, color: Colors.white70),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Text(title, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
    );
  }

  Widget _paymentOption(String method, String logoPath, Function? onTap) {
    return Material(
      color: Colors.grey[850],
      child: ListTile(
        leading: Image.asset(logoPath, height: 30),
        title: Text(method, style: const TextStyle(color: Colors.white)),
        trailing: const Icon(Icons.radio_button_unchecked, color: Colors.white70),
        onTap: onTap != null ? () => onTap() : null,
      ),
    );
  }

  Widget _morePaymentOptions() {
    return const Column(
      children: [
        ListTile(
          leading: Icon(Icons.wallet, color: Colors.white70),
          title: Text('Wallet', style: TextStyle(color: Colors.white)),
          trailing: Icon(Icons.arrow_forward_ios, color: Colors.white70),
        ),
        ListTile(
          leading: Icon(Icons.account_balance, color: Colors.white70),
          title: Text('Net Banking', style: TextStyle(color: Colors.white)),
          trailing: Icon(Icons.arrow_forward_ios, color: Colors.white70),
        ),
        ListTile(
          leading: Icon(Icons.money, color: Colors.white70),
          title: Text('Cash on Delivery', style: TextStyle(color: Colors.white)),
          trailing: Icon(Icons.radio_button_unchecked, color: Colors.white70),
        ),
      ],
    );
  }
}



// import 'package:flutter/material.dart';
//
// class PaymentScreen extends StatelessWidget {
//   const PaymentScreen({super.key});
//   static const String id="PaymentScreen";
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar: AppBar(
//         backgroundColor: Colors.black,
//         iconTheme: const IconThemeData(color: Colors.white),
//         title: const Text('Payment Options', style: TextStyle(color: Colors.white)),
//         elevation: 0,
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _orderSummary(),
//             _sectionTitle('Credit & Debit Cards'),
//             _paymentOption('PayPal', './assets/images/paypal.jpg'),
//             _paymentOption('Stripe', './assets/images/strip.png'),
//             const SizedBox(height: 16),
//             _sectionTitle('More Payment Options'),
//             _morePaymentOptions(),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _orderSummary() {
//     return Card(
//       color: Colors.grey[900],
//       child: ListTile(
//         leading: Image.asset('./assets/images/dosa.jpg'),
//         title: const Text('Order summary', style: TextStyle(color: Colors.white)),
//         subtitle: const Text('Plain Dosa Qty: 1 ₹92', style: TextStyle(color:
//         Colors.white70)),
//             trailing: const Icon(Icons.location_on, color: Colors.white70),
//       ),
//     );
//   }
//
//   Widget _sectionTitle(String title) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 10.0),
//       child: Text(title, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
//     );
//   }
//
//   Widget _paymentOption(String method, String logoPath) {
//     return Card(
//       color: Colors.grey[850],
//       child: ListTile(
//         leading: Image.asset(logoPath, height: 30),
//         title: Text(method, style: const TextStyle(color: Colors.white)),
//         trailing: const Icon(Icons.radio_button_unchecked, color: Colors.white70),
//       ),
//     );
//   }
//
//   Widget _morePaymentOptions() {
//     return const Column(
//       children: [
//         ListTile(
//           leading: Icon(Icons.wallet, color: Colors.white70),
//           title: Text('Wallet', style: TextStyle(color: Colors.white)),
//           trailing: Icon(Icons.arrow_forward_ios, color: Colors.white70),
//         ),
//         ListTile(
//           leading: Icon(Icons.account_balance, color: Colors.white70),
//           title: Text('Net Banking', style: TextStyle(color: Colors.white)),
//           trailing: Icon(Icons.arrow_forward_ios, color: Colors.white70),
//         ),
//         ListTile(
//           leading: Icon(Icons.money, color: Colors.white70),
//           title: Text('Cash on Delivery', style: TextStyle(color: Colors.white)),
//           trailing: Icon(Icons.radio_button_unchecked, color: Colors.white70),
//         ),
//       ],
//     );
//   }
// }
