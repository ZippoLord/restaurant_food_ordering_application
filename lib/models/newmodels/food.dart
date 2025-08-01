import 'dart:convert';

List<FoodModel> foodModelFromJson(String str) {
  final decoded = json.decode(str) as List<dynamic>;
  return decoded.map((x) => FoodModel.fromJson(x)).toList();
}

String foodModelToJson(List<FoodModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class FoodModel {
  final String id;
  final String title;
  final String time;
  final String code;
  final String imageUrl;
  final String restaurant;
  final double rating;
  final String ratingCount;
  final double price;
  final String description;
  final List<String> additives;
  final String category;

  FoodModel({
    required this.id,
    required this.title,
    required this.time,
    required this.code,
    required this.description,
    required this.imageUrl,
    required this.restaurant,
    required this.rating,
    required this.ratingCount,
    required this.price,
    required this.additives,
    required this.category,
  });

    
  factory FoodModel.fromJson(Map<String, dynamic> json) => FoodModel(
        id: json["_id"],
        title: json["title"],
        time: json["time"],
        code: json["code"],
        description: json["description"],
        imageUrl: json["imageUrl"],
        restaurant: json["restaurant"],
        rating: (json["rating"] ?? 0).toDouble(),
        ratingCount: json["ratingCount"],
        price: (json["price"] ?? 0).toDouble(),
        additives: json["additives"] != null 
      ? List<String>.from(json["additives"]) 
      : [],
        category: json["category"],
      );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "title": title,
        "time": time,
        "category": category,
        "code": code,
        "description" : description,
        "imageUrl": imageUrl,
        "restaurant": restaurant,
        "rating": rating,
        "ratingCount": ratingCount,
        "price": price,
        "additives": List<dynamic>.from(additives),
    };
}


class Additive {
  final int id;
  final String title;
  final String price;

  Additive({required this.id, required this.title, required this.price});

  factory Additive.fromJson(Map<String, dynamic> json) =>Additive(
    id: json["id"],
    title: json["title"],
    price: json["price"],
  );

  Map<String, dynamic> toJson() =>{
    "id": id,
    "title": title,
    "price": price,
  };

}