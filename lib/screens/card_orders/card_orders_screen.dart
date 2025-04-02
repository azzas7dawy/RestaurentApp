import 'package:flutter/material.dart';



class CartOrderScreen extends StatelessWidget {
  const CartOrderScreen({super.key});
  static const String id = "cart_screen";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {},
        ),
        title: const Text(
          "Cart",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Order summary",
                    style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  _orderItem("Plain Dosa", "50", "./assets/images/dosa.jpg"),
                  _orderItem("Meals", "80", "./assets/images/meal.jpg"),

                  const Divider(color: Colors.grey),
                  const SizedBox(height: 10),
                  const Row(
                    children: [
                      Icon(Icons.location_on, color: Colors.white, size: 20),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          "Flat no 9B, Landmark World, Palazhi, Calicut",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.edit, color: Colors.white, size: 20),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Rate", style: TextStyle(color: Colors.white, fontSize: 16)),
                      Text("₹ 130", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Column(
                children: [
                  _summaryRow("Subtotal", "₹ 130"),
                  SizedBox(height: 10),
                  _summaryRow("GST", "₹ 20"),
                  SizedBox(height: 10),
                  _summaryRow("Delivery partner fee for 8km", "₹ 30"),
                  Divider(color: Colors.grey),
                  _summaryRow("Grand Total", "₹ 180", isBold: true),
                ],
              ),
            ),
            const SizedBox(height: 50),
            ElevatedButton(
              style: ElevatedButton.styleFrom(

                backgroundColor: Colors.grey[800],
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 100),
              ),
              onPressed: () {},
              child: const Text("ORDER NOW", style: TextStyle(color: Colors.white, fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }





  Widget _orderItem(String name, String price, String imagePath) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Image.asset(imagePath, width: 50, height: 50, fit: BoxFit.cover),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: const TextStyle(color: Colors.white, fontSize: 14)),
              const Text("Qty: 1", style: TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          ),
          const Spacer(),
          Text("Price: $price", style: const TextStyle(color: Colors.white, fontSize: 14)),
        ],
      ),
    );
  }
}

class _summaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;

  const _summaryRow(this.label, this.value, {this.isBold = false, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: isBold ? FontWeight.bold : FontWeight.normal),
          ),
          Text(
            value,
            style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: isBold ? FontWeight.bold : FontWeight.normal),
          ),
        ],
      ),
    );
  }
}
