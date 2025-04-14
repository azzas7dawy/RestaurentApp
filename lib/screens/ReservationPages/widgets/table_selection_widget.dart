import 'package:flutter/material.dart';

class TableSelection extends StatelessWidget {
  final int? selectedTable;
  final Function(int) onSelectTable;

  TableSelection({required this.selectedTable, required this.onSelectTable});

  final List<Map<String, dynamic>> tables = [
    {'id': 1, 'seats': 4, 'image': 'https://i.postimg.cc/fR12ckGT/table-4-removebg-preview.png'},
    {'id': 2, 'seats': 4, 'image': 'https://i.postimg.cc/fR12ckGT/table-4-removebg-preview.png'},
    {'id': 3, 'seats': 4, 'image': 'https://i.postimg.cc/fR12ckGT/table-4-removebg-preview.png'},
    {'id': 4, 'seats': 4, 'image': 'https://i.postimg.cc/fR12ckGT/table-4-removebg-preview.png'},
    {'id': 5, 'seats': 4, 'image': 'https://i.postimg.cc/fR12ckGT/table-4-removebg-preview.png'},
    {'id': 6, 'seats': 4, 'image': 'https://i.postimg.cc/fR12ckGT/table-4-removebg-preview.png'},
    {'id': 7, 'seats': 6, 'image': 'https://i.postimg.cc/sX4TCmvv/table-6-removebg-preview.png'},
    {'id': 8, 'seats': 6, 'image': 'https://i.postimg.cc/sX4TCmvv/table-6-removebg-preview.png'},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              'Select a Table',
              style: TextStyle(color: Colors.black, fontSize: 24),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            GridView.builder(
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1,
              ),
              itemCount: tables.length,
              itemBuilder: (context, index) {
                final table = tables[index];
                return GestureDetector(
                  onTap: () => onSelectTable(table['id']),
                  child: Card(
                    color: selectedTable == table['id'] ? Colors.red : Colors.black,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.network(table['image'], width: 100, height: 100),
                        Text(
                          'Table ${table['id']}',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
