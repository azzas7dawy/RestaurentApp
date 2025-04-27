import 'package:flutter/material.dart';
import 'package:restrant_app/generated/l10n.dart';
import 'package:restrant_app/screens/reserveTableScreen/final_form_reservation.dart';
import 'package:restrant_app/utils/colors_utility.dart';

class TableSelectionPage extends StatefulWidget {
  const TableSelectionPage({super.key});
  static const String id = 'TableSelectionPage';

  @override
  State<TableSelectionPage> createState() => _TableSelectionPageState();
}

class _TableSelectionPageState extends State<TableSelectionPage> {
  int? selectedTable;

  final List<Map<String, dynamic>> tables = [
    {
      'id': 1,
      'seats': 4,
      'image': 'https://i.postimg.cc/fR12ckGT/table-4-removebg-preview.png'
    },
    {
      'id': 2,
      'seats': 4,
      'image': 'https://i.postimg.cc/fR12ckGT/table-4-removebg-preview.png'
    },
    {
      'id': 3,
      'seats': 4,
      'image': 'https://i.postimg.cc/fR12ckGT/table-4-removebg-preview.png'
    },
    {
      'id': 4,
      'seats': 4,
      'image': 'https://i.postimg.cc/fR12ckGT/table-4-removebg-preview.png'
    },
    {
      'id': 5,
      'seats': 4,
      'image': 'https://i.postimg.cc/fR12ckGT/table-4-removebg-preview.png'
    },
    {
      'id': 6,
      'seats': 4,
      'image': 'https://i.postimg.cc/fR12ckGT/table-4-removebg-preview.png'
    },
    {
      'id': 7,
      'seats': 6,
      'image': 'https://i.postimg.cc/sX4TCmvv/table-6-removebg-preview.png'
    },
    {
      'id': 8,
      'seats': 6,
      'image': 'https://i.postimg.cc/sX4TCmvv/table-6-removebg-preview.png'
    },
  ];

  void onSelectTable(int id) {
    setState(() {
      selectedTable = id;
    });

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.8,
        maxChildSize: 0.95,
        minChildSize: 0.5,
        expand: false,
        builder: (context, scrollController) => Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: SingleChildScrollView(
            controller: scrollController,
            child: FinalReservationDetailsForm(selectedTable: id),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(S.of(context).selectYourTable),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          itemCount: tables.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
          ),
          itemBuilder: (context, index) {
            final table = tables[index];
            return GestureDetector(
              onTap: () => onSelectTable(table['id']),
              child: Card(
                color: selectedTable == table['id']
                    ? ColorsUtility.errorSnackbarColor
                    : Theme.of(context).scaffoldBackgroundColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        table['image'],
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '${S.of(context).selectseats} ${table['id']}',
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
