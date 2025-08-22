import 'package:food_order_app/constants.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get_storage/get_storage.dart';

Future<void> placeOrder(Map<String, dynamic> orderData) async {
  final url  = Uri.parse('$baseURL/api/orders/placeOrder');
  final box = GetStorage();
  final token = box.read("token");
  final response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token', 
    },
    body: jsonEncode(orderData),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    print('Order created: ${data['message']}');
  } else {
    print('Failed to create order: ${response.body}');
  }
}


Future<int?> getLastOrderNumber() async {
  final url  = Uri.parse('$baseURL/api/orders/getUserOrders');
  final box = GetStorage();
  final token = box.read("token");
  final response = await http.get(
    url,
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token', 
    },
  );

  if (response.statusCode == 200) {
    final Map<String, dynamic> data = jsonDecode(response.body);

    final List<dynamic> orders = data['message']; 
    if (orders.isNotEmpty) {
      final lastOrder = orders.last as Map<String, dynamic>;
      return lastOrder['orderNumber'] as int; 
    }
    return null; // nincs rendelés
  } else {
    print('Failed to fetch orders: ${response.body}');
    return null;
  }
}
