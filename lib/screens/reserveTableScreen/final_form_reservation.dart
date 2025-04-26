import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:restrant_app/generated/l10n.dart';
import 'package:restrant_app/screens/reserveTableScreen/success_reserved_page.dart';

class FinalReservationDetailsForm extends StatefulWidget {
  final int selectedTable;

  const FinalReservationDetailsForm({
    Key? key,
    required this.selectedTable,
  }) : super(key: key);

  @override
  State<FinalReservationDetailsForm> createState() =>
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
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
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
    final TimeOfDay? pickedTime = await showTimePicker(
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

  String _calculateLeavingTime(String arrivalTime) {
    final DateFormat timeFormat = DateFormat('hh:mm a');
    final DateTime arrival = timeFormat.parse(arrivalTime);
    final DateTime leaving = arrival.add(const Duration(hours: 2));
    return timeFormat.format(leaving);
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

    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      setState(() {
        error = S.of(context).pleaseLogin;
      });
      return;
    }

    final String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate!);
    final String formattedTime = selectedTime!.format(context);
    final String formattedLeavingTime = _calculateLeavingTime(formattedTime);

    final QuerySnapshot query = await FirebaseFirestore.instance
        .collection('reservations')
        .where('id', isEqualTo: widget.selectedTable)
        .where('date', isEqualTo: formattedDate)
        .where('timeArriving', isEqualTo: formattedTime)
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
      'timeArriving': formattedTime,
      'timeLeaving': formattedLeavingTime,
      'userId': user.uid,
      'createdAt': FieldValue.serverTimestamp(),
    });

    Navigator.pop(context);
    showReservationSuccess(context);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final TextTheme textTheme = theme.textTheme;

    return Container(
      padding: const EdgeInsets.all(16.0),
      color: theme.cardColor,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              S.of(context).revervationForm,
              style: textTheme.headlineMedium?.copyWith(
                color: textTheme.bodyLarge?.color,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: nameController,
              style: TextStyle(color: textTheme.bodyLarge?.color),
              decoration: InputDecoration(
                labelText: S.of(context).fullName,
                labelStyle: TextStyle(color: textTheme.bodyLarge?.color),
                filled: true,
                fillColor: theme.inputDecorationTheme.fillColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () => _pickDate(context),
              child: AbsorbPointer(
                child: TextField(
                  controller: dateController,
                  style: TextStyle(color: textTheme.bodyLarge?.color),
                  decoration: InputDecoration(
                    labelText: S.of(context).setectData,
                    labelStyle: TextStyle(color: textTheme.bodyLarge?.color),
                    filled: true,
                    fillColor: theme.inputDecorationTheme.fillColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            DropdownButton<int>(
              value: numPersons,
              dropdownColor: theme.cardColor,
              style: TextStyle(color: textTheme.bodyLarge?.color),
              onChanged: (int? value) {
                setState(() {
                  numPersons = value!;
                });
              },
              items: [1, 2, 3, 4, 6].map<DropdownMenuItem<int>>((int value) {
                return DropdownMenuItem<int>(
                  value: value,
                  child: Text(
                    '$value ${S.of(context).selectNumberOfPeople}',
                    style: TextStyle(color: textTheme.bodyLarge?.color),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () => _pickTime(context),
              child: AbsorbPointer(
                child: TextField(
                  controller: timeController,
                  style: TextStyle(color: textTheme.bodyLarge?.color),
                  decoration: InputDecoration(
                    labelText: S.of(context).selectTime,
                    labelStyle: TextStyle(color: textTheme.bodyLarge?.color),
                    filled: true,
                    fillColor: theme.inputDecorationTheme.fillColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            ),
            if (error.isNotEmpty) ...[
              const SizedBox(height: 10),
              Text(
                error,
                style: TextStyle(color: colorScheme.error),
              ),
            ],
            if (showReservationConflict) ...[
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colorScheme.error.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  S.of(context).tableReserved,
                  style: TextStyle(
                    color: textTheme.bodyLarge?.color,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitForm,
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: Text(S.of(context).reserve),
            ),
          ],
        ),
      ),
    );
  }
}
