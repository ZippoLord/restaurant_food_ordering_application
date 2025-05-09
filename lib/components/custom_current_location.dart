import 'package:flutter/material.dart';
import 'package:food_order_app/models/restaurant.dart';
import 'package:food_order_app/pages/address_picker_page.dart';
import 'package:provider/provider.dart';

class CustomCurrentLocation extends StatelessWidget {
  const CustomCurrentLocation({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 25.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Szállítási cím",
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 2),
          GestureDetector(
            onTap:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddressPicker(),
                  ),
                ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // address
                Flexible(
                  child: Consumer<Restaurant>(
                    builder:
                        (context, restaurant, child) => Text(
                          restaurant.deliveryAddress,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.inversePrimary,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                        ),
                  ),
                ),

                // drop down menu
                Icon(Icons.keyboard_arrow_down_rounded),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
