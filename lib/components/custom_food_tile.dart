import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:food_order_app/models/newmodels/food_model.dart';

class FoodTile extends HookWidget {
  final FoodModel food;
  final void Function()? onTap;

  const FoodTile({
    super.key,
    required this.food,
    required this.onTap,
    });

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              children: [
                // text food details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(food.title, style: TextStyle(fontWeight: FontWeight.w500),),

                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 5,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.deepOrange,
                        ),
                        child: Text(
                          "${food.price.toInt()} Ft",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),

                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        food.description,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.inversePrimary,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 15),

                // food image
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child:Image.network(
                  food.imageUrl,
                  height: 120, 
                  width: 120,
                  fit: BoxFit.cover, 
                  loadingBuilder:
                   (context, child, loadingProgress) 
                   {
                      if(loadingProgress == null) return child; 
                      return SizedBox(height: 80, width: 80, child: Center(child: CircularProgressIndicator()));
                   },
                   errorBuilder: (context, error, StackTrace) => Container(
                    height: 120,
                    width: 120,
                    color: Colors.grey[200],
                    child: Icon(Icons.broken_image),
                   ),
                  ) 
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}