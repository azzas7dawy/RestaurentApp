import 'package:flutter/material.dart';

class PreviousOrderScreen extends StatelessWidget {
  static const String id = "PreviousOrderScreen";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {},
        ),
        title: Text("Previous Order"),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 🔹 صندوق ملخص الطلب
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Order summary", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  OrderItem(image: "./assets/images/dosa.jpg", name: "Plain "
                      "Dosa", price: '50',
                      quantity: '1'),
                  OrderItem(image: "./assets/images/meal.jpg", name: "Meals",
                      price: '80', quantity: '1'),
                  SizedBox(height: 15),
                  Row(
                    children: [
                      Icon(Icons.location_on, color: Colors.white, size: 20),
                      SizedBox(width: 5),
                      Expanded(child: Text("Flat no 9B, Landmark World, Palazhi, Calicut", style: TextStyle(color: Colors.white70))),
                      Icon(Icons.edit, color: Colors.white70, size: 20),
                    ],
                  ),
                  Divider(color: Colors.white24),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Rate", style: TextStyle(fontSize: 16, fontWeight:
                      FontWeight.bold,color: Colors.white70)),
                      Text("₹ 130", style: TextStyle(fontSize: 16,
                        fontWeight: FontWeight.bold,color: Colors.white)),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: 20),


            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildRow("Subtotal", "₹ 130"),
                  _buildRow("GST", "₹ 20"),
                  _buildRow("Delivery partner fee for 8km", "₹ 30"),
                  Divider(color: Colors.white24),
                  _buildRow("Grand Total", "₹ 180", isBold: true),
                ],
              ),
            ),

            Spacer(),


            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[800],
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () {},
                child: Text("ORDER NOW", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 14, color: Colors.white)),
          Text(value, style: TextStyle(fontSize: 14, fontWeight: isBold ?
          FontWeight.bold : FontWeight.normal,color: Colors.white)),
        ],
      ),
    );
  }
}

class OrderItem extends StatelessWidget {
  final String image;
  final String name;
  final String price;
  final String  quantity;

  OrderItem({required this.image, required this.name, required this.price, required this.quantity});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(image, width: 80, height: 80, fit: BoxFit.cover),
          ),
          SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                Text("Qty: $quantity", style: TextStyle(fontSize: 12, color: Colors.white)),
              ],
            ),
          ),
          Text("Price: ₹ $price", style: TextStyle(fontSize: 14, fontWeight:
          FontWeight.bold,color: Colors.white)),
        ],
      ),
    );
  }
}
