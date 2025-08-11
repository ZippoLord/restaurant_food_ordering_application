import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_order_app/controllers/password_controller.dart';
import 'package:get/get.dart';

class PasswordVerificationTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String hintText;

  const PasswordVerificationTextField({
    super.key,
    this.controller,
    this.hintText = "Jelszó újra",
  });

  @override
  Widget build(BuildContext context) {
    final passwordVerController = Get.put(PasswordVerificationController());

    return Obx(() => Padding(
      padding: const EdgeInsets.all(12.0),
      child: TextFormField(
            controller: controller,
            obscureText: passwordVerController.password.value,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(6),
              prefixIcon: const Icon(Icons.lock, color: Colors.black),
              suffixIcon: IconButton(
                icon: Icon(
                  passwordVerController.password.value
                      ? Icons.visibility_off
                      : Icons.visibility,
                  color: Colors.black,
                ),
                onPressed: passwordVerController.togglePasswordVisibility,
              ),
              enabledBorder:  OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(color: Colors.grey),
              ),
              focusedBorder:  OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(color: Colors.red),
              ),
              hintText: hintText,
              hintStyle: const TextStyle(color: Colors.black),
            ),
          ),
    ));
  }
}
