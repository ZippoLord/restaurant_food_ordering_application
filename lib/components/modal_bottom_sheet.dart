import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ModalBottomSheet extends StatelessWidget {
  final int? orderNumber;

  const ModalBottomSheet({super.key, required this.orderNumber});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        mainAxisSize: MainAxisSize.min, 
        children: [
          const Text(
            "Köszönjük, rendelését rögzítettük",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Lottie.asset(
            "lib/images/loaders/Preparing Food.json",
            height: 220,
            width: 220,
            fit: BoxFit.contain,
            repeat: false,
          ),
          const SizedBox(height: 12),
          const Text(
            "Rendelés szám",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              height: 90,
              width: 80,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
              color: Colors.red,
                border: Border.all(color: Colors.red, width: 2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(child: Text("${orderNumber.toString()}", style: TextStyle(fontSize: 22, color: Colors.white, fontWeight: FontWeight.bold))),
            ),
          ),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Bezár"),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
