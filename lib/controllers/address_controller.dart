import 'dart:convert';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:food_order_app/controllers/login_controller.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:food_order_app/constants.dart';
import 'package:food_order_app/models/address.dart';
import 'package:food_order_app/models/newmodels/address_model.dart';
import 'package:food_order_app/models/newmodels/apiError.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class AddressController extends GetxController {
  
  RxList<AddressModel> addresses = <AddressModel>[].obs;
  RxString selectedAddress = ''.obs;
  RxnString selectedAddressId = RxnString();
  var isLoading = false.obs;
  var error = ''.obs;

    Future<void> fetchAddresses(String token, String userId) async {
    try {
      isLoading.value = true;
      final response = await http.get(
        Uri.parse('$baseURL/api/address/getAllAddress'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );


        print("Response status: ${response.statusCode}");
        print("Response body: ${response.body}");


     if (response.statusCode == 200) {
          final Map<String, dynamic> data = jsonDecode(response.body);
          print("Decoded: ${data['addresses']}");
          addresses.value = (data['addresses'] as List)
              .map((json) => AddressModel.fromJson(json))
              .toList();
        }else{
            final apiError = apiErrorFromJson(response.body);
            error.value = apiError.message;
        }
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

    Future<void> addAddress(newAddress, token, userId) async {
        final jsonBody = newAddress.toJson();
        try {
          final response = await http.post(
            Uri.parse('$baseURL/api/address/addAddress'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token', 
            },
            body: jsonEncode({
              'userId': userId,  
              ...jsonBody,
            }),
          );

            if (response.statusCode == 201) {
              Get.snackbar("Hozzáadva", "A cím sikeresen hozzáadva");
              fetchAddresses(token, userId); 
            } else {
              final error = apiErrorFromJson(response.body);
              Get.snackbar("Hiba", error.message);
            }
        } catch (e) {
          Get.snackbar("Hiba", "Nem sikerült a cím hozzáadása");
          print(e);
        }
      }
    
    Future<void> deleteAddressById(addressId, userId, token) async {
      try {
        final response = await http.delete(
          Uri.parse('$baseURL/api/address/deleteAddress/$addressId'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token', 
          },
        );
        if (response.statusCode == 200) {
          Get.snackbar("Sikeres", "A cím sikeresen törölve");
        } else {
          final error = apiErrorFromJson(response.body);
          Get.snackbar("Hiba", error.message);
        }
      } catch (e) {
        Get.snackbar("Hiba", "Nem sikerült a cím törlése");
        print(e);
      }
      await fetchAddresses(token, userId);
    }

    Future<void> setDefaultAddress(String id) async {
      final token = box.read("token");
      final userId = box.read("userId");
    try {
          final response = await http.patch(
            Uri.parse('$baseURL/api/address/setDefaultAddress/$id'),
            headers: {
              'Authorization': 'Bearer $token', 
            },
          );
          if (response.statusCode == 200) {
            Get.snackbar("Sikeres", "A cím sikeresen beállítva alapértelmezettként");
          } else {
            final error = apiErrorFromJson(response.body);
            Get.snackbar("Hiba", error.message);
          }
        } catch (e) {
          Get.snackbar("Hiba", "Nem sikerült a cím törlése");
          print(e);
        }
        await fetchAddresses(token, userId);
      }
}
