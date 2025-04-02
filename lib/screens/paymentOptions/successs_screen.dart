import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SuccessScreen extends StatelessWidget {
  static const String id = "SuccessScreen";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 100),
            SizedBox(height: 20),
            Text("تم الدفع بنجاح!",
              style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // الرجوع للصفحة الرئيسية
              },
              child: Text("العودة للصفحة الرئيسية"),
            )
          ],
        ),
      ),
    );
  }
}
