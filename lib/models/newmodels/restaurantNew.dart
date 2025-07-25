import 'dart:convert';

RestaurantNew restaurantNewFromJson(String str) => RestaurantNew.fromJson(json.decode(str));

class RestaurantNew {
    final String id;
    final String title;
    final String time;
    final String imageUrl;
    final List<dynamic> foods;
    final bool pickup;
    final bool delivery;
    final bool isAvailable;
    final String code;
    final int rating;
    final String vertification;
    final Coords coords;

    RestaurantNew({
        required this.id,
        required this.title,
        required this.time,
        required this.imageUrl,
        required this.foods,
        required this.pickup,
        required this.delivery,
        required this.isAvailable,
        required this.code,
        required this.rating,
        required this.vertification,
        required this.coords,
    });

    factory RestaurantNew.fromJson(Map<String, dynamic> json) => RestaurantNew(
        id: json["_id"],
        title: json["title"],
        time: json["time"],
        imageUrl: json["imageUrl"],
        foods: List<Food>.from(json["foods"].map((x) => Food.fromJson(x))),
        pickup: json["pickup"],
        delivery: json["delivery"],
        isAvailable: json["isAvailable"],
        code: json["code"],
        rating: json["rating"]?.toDouble(),
        vertification: json["vertification"],
        coords: Coords.fromJson(json["coords"]),
    );

}

class Coords {
    final String id;
    final double latitude;
    final double longitude;
    final double latitudeDelta;
    final double longitudeDelta;

    Coords({
        required this.id,
        required this.latitude,
        required this.longitude,
        required this.latitudeDelta,
        required this.longitudeDelta,
    });

    factory Coords.fromJson(Map<String, dynamic> json) => Coords(
        id: json["id"],
        latitude: json["latitude"]?.toDouble(),
        longitude: json["longitude"]?.toDouble(),
        latitudeDelta: json["latitudeDelta"]?.toDouble(),
        longitudeDelta: json["longitudeDelta"]?.toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "latitude": latitude,
        "longitude": longitude,
        "latitudeDelta": latitudeDelta,
        "longitudeDelta": longitudeDelta,
    };
}

class Food {
    final String name;
    final double price;

    Food({
        required this.name,
        required this.price,
    });

    factory Food.fromJson(Map<String, dynamic> json) => Food(
        name: json["name"],
        price: json["price"]?.toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "price": price,
    };
}
