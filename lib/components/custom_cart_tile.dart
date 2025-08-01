import 'package:flutter/material.dart';
import 'package:food_order_app/components/custom_quantity_selector.dart';
import 'package:food_order_app/models/cart_item.dart';
import 'package:food_order_app/models/restaurant.dart';
import 'package:food_order_app/pages/food_page.dart';
import 'package:provider/provider.dart';

class CustomCartTile extends StatelessWidget {
  final CartItem cartItem;

  const CustomCartTile({super.key, required this.cartItem});

  @override
  Widget build(BuildContext context) {
    return Consumer<Restaurant>(
      builder:
          (context, restaurant, child) => Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(8),
            ),
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap:
                            () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => Container()
                                      // FoodPage(food: cartItem.food),
                              ),
                            ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.network(
                            cartItem.food.imagePath,
                            height: 100,
                            width: 100,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              cartItem.food.name,
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Container(
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: Colors.deepOrange,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  "${cartItem.food.price} Ft",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                            Text(
                              cartItem.food.description,
                              style: TextStyle(
                                color:
                                    Theme.of(
                                      context,
                                    ).colorScheme.inversePrimary,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // increment or decrement quantity
                      QuantitySelector(
                        quantity: cartItem.quantity,
                        food: cartItem.food,
                        onDecrement: () {
                          restaurant.removeFromCart(cartItem);
                        },
                        onIncrement: () {
                          restaurant.addToCart(
                            cartItem.food,
                            cartItem.selectedAddons,
                          );
                        },
                      ),
                    ],
                  ),
                ),

                // addons
                SizedBox(
                  height: cartItem.selectedAddons.isEmpty ? 0 : 60,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.all(10),
                    children:
                        cartItem.selectedAddons
                            .map(
                              (addon) => Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: FilterChip(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  label: Row(
                                    children: [
                                      // addon name
                                      Text(addon.name ?? ""),

                                      // addon priceR
                                      Text(" (+${addon.price} Ft)"),
                                    ],
                                  ),
                                  shape: StadiumBorder(
                                    side: BorderSide(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                  onSelected: (value) {},
                                  backgroundColor:
                                      Theme.of(context).colorScheme.surface,
                                  labelStyle: TextStyle(
                                    color:
                                        Theme.of(
                                          context,
                                        ).colorScheme.inversePrimary,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                  ),
                ),
              ],
            ),
          ),
    );
  }
}
