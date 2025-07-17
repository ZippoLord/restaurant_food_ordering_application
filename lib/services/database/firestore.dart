import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:food_order_app/models/cart_item.dart';
import 'package:food_order_app/models/food.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../models/appUser.dart';

class FirestoreService {
  // get collection of orders

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference orders = FirebaseFirestore.instance.collection('orders');
  
  
  
    // save order to db
  Future<void> saveOrderToDatabase(List<Map<String, dynamic>> cartItemsJson) async {
       try {
      int totalPrice = 0;
      for (var itemJson in cartItemsJson) {
      final foodPrice = itemJson['food']['price'] as int;
      final quantity = itemJson['quantity'] as int;
      
      // Addonok összeadása:
      final addons = itemJson['selectedAddons'] as List<dynamic>? ?? [];
      int addonsTotal = 0;
      for (var addon in addons) {
        addonsTotal += addon['price'] as int;
      }

      totalPrice += (foodPrice + addonsTotal) * quantity;
    }
      await orders.add({
        'timestamp': DateTime.now(),
        'totalPrice': totalPrice,
        'items': cartItemsJson,
      });
       print("Sikerult a mentes");
    } catch (e) {
      print("❌ Hiba a mentés során: $e");
    }
  }
 
  Future<List<Food>> getAllFoodFromDatabase() async {
  try {
    final snapshot = await _firestore.collection('foods').get();

    List<Food> _foods = [];

    for (var doc in snapshot.docs) {
      final data = doc.data();
      final String rawImage = data['imagePath'] ?? '';
      String imageUrl = '';

      if (rawImage.isNotEmpty) {
        try {
          imageUrl = await FirebaseStorage.instance.ref(rawImage).getDownloadURL();
        } catch (e) {
          print("❌ Hiba az URL lekérésénél: $e");
        }
      }

      final food = Food(
        name: data['name'] ?? '',
        description: data['description'] ?? '',
        price: data['price'] ?? 0, 
        foodCategory: categoryFromString(data['foodCategory'] ?? ''),
        imagePath: imageUrl,
        availableAddons: (data['addons'] as List<dynamic>?)
                ?.map((addon) => Addon.fromJson(addon as Map<String, dynamic>))
                .toList() ??
            [],
      );

      _foods.add(food);
    }

    print("✅ Sikeres lekérés: ${_foods.length} étel");
    return _foods;
  } catch (e) {
    print("❌ Hiba a getAllFood-nál: $e");
    return [];
  }
}

}

