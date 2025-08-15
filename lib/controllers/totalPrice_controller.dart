// restaurant_extensions.dart
import 'package:food_order_app/models/restaurant.dart';


String calculateTotalPrice(Restaurant restaurant) {
  num total = 0;
  for (final item in restaurant.cart) {
    final basePrice = item.food.price * item.quantity;
    final addonTotal = item.selectedAddons.fold<num>(
      0.0,
      (sum, addon) => sum + (addon.price * item.quantity),
    );
    total += basePrice + addonTotal;
  }
  return total.toStringAsFixed(0);
}
