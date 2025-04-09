import 'package:flutter/material.dart';

void showConfirmationSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => ConfirmationSheet(),
  );
}

class ConfirmationSheet extends StatelessWidget {
  final String selectedDate = 'January 2, 2023';
  final String timeOrPeople = '7:00AM';

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16),
            Text(
              'Notify the restaurant?',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "The restaurant will be notified and we’ll contact you to confirm your order.",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
            SizedBox(height: 30),
            Row(
              children: [
                Text(
                  'Date',
                  style: TextStyle(color: Colors.white60, fontSize: 16),
                ),
                Spacer(),
                Text(
                  selectedDate,
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ],
            ),
            Divider(color: Colors.white24, height: 40),
            Row(
              children: [
                Text(
                  'Expected Number\nof people',
                  style: TextStyle(color: Colors.white60, fontSize: 16),
                ),
                Spacer(),
                Text(
                  timeOrPeople,
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ],
            ),
            Spacer(),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white10,
                  foregroundColor: Colors.white,
                  minimumSize: Size(double.infinity, 55),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                onPressed: () {
                
                },
                child: Text("PROCEED"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
