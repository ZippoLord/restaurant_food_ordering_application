import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/password_controller.dart';

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
    final passwordController = Get.find<PasswordController>();

    return Obx(() => Padding(
      padding: const EdgeInsets.all(12.0),
      child: TextFormField(
        controller: controller,
        obscureText: passwordController.password.value,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(6),
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
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12), // nagyobb border radius
            borderSide: const BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.red),
          ),
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.black),
        ),
      ),
    ));
  }
}
