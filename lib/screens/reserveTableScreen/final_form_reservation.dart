import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:restrant_app/generated/l10n.dart';
import 'package:restrant_app/screens/reserveTableScreen/success_reserved_page.dart';

class FinalReservationDetailsForm extends StatefulWidget {
  final int selectedTable;

  FinalReservationDetailsForm({required this.selectedTable});

  @override
  _FinalReservationDetailsFormState createState() =>
      _FinalReservationDetailsFormState();
}

class _FinalReservationDetailsFormState
    extends State<FinalReservationDetailsForm> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();

  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  int numPersons = 4;
  String error = "";
  bool showReservationConflict = false;

  Future<void> _pickDate(BuildContext context) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );
    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
        dateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
        error = "";
        showReservationConflict = false;
      });
    }
  }

  Future<void> _pickTime(BuildContext context) async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
    );
    if (pickedTime != null) {
      setState(() {
        selectedTime = pickedTime;
        timeController.text = pickedTime.format(context);
        error = "";
        showReservationConflict = false;
      });
    }
  }

  Future<void> _submitForm() async {
    if (nameController.text.isEmpty ||
        selectedDate == null ||
        selectedTime == null) {
      setState(() {
        error = S.of(context).fillAllFields;
        showReservationConflict = false;
      });
      return;
    }

    final formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate!);
    final formattedTime = selectedTime!.format(context);

    final query = await FirebaseFirestore.instance
        .collection('reservations')
        .where('id', isEqualTo: widget.selectedTable)
        .where('date', isEqualTo: formattedDate)
        .where('time', isEqualTo: formattedTime)
        .get();

    if (query.docs.isNotEmpty) {
      setState(() {
        error = "";
        showReservationConflict = true;
      });
      return;
    }

    await FirebaseFirestore.instance.collection('reservations').add({
      'id': widget.selectedTable,
      'name': nameController.text,
      'date': formattedDate,
      'numPersons': numPersons,
      'time': formattedTime,
    });

    Navigator.pop(context);
    showReservationSuccess(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      color: Colors.black,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              S.of(context).revervationForm,
              style: TextStyle(color: Colors.white, fontSize: 24),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            TextField(
              controller: nameController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: S.of(context).fullName,
                labelStyle: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(height: 10),
            GestureDetector(
              onTap: () => _pickDate(context),
              child: AbsorbPointer(
                child: TextField(
                  controller: dateController,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: S.of(context).setectData,
                    labelStyle: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            DropdownButton<int>(
              value: numPersons,
              dropdownColor: Colors.black,
              style: TextStyle(color: Colors.white),
              onChanged: (value) {
                setState(() {
                  numPersons = value!;
                });
              },
              items: [1, 2, 3, 4, 6].map((value) {
                return DropdownMenuItem<int>(
                  value: value,
                  child: Text(
                    '$value ${S.of(context).selectNumberOfPeople}',
                    style: TextStyle(color: Colors.white),
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 10),
            GestureDetector(
              onTap: () => _pickTime(context),
              child: AbsorbPointer(
                child: TextField(
                  controller: timeController,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: S.of(context).selectTime,
                    labelStyle: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
            if (error.isNotEmpty) ...[
              SizedBox(height: 10),
              Text(error, style: TextStyle(color: Colors.red)),
            ],
            if (showReservationConflict) ...[
              SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red[800],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  S.of(context).reservationAlreadyExists,
                  style: TextStyle(color: Colors.white, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitForm,
              child: Text(
                S.of(context).reserve,
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
