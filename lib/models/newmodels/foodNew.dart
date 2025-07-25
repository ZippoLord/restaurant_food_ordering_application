import 'dart:convert';

List<FoodModel> FoodModelFromJson(String str) => List<FoodModel>.from(json.decode(str).map((x) => FoodModel.fromJson(x)));

String FoodModelToJson(List<FoodModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class FoodModel {
    final String id;
    final String title;
    final List<String> foodType;
    final String code;
    final bool isAvailable;
    final String restaurant;
    final double rating;
    final String ratingCount;
    final double price;
    final List<Additive> additives;
    final List<String> imageUrl;
    final String category;
    final String time;

    FoodModel({
        required this.id,
        required this.title,
        required this.time,
        required this.isAvailable,
        required this.foodType,
        required this.category,
        required this.code,
        required this.imageUrl,
        required this.restaurant,
        required this.rating,
        required this.ratingCount,
        required this.price,
        required this.additives,
    });

    factory FoodModel.fromJson(Map<String, dynamic> json) => FoodModel(
        id: json["_id"],
        title: json["title"],
        time: json["time"],
        isAvailable: json["isAvailable"],
        foodType: List<String>.from(json["additives"].map((x) => x)),
        category: json["category"],
        code: json["code"],
        imageUrl: List<String>.from(json["imageUrl"].map((x) => x)),
        restaurant: json["restaurant"],
        rating: json["rating"]?.toDouble(),
        ratingCount: json["ratingCount"],
        price: json["price"],
        additives: List<Additive>.from(json["additives"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "title": title,
        "time": time,
        "isAvailable": isAvailable,
        "foodType": List<dynamic>.from(imageUrl.map((x) => x)),
        "category": category,
        "code": code,
        "imageUrl": List<dynamic>.from(imageUrl.map((x) => x)),
        "restaurant": restaurant,
        "rating": rating,
        "ratingCount": ratingCount,
        "price": price,
        "additives": List<dynamic>.from(additives.map((x) => x)),
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