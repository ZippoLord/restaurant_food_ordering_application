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
}

