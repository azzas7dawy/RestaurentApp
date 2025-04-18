import 'package:flutter/material.dart';

import 'confirmation_screen.dart';


void showCateringBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return CateringSheetContent();
    },
  );
}

class CateringSheetContent extends StatefulWidget {
  @override
  _CateringSheetContentState createState() => _CateringSheetContentState();
}

class _CateringSheetContentState extends State<CateringSheetContent> {
  int selectedDayIndex = 0;
  int selectedPeopleIndex = 1;

  final List<String> days = ['2', '3', '4', '5', '6', '7', '8'];
  final List<String> peopleOptions = ['Less than 50', 'Less than 100', 'Less than 250'];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
         
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Hello, Arti!", style: TextStyle(color: Colors.white70)),
                  SizedBox(height: 10),
                  Text(
                    "Place catering\norders with us.",
                    style: TextStyle(
                      fontSize: 28,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Select the date for reservation", style: TextStyle(color: Colors.white70)),
                      Text("Jan 2 - 8 ▶", style: TextStyle(color: Colors.white54)),
                    ],
                  ),
                  SizedBox(height: 10),
                  SizedBox(
                    height: 50,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: days.length,
                      itemBuilder: (context, index) {
                        final isSelected = index == selectedDayIndex;
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isSelected ? Colors.red : Colors.black54,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                selectedDayIndex = index;
                              });
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(days[index], style: TextStyle(color: Colors.white)),
                                if (index == 0)
                                  Text("Tue", style: TextStyle(color: Colors.white, fontSize: 12)),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 30),
                  Text("Expected number of people", style: TextStyle(color: Colors.white70)),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(peopleOptions.length, (index) {
                      return _peopleButton(peopleOptions[index], isSelected: selectedPeopleIndex == index, index: index);
                    }),
                  ),
                  SizedBox(height: 30),
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white12,
                        fixedSize: Size(double.infinity, 60),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      onPressed: () {
                       showConfirmationSheet(context);
                      },
                      child: Text("NEXT", style: TextStyle(color: Colors.white, fontSize: 16)),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _peopleButton(String text, {required bool isSelected, required int index}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: isSelected ? Colors.red : Colors.white12,
            padding: EdgeInsets.symmetric(vertical: 15),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          onPressed: () {
            setState(() {
              selectedPeopleIndex = index;
            });
          },
          child: Text(text, style: TextStyle(color: Colors.white, fontSize: 13)),
        ),
      ),
    );
  }
}
