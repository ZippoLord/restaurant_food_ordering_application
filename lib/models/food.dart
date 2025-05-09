// food item
class Food {
  final String name;
  final String description;
  final String imagePath;
  final int price;
  final FoodCategory foodCategory;
  List<Addon> availableAddons;

  Food({
    required this.name,
    required this.description,
    required this.imagePath,
    required this.price,
    required this.foodCategory,
    required this.availableAddons,
  });
}

// food categories
enum FoodCategory {
  burgerek,
  salatak,
  koretek,
  italok,
}

// food addons
class Addon {
  String name;
  int price;

  Addon({
    required this.name,
    required this.price,
  });
}