import 'package:flutter/material.dart';

import 'package:restrant_app/screens/reserveTableScreen/reservation_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RestaurantBottomSheet extends StatefulWidget {
  @override
  _RestaurantBottomSheetState createState() => _RestaurantBottomSheetState();
}

class _RestaurantBottomSheetState extends State<RestaurantBottomSheet> {
  String selectedCity = 'Calicut';
  Map<String, String>? selectedRestaurant;

  final Map<String, List<Map<String, String>>> restaurantsByCity = {
    'Calicut': [
      {
        'name': 'Paragon Restaurant',
        'address': 'Kannur road, Near CH over bridge',
      },
      {
        'name': 'M Grill - Paragon Group',
        'address': 'Focus Mall, Rajaji Road',
      },
      {
        'name': 'Brown Town - Paragon Group',
        'address': 'Pottamal Junction, Pottamal',
      },
    ],
    'Kochi': [],
    'Trivandrum': [],
  };

  @override
  void initState() {
    super.initState();
    loadSelectedData();
  }

  Future<void> loadSelectedData() async {
    final prefs = await SharedPreferences.getInstance();
    final city = prefs.getString('selectedCity');
    final restaurantName = prefs.getString('selectedRestaurantName');
    final restaurantAddress = prefs.getString('selectedRestaurantAddress');

    if (city != null && restaurantName != null && restaurantAddress != null) {
      setState(() {
        selectedCity = city;
        selectedRestaurant = {
          'name': restaurantName,
          'address': restaurantAddress,
        };
      });
    }
  }

  Future<void> saveSelectedData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedCity', selectedCity);
    if (selectedRestaurant != null) {
      await prefs.setString('selectedRestaurantName', selectedRestaurant!['name']!);
      await prefs.setString('selectedRestaurantAddress', selectedRestaurant!['address']!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cityRestaurants = restaurantsByCity[selectedCity]!;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("Select your city", style: TextStyle(color: Colors.white)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: restaurantsByCity.keys.map((city) {
              return ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: selectedCity == city ? Colors.red : Colors.grey[800],
                ),
                onPressed: () {
                  setState(() {
                    selectedCity = city;
                    selectedRestaurant = null;
                  });
                },
                child: Text(city, style: TextStyle(color: Colors.white)),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          Text("Select the restaurant", style: TextStyle(color: Colors.white)),
          ...cityRestaurants.map((restaurant) {
            bool isSelected = selectedRestaurant?['name'] == restaurant['name'];
            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedRestaurant = restaurant;
                });
              },
              child: Card(
                color: isSelected ? Colors.red[800] : Colors.grey[850],
                child: ListTile(
                  title: Text(restaurant['name']!, style: TextStyle(color: Colors.white)),
                  subtitle: Text(restaurant['address']!, style: TextStyle(color: Colors.white)),
                ),
              ),
            );
          }).toList(),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              saveSelectedData();
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[900]),
            child: InkWell(
                onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)
                => ReservationPage()));
                },
                child: Text("NEXT", style: TextStyle(color: Colors.white))),
          )
        ],
      ),
    );
  }
}