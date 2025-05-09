import 'package:flutter/material.dart';
import 'package:restrant_app/generated/l10n.dart';
// import 'package:restrant_app/screens/reserveTableScreen/success_reserved_page.dart';
import 'package:restrant_app/screens/reserveTableScreen/widgets/bottom_sheet.dart';
import 'package:restrant_app/screens/reserveTableScreen/widgets/table_selection_widget.dart';

class ReservationPage extends StatefulWidget {
  const ReservationPage({super.key});
  static const String id = 'ReservationPage';

  @override
  State<ReservationPage> createState() => _ReservationPageState();
}

class _ReservationPageState extends State<ReservationPage> {
  int? selectedTable;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('Table Reservation'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/pexels-akbarattamimi-2104699.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 25),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () => _showTableSelection(context),
                    child: Text(S.of(context).selectTable,
                        style: TextStyle(color: Colors.black)),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  if (selectedTable != null)
                    ElevatedButton(
                      onPressed: () =>
                          //  showReservationSuccess(context),
                          _showReservationForm(context),
                      child: Text('${S.of(context).reserve} $selectedTable',
                          style: TextStyle(color: Colors.black)),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showTableSelection(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return TableSelection(
          selectedTable: selectedTable,
          onSelectTable: (tableId) {
            setState(() {
              selectedTable = tableId;
            });
            Navigator.pop(context);
          },
        );
      },
    );
  }

  void _showReservationForm(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return ReservationDetailsForm(
          selectedTable: selectedTable!,
        );
      },
    );
  }
}
