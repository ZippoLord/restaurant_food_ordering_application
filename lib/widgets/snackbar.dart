import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showAppSnackbar(String title, {String? message, Color? backgroundColor}) {
  Get.snackbar(
    '',
    '',
    titleText: Center(
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    ),
    messageText: message != null
        ? Center(
            child: Text(
              message,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w400),
            ),
          )
        : const SizedBox.shrink(),
    snackPosition: SnackPosition.BOTTOM,
    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    padding: const EdgeInsets.all(16),
    duration: const Duration(seconds: 2),
    backgroundColor: backgroundColor ?? Colors.red.shade400,
    borderRadius: 12,
    animationDuration: const Duration(milliseconds: 300),
    isDismissible: true,
    forwardAnimationCurve: Curves.easeOut,
  );
}
