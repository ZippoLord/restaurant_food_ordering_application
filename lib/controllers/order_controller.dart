import 'package:food_order_app/constants.dart';
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
