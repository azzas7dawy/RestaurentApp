import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:restrant_app/screens/ReservationPages/success_reserved_page.dart';

class ReservationForm extends StatefulWidget {
  final int selectedTable;

  ReservationForm({required this.selectedTable});

  @override
  _ReservationFormState createState() => _ReservationFormState();
}

class _ReservationFormState extends State<ReservationForm> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeArrivingController = TextEditingController();
  final TextEditingController timeLeavingController = TextEditingController();

  int numPersons = 4;
  String error = "";

  void _submitForm() async {
    if (nameController.text.isEmpty || dateController.text.isEmpty || timeArrivingController.text.isEmpty || timeLeavingController.text.isEmpty) {
      setState(() {
        error = 'Please fill out all fields.';
      });
      return;
    }

    // Check if table is already reserved for this date
    final reservationsRef = FirebaseFirestore.instance.collection('reservations');
    final snapshot = await reservationsRef
        .where('id', isEqualTo: widget.selectedTable)
        .where('date', isEqualTo: dateController.text)
        .get();

    if (snapshot.docs.isNotEmpty) {
      setState(() {
        error = 'This table is already reserved for this date.';
      });
      return;
    }

    // Save reservation
    await reservationsRef.add({
      'id': widget.selectedTable,
      'name': nameController.text,
      'date': dateController.text,
      'numPersons': numPersons,
      'timeArriving': timeArrivingController.text,
      'timeLeaving': timeLeavingController.text,
    });

    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Reservation successful!')));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      color: Colors.black,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Reservation Form',
            style: TextStyle(color: Colors.white, fontSize: 24),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          TextField(
            controller: nameController,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(labelText: 'Name', labelStyle: TextStyle(color: Colors.white)),
          ),
          TextField(
            controller: dateController,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(labelText: 'Date', labelStyle: TextStyle(color: Colors.white)),
            keyboardType: TextInputType.datetime,
          ),
          DropdownButton<int>(
            value: numPersons,
            dropdownColor: Colors.black,
            style: TextStyle(color: Colors.white),
            onChanged: (value) {
              setState(() {
                numPersons = value!;
              });
            },
            items: [4, 6].map((value) {
              return DropdownMenuItem<int>(
                value: value,
                child: Text('$value Persons'),
              );
            }).toList(),
          ),
          TextField(
            controller: timeArrivingController,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(labelText: 'Arrival Time', labelStyle: TextStyle(color: Colors.white)),
            keyboardType: TextInputType.datetime,
          ),
          TextField(
            controller: timeLeavingController,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(labelText: 'Leaving Time', labelStyle: TextStyle(color: Colors.white)),
            keyboardType: TextInputType.datetime,
          ),
          if (error.isNotEmpty) ...[
            SizedBox(height: 10),
            Text(error, style: TextStyle(color: Colors.red)),
          ],
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              showReservationSuccess(context);
              _submitForm;


            },

            child: Text('Reserve'),
          ),
        ],
      ),
    );
  }
}
