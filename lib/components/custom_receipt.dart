import 'package:flutter/material.dart';
import 'package:food_order_app/models/restaurant.dart';
import 'package:provider/provider.dart';

class CustomReceipt extends StatelessWidget {
  const CustomReceipt({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 25, right: 25, bottom: 25, top: 50),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Köszönjük a rendelésed!"),
            const SizedBox(height: 25),
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).colorScheme.secondary
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: EdgeInsets.all(25),
              child: Consumer<Restaurant>(
                builder: (context, restaurant, child) => Text(restaurant.displayCartReceipt()),
              ),
            ),
            const SizedBox(height: 25),
          ],
        ),
      ),
    );
  }
}
