import 'package:meta/meta.dart';
import 'dart:convert';

List<AdditiveModel> additiveModelFromJson(String str) =>
    List<AdditiveModel>.from(
      json.decode(str).map((x) => AdditiveModel.fromJson(x)),
    );

String additiveModelToJson(AdditiveModel data) => json.encode(data.toJson());

class AdditiveModel {
    final String id;
    final String title;
    final int price;

    AdditiveModel({
        required this.id,
        required this.title,
        required this.price,
    });

    factory AdditiveModel.fromJson(Map<String, dynamic> json) => AdditiveModel(
        id: json["_id"],
        title: json["title"],
        price: json["price"],
    );

     @override
  String toString() => 'Additive(title: $title, price: $price Ft)';

    Map<String, dynamic> toJson() => {
        "_id": id,
        "title": title,
        "price": price,
    };
}
