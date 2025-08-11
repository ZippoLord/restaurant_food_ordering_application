import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_utils/src/get_utils/get_utils.dart';

class EmailTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String hintText;

  const EmailTextField({
    super.key,
    this.controller,
    this.hintText = "Email",
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(12.0.h),
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.emailAddress,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Adj meg helyes email címet";
          } else if (!GetUtils.isEmail(value)) {
            return "Érvénytelen email formátum";
          }
          return null;
        },
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(12.h),
          prefixIcon: const Icon(Icons.email, color: Colors.black),
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
    );
  }
}
