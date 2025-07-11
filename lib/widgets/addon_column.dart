import 'package:flutter/material.dart';
import 'package:food_order_app/dimensions.dart';
import 'package:food_order_app/models/food.dart';

class AddonColumn extends StatelessWidget {
  final Map<Addon, bool> addons; 
  final void Function(Addon addon, bool selected) onSelectedChanged;
  const AddonColumn({super.key, required this.addons, required this.onSelectedChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: addons.entries.map((entry) {
        final addon = entry.key;
        final isSelected = entry.value;

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: FilterChip(
            label: Text("${addon.name} (+${addon.price} Ft)"),
            selected: isSelected,
            onSelected: (bool selected) {
              onSelectedChanged(addon, selected);
            },
            backgroundColor: Colors.grey[200],
            selectedColor: Colors.grey[300],
            labelStyle: TextStyle(
              color: Colors.black,
              fontSize: 14,
            )
          )
        );
      }).toList(),
    );
  }
}
