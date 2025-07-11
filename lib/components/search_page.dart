import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final SearchController _searchController = SearchController();

  final List<String> items = [
    "Pizza",
    "Burger",
    "Saláta",
    "Tészta",
    "Ital",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Ételek keresése")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SearchAnchor.bar(
          searchController: _searchController,
          barHintText: 'Termék keresése',
          suggestionsBuilder: (context, controller) {
            final query = controller.text.toLowerCase();
            final filteredItems = items
                .where((item) => item.toLowerCase().contains(query))
                .toList();

            return filteredItems.map((item) {
              return ListTile(
                title: Text(item),
                onTap: () {
                  controller.closeView(item);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Kiválasztva: $item')),
                  );
                },
              );
            });
          },
        ),
      ),
    );
  }
}
