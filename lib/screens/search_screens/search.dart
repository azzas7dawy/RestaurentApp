import 'package:flutter/material.dart';


class SearchScreen extends StatelessWidget {
   static const String id = "SearchScreen";
  final List<String> searchSuggestions = [
    "Pizza",
    "Burger",
    "Pasta",
    "Sushi",
    "Salad",
    "Steak",
    "Sandwich",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("Search"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔍 صندوق البحث
            Autocomplete<String>(
              optionsBuilder: (TextEditingValue textEditingValue) {
                if (textEditingValue.text.isEmpty) {
                  return const Iterable<String>.empty();
                }
                return searchSuggestions.where((suggestion) =>
                    suggestion.toLowerCase().contains(textEditingValue.text.toLowerCase()));
              },
              fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
                return TextField(
                  controller: controller,
                  focusNode: focusNode,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[900],
                    hintText: "Search",
                    hintStyle: TextStyle(color: Colors.grey),
                    prefixIcon: Icon(Icons.search, color: Colors.white),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                );
              },
              onSelected: (String selection) {
                print('User selected: $selection');
              },
            ),

            SizedBox(height: 20),

            // ⏳ "Repeat last order" & "Help me choose"
            Row(
              children: [
                Icon(Icons.refresh, color: Colors.white),
                SizedBox(width: 10),
                Text("Repeat last order", style: TextStyle(color: Colors.white)),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.help_outline, color: Colors.white),
                SizedBox(width: 10),
                Text("Help me choose", style: TextStyle(color: Colors.white)),
              ],
            ),

            SizedBox(height: 20),

            // 🖼️ نتائج البحث أو اقتراحات أخرى (وهمية حالياً)
            Expanded(
              child: ListView(
                children: searchSuggestions.map((item) {
                  return ListTile(
                    title: Text(item, style: TextStyle(color: Colors.white)),
                    leading: Icon(Icons.fastfood, color: Colors.white),
                    onTap: () {
                      print("Selected: $item");
                    },
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
