// food item
class Food {
  final String name;
  final String description;
  final String imagePath;
  String? imageUrl;
  final int price;
  final FoodCategory foodCategory;
  List<Addon>? availableAddons;

  Food({
    required this.name,
    required this.description,
    required this.imagePath,
    this.imageUrl,
    required this.price,
    required this.foodCategory,
    this.availableAddons,
  });


  factory Food.fromJson(Map<String, dynamic> json) {
    return Food(
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      imagePath: json['imagePath'] ?? '',
      price: json['price'] ?? 0,
      foodCategory: categoryFromString(json['foodCategory'] ?? ''),
      availableAddons: (json['addons'] as List<dynamic>?)
              ?.map((addon) => Addon.fromJson(addon as Map<String, dynamic>))
              .toList() ??
          [],
    ); 
}

  Map<String, dynamic> toJson() =>{
    'name': name,
    'description': description,
    'imagePath': imagePath,
    'price': price,
    'foodCategory': foodCategory.displayName,
    'addons': availableAddons?.map((a) => a.toJson()).toList()
    };

      @override
    String toString() {
      return 'Food(name: $name, price: $price, category: ${foodCategory.name}, addons: ${availableAddons?.map((a) => a.name).join(", ")})';
    }
  }

// food categories
enum FoodCategory {
  burgerek,
  salatak,
  koretek,
  italok,
  pizzak;
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
    }
  }
}

// food addons
class Addon {
  final String? name;
  final int price;
  
  Addon({
    required this.name,
    required this.price,
  });


  factory Addon.fromJson(Map<String, dynamic> json){
    return Addon(
      name: json['name'] ?? '',
      price: json['price'] ?? 0
    );
  }
    Map<String, dynamic> toJson() => {
    'name': name,
    'price': price,
  };
}