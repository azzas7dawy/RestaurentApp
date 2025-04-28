import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:restrant_app/generated/l10n.dart';
import 'package:restrant_app/screens/reserveTableScreen/success_reserved_page.dart';
import 'package:restrant_app/widgets/app_elevated_btn_widget.dart';

class FinalReservationDetailsForm extends StatefulWidget {
  final int selectedTable;

  const FinalReservationDetailsForm({
    super.key,
    required this.selectedTable,
  });

  @override
  State<FinalReservationDetailsForm> createState() =>
      _FinalReservationDetailsFormState();
}

class _FinalReservationDetailsFormState
    extends State<FinalReservationDetailsForm> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

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
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Theme.of(context).colorScheme.primary,
              onPrimary: Theme.of(context).colorScheme.onPrimary,
              surface: Theme.of(context).cardColor,
              onSurface:
                  Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black,
            ),
            dialogBackgroundColor: Theme.of(context).cardColor,
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null && pickedDate != selectedDate) {
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
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Theme.of(context).colorScheme.primary,
              onPrimary: Theme.of(context).colorScheme.onPrimary,
              surface: Theme.of(context).cardColor,
              onSurface:
                  Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black,
            ),
            dialogBackgroundColor: Theme.of(context).cardColor,
          ),
          child: child!,
        );
      },
    );

    if (pickedTime != null && pickedTime != selectedTime) {
      setState(() {
        selectedTime = pickedTime;
        timeController.text = _formatTimeOfDay(pickedTime);
        error = "";
        showReservationConflict = false;
      });
    }
  }

  String _formatTimeOfDay(TimeOfDay tod) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
    final format = DateFormat('HH:mm');
    return format.format(dt);
  }

  String _calculateLeavingTime(String arrivalTime) {
    final format = DateFormat('HH:mm');
    final dt = format.parse(arrivalTime);
    final leaving = dt.add(const Duration(hours: 1));
    return format.format(leaving);
  }

  String _generateReservationId() {
    return DateTime.now().millisecondsSinceEpoch.toString().substring(0, 6);
  }

  Future<bool> _checkReservationConflict(
    String formattedDate,
    String formattedTime,
    String formattedLeavingTime,
  ) async {
    final DateFormat timeFormat = DateFormat('HH:mm');
    final DateTime requestedArriving = timeFormat.parse(formattedTime);
    final DateTime requestedLeaving = timeFormat.parse(formattedLeavingTime);

    final QuerySnapshot query = await FirebaseFirestore.instance
        .collection('reservations')
        .where('tableId', isEqualTo: widget.selectedTable)
        .where('date', isEqualTo: formattedDate)
        .get();

    for (var doc in query.docs) {
      final String existingArriving = doc['timeArriving'];
      final String existingLeaving = doc['timeLeaving'];

      final DateTime existingArrivingTime = timeFormat.parse(existingArriving);
      final DateTime existingLeavingTime = timeFormat.parse(existingLeaving);

      if ((requestedArriving.isAfter(existingArrivingTime) &&
              requestedArriving.isBefore(existingLeavingTime)) ||
          (requestedLeaving.isAfter(existingArrivingTime) &&
              requestedLeaving.isBefore(existingLeavingTime)) ||
          (requestedArriving.isAtSameMomentAs(existingArrivingTime)) ||
          (requestedLeaving.isAtSameMomentAs(existingLeavingTime)) ||
          (requestedArriving.isBefore(existingArrivingTime) &&
              requestedLeaving.isAfter(existingLeavingTime))) {
        return true;
      }
    }
    return false;
  }

  Future<void> _submitForm() async {
    if (nameController.text.isEmpty ||
        selectedDate == null ||
        selectedTime == null ||
        phoneController.text.isEmpty) {
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
    final String formattedTime = _formatTimeOfDay(selectedTime!);
    final String formattedLeavingTime = _calculateLeavingTime(formattedTime);

    final bool hasConflict = await _checkReservationConflict(
      formattedDate,
      formattedTime,
      formattedLeavingTime,
    );

    if (hasConflict) {
      setState(() {
        error = S.of(context).tableNotAvailable;
        showReservationConflict = true;
      });
      return;
    }

    final String reservationId = _generateReservationId();

    await FirebaseFirestore.instance.collection('reservations').add({
      'date': formattedDate,
      'name': nameController.text,
      'numPersons': numPersons,
      'phone': phoneController.text,
      'reservationId': reservationId,
      'status': "pending",
      'tableId': widget.selectedTable,
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
            TextField(
              controller: phoneController,
              style: TextStyle(color: textTheme.bodyLarge?.color),
              decoration: InputDecoration(
                labelText: S.of(context).phoneNumber,
                labelStyle: TextStyle(color: textTheme.bodyLarge?.color),
                filled: true,
                fillColor: theme.inputDecorationTheme.fillColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
              keyboardType: TextInputType.phone,
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
              dropdownColor: theme.inputDecorationTheme.fillColor,
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
            const SizedBox(height: 20),
            Center(
              child: AppElevatedBtn(
                onPressed: _submitForm,
                text: S.of(context).reserve,
              ),
            ),
            // ElevatedButton(
            //   onPressed: _submitForm,
            //   style: ElevatedButton.styleFrom(
            //     backgroundColor: colorScheme.primary,
            //     foregroundColor: colorScheme.onPrimary,
            //     minimumSize: const Size(double.infinity, 50),
            //     shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.circular(15),
            //     ),
            //   ),
            //   child: Text(S.of(context).reserve),
            // ),
          ],
        ),
      ),
    );
  }
}
