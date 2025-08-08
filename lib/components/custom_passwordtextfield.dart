import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_order_app/controllers/password_controller.dart';
import 'package:get/get.dart';

class PasswordTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String hintText;

  const PasswordTextField({
    super.key,
    this.controller,
    this.hintText = "Jelszó",
  });

  @override
  Widget build(BuildContext context) {
    final passwordController = Get.put(PasswordController());

    return Obx(() => Padding(
      padding: const EdgeInsets.all(12.0),
      child: TextFormField(
            controller: controller,
            obscureText: passwordController.password.value,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Adj meg helyes jelszót";
              }
              return null;
            },
            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(6),
              prefixIcon: const Icon(Icons.lock, color: Colors.black),
              suffixIcon: IconButton(
                icon: Icon(
                  passwordController.password.value
                      ? Icons.visibility_off
                      : Icons.visibility,
                  color: Colors.black,
                ),
                onPressed: passwordController.togglePasswordVisibility,
              ),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
              ),
              hintText: hintText,
              hintStyle: const TextStyle(color: Colors.black),
            ),
          ),
    ));
  }
}
