import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'package:food_order_app/constants.dart';
import 'package:food_order_app/models/newmodels/order_model.dart';
import 'package:food_order_app/models/newmodels/apiError.dart';
import 'package:food_order_app/controllers/login_controller.dart';

class OrdersController extends GetxController {
  var orders = <OrderModel>[].obs;         // RxList az összes rendeléshez
  var isLoading = false.obs;
  var error = Rxn<Exception>();
  var apiError = Rxn<ApiError>();

  late IO.Socket socket;
  final token = box.read("token");

  @override
  void onInit() {
    super.onInit();
    fetchOrders();
    _setupSocket();
  }

  Future<void> fetchOrders() async {
    isLoading.value = true;
    try {
      final response = await http.get(
        Uri.parse('$baseURL/api/orders/getUserOrders'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> decoded = jsonDecode(response.body);

        if (decoded['status'] == true && decoded['message'] is List) {
          // Az összes rendelés
          final fetchedOrders = (decoded['message'] as List)
              .map((x) => OrderModel.fromJson(x))
              .toList();

          orders.value = fetchedOrders;
        }
      } else {
        apiError.value = apiErrorFromJson(response.body);
      }
    } catch (e) {
      error.value = e as Exception;
    } finally {
      isLoading.value = false;
    }
  }

  void _setupSocket() {
    socket = IO.io(
      'http://10.0.2.2:3000',
      <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': false,
        'extraHeaders': {'Authorization': 'Bearer $token'},
      },
    );

    socket.connect();
    socket.on('connect', (_) => print('Socket connected ✅'));

 socket.on('orderUpdated', (data) {
  final updatedOrder = OrderModel.fromJson(data);

  final index = orders.indexWhere((o) => o.orderNumber == updatedOrder.orderNumber);

  if (index != -1) {
    // Frissítjük a meglévő rendelést
    orders[index] = updatedOrder;
  } else {
    // Ha új és Pending → hozzáadjuk
    if (updatedOrder.deliveryStatus == "Pending") {
      orders.add(updatedOrder);
    }
  }

});

}

  @override
  void onClose() {
    socket.dispose();
    super.onClose();
  }
}
