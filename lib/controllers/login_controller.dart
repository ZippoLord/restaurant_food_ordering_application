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
class LoginController extends GetxController {
  RxBool _isLoading = false.obs;

  bool get isLoading => _isLoading.value;

  set setLoading(bool newState){
    _isLoading.value = newState; 
  }

  void loginFunction (String data)  async {
    setLoading = true;

    Uri url = Uri.parse('$baseURL/api/auth/login');
    Map<String, String>   headers = {'Content-type' : 'application/json'};
    try {
      var response = await http.post(url,  headers: headers, body: data);
      if(response.statusCode == 200){
         LoginResponse data = loginResponseFromJson(response.body);
         String userId = data.id;
         String userData = jsonEncode(data);

         box.write("userData", userData);
         box.write("token", data.userToken);
         box.write("userId", data.id);

         setLoading = false;
        Get.snackbar("Sikeres bejelentkezés", "Ne hagyd üresen a kosarad", 
        colorText: Colors.white, 
        backgroundColor: Colors.orangeAccent,);
        Get.offAll(() => MainScreen());
      }
      else{
        var error =apiErrorFromJson(response.body);
        Get.snackbar("Nem sikerült a bejelentkezés", error.message, colorText: Colors.white, 
        backgroundColor: Colors.redAccent,); //valami jobb szin
      }
    } catch (e) {
      print(e);
    }
  }
}
