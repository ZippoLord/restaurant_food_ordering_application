import 'package:food_order_app/models/food.dart';
import 'package:food_order_app/models/newmodels/additive_model.dart';
import 'package:food_order_app/models/newmodels/food_model.dart';

class CartItem {
  FoodModel food;
  List<AdditiveModel> selectedAddons;
  int quantity;

  CartItem({
    required this.food,
    required this.selectedAddons,
    this.quantity = 1,
  });
  double get totalPrice {
    double basePrice = food.price;
    double addonsPrice = selectedAddons.fold(0, (sum, addon) => sum + addon.price);
    return (basePrice + addonsPrice) * quantity;
  }

  Map<String, dynamic> toJson() {
    return {
      'food': food.toJson(),
      //'addons': selectedAddons.map((a) => a.toJson()).toList(),
      'quantity': quantity,
    };
  }
}