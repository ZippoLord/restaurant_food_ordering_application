import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:food_order_app/constants.dart';
import 'package:food_order_app/models/newmodels/apiError.dart';
import 'package:food_order_app/models/newmodels/login_model.dart';
import 'package:food_order_app/models/newmodels/login_response.dart';
import 'package:food_order_app/pages/home_page.dart';
import 'package:food_order_app/pages/main_screen.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;



final box = GetStorage();
class RegisterController extends GetxController {
  RxBool _isLoading = false.obs;

  bool get isLoading => _isLoading.value;

  set setLoading(bool newState){
    _isLoading.value = newState; 
  }

  void registerFunction (String data)  async {
    setLoading = true;

    Uri url = Uri.parse('$baseURL/api/auth/register');
    Map<String, String>   headers = {'Content-type' : 'application/json'};
    try {
      var response = await http.post(url,  headers: headers, body: data);
      if(response.statusCode == 201){
         setLoading = false;
        Get.snackbar("Sikeres regisztráció", "Sikeres regisztráció", 
        colorText: Colors.white, 
        backgroundColor: Colors.blue,);
        Get.offAll(() => MainScreen());
      }
      else{
        var error =apiErrorFromJson(response.body);
        Get.snackbar("Regisztráció sikertelen", error.message, colorText: Colors.white, 
        backgroundColor: Colors.redAccent,); //valami jobb szin
      }
    } catch (e) {
      print(e);
    }
  }
}
