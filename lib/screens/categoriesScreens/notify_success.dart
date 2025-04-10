import 'package:flutter/material.dart';

class OrderConfirmationScreen extends StatefulWidget {
  static const String id = 'order_confirmation_screen';
  final String orderId;

  const OrderConfirmationScreen({Key? key, required this.orderId}) : super(key: key);

  @override
  State<OrderConfirmationScreen> createState() => _OrderConfirmationScreenState();
}

class _OrderConfirmationScreenState extends State<OrderConfirmationScreen> {
  @override
  void initState() {
    super.initState();
    
   
    Future.delayed(Duration(seconds: 3), () {
      if (mounted) {
        Navigator.of(context).pop(); 
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
        
          Positioned(
            top: 40,
            right: 20,
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Icon(Icons.close, color: Colors.white, size: 28),
            ),
          ),

          
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Thank you for placing\nthe order',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 40),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    
                    Positioned(
                      top: -15,
                      left: 0,
                      child: Icon(Icons.star, color: Colors.orange, size: 16),
                    ),
                    Positioned(
                      right: -15,
                      top: 10,
                      child: Icon(Icons.circle, color: Colors.greenAccent, size: 10),
                    ),
                    Positioned(
                      bottom: -15,
                      child: Icon(Icons.star, color: Colors.orange, size: 16),
                    ),
                    Positioned(
                      left: 30,
                      top: 40,
                      child: Icon(Icons.circle, color: Colors.greenAccent, size: 10),
                    ),

                   
                    Container(
                      
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Icon(Icons.check, color: Colors.white, size: 60),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 40),
                const Text(
                  "We'll get in touch with you soon.",
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
                const SizedBox(height: 10),
                Text(
                  'ORDER ID : ${widget.orderId}',
                  style: TextStyle(
                    color: Colors.white,
                    letterSpacing: 1.2,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
