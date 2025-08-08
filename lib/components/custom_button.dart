import 'package:flutter/material.dart';
import 'package:food_order_app/controllers/password_controller.dart';

class CustomButton extends StatelessWidget {
  final Function()? onTap;
  final String text;

  const CustomButton({
    super.key,
    required this.onTap,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    print(PasswordController().password);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(25),
        margin: const EdgeInsets.symmetric(horizontal: 25),
        decoration: 
          BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
            borderRadius: BorderRadius.circular(8),
          ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.inversePrimary,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}