// food item
class Food {
  final String name;
  final String description;
  final String imagePath;
  String? imageUrl;
  final int price;
  final FoodCategory foodCategory;

  Food({
    required this.name,
    required this.description,
    required this.imagePath,
    this.imageUrl,
    required this.price,
    required this.foodCategory,
  });


  factory Food.fromJson(Map<String, dynamic> json) {
    return Food(
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      imagePath: json['imagePath'] ?? '',
      price: json['price'] ?? 0,
      foodCategory: categoryFromString(json['foodCategory'] ?? ''),
    ); 
}

  Map<String, dynamic> toJson() =>{
    'name': name,
    'description': description,
    'imagePath': imagePath,
    'price': price,
    'foodCategory': foodCategory.displayName,
    };

  }

// food categories
enum FoodCategory {
  burgerek,
  salatak,
  koretek,
  italok,
  pizzak,
  menuk,
}

FoodCategory categoryFromString(String value) {
    return FoodCategory.values.firstWhere(
      (e) => e.name.toLowerCase() == value.toLowerCase(),
      orElse: () => FoodCategory.burgerek, 
    );
}


extension FoodCategoryExtension on FoodCategory {
  String get displayName {
    switch (this) {
      case FoodCategory.burgerek:
        return "Burgerek";
      case FoodCategory.salatak:
        return "Saláták";
      case FoodCategory.koretek:
        return "Köretek";
      case FoodCategory.italok:
        return "Italok";
      case FoodCategory.pizzak:
        return "Pizzák";
       case FoodCategory.menuk:
        return "Menük";
    }
  }
}
