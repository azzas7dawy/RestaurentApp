import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
class ReservationDetailsForm extends StatefulWidget {
  final int selectedTable;

  ReservationDetailsForm({required this.selectedTable});

  @override
  _ReservationDetailsFormState createState() => _ReservationDetailsFormState();
}

class _ReservationDetailsFormState extends State<ReservationDetailsForm> {
  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  int numPersons = 4;
  String error = "";


  void _submitForm() async {
    if (nameController.text.isEmpty ||
        dateController.text.isEmpty ||
        timeController.text.isEmpty) {
      setState(() {
        error = 'Please fill out all fields.';
      });
      return;
    }

    await FirebaseFirestore.instance.collection('reservations').add({
      'id': widget.selectedTable,
      'name': nameController.text,
      'date': dateController.text,
      'numPersons': numPersons,
      'time': timeController.text,
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
            decoration: InputDecoration(labelText: 'Your Name', labelStyle: TextStyle(color: Colors.white)),
          ),
          TextField(
            controller: dateController,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(labelText: 'Select Date', labelStyle: TextStyle(color: Colors.white)),
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
            items: [4, 6, 3,2,1].map((value) {
              return DropdownMenuItem<int>(
                value: value,
                child: Text('$value Persons'),
              );
            }).toList(),
          ),

          TextField(
            controller: timeController,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(labelText: 'Select Time', labelStyle: TextStyle(color: Colors.white)),
            keyboardType: TextInputType.datetime,
          ),
          if (error.isNotEmpty) ...[
            SizedBox(height: 10),
            Text(error, style: TextStyle(color: Colors.red)),
          ],
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _submitForm,
            child: Text('Reserve', style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }
}