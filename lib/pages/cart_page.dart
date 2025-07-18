import 'package:flutter/material.dart';
import 'package:food_order_app/components/custom_button.dart';
import 'package:food_order_app/components/custom_cart_tile.dart';
import 'package:food_order_app/dimensions.dart';
import 'package:food_order_app/models/restaurant.dart';
import 'package:food_order_app/pages/address_picker_page.dart';
import 'package:food_order_app/pages/payment_page.dart';
import 'package:food_order_app/widgets/custom_container.dart';
import 'package:get/state_manager.dart';
import 'package:provider/provider.dart';


class CartPage extends StatelessWidget {
  const CartPage({super.key});
  final insLoading = true;

  @override
  Widget build(BuildContext context) {
    return Consumer<Restaurant>(
      builder: (context, restaurant, child) {
        // cart
        final userCart = restaurant.cart;
        
          String calculateTotalPrice() {
          num total = 0;
          for (final item in userCart) {
            final basePrice = item.food.price * item.quantity;
            final addonTotal = item.selectedAddons.fold<num>(
              0.0,
              (sum, addon) => sum + (addon.price * item.quantity),
            );
            total += basePrice + addonTotal;
          }
          return total.toStringAsFixed(0);
        }

        


      return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        appBar: AppBar(
          elevation: 0,
          title: Text("Kosár: ${calculateTotalPrice() == '0' ? '' : '${calculateTotalPrice()} Ft'}", style: TextStyle(fontWeight: FontWeight.w500),),
          actions: [
              // clear the cart button
              IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder:
                        (context) => AlertDialog(
                          title: Text(
                            "Biztos törölni akarod a kosarad elemeit?",
                          ),
                          actions: [
                            // cancel button
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text("Mégse"),
                            ),

                            // yes button
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                restaurant.clearCart();
                              },
                              child: const Text("Igen"),
                            ),
                          ],
                        ),
                  );
                },
                icon: const Icon(Icons.delete),
              ),
            ],
        ),
        body: SafeArea(
          child: CustomContainer(
            containerContent: 
            userCart.isEmpty ? 
            Container(
              color: Theme.of(context).colorScheme.surface,
              child: Center(
                child: SizedBox(
                  child: Text(
                    "A kosarad üres..",
                    style: TextStyle(
                      color:
                          Theme.of(
                            context,
                          ).colorScheme.inversePrimary,
                      fontSize: 16
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            )
          :
          Column(
            children: [
              Expanded(
                child: Container(
                  color: Theme.of(context).colorScheme.surface,
                  child: SizedBox(
                    child: ListView.builder(
                        itemCount: userCart.length,
                        itemBuilder: (context, index) {
                        final cartItem = userCart[index];
                        return CustomCartTile(cartItem: cartItem);
                      },
                    ),
                  ),
                ),
              ),
              Text("ide jon az address"),            
            ],
          )),
        )
      );


        //       // delivery address section
        //       if (userCart.isNotEmpty)
        //         Padding(
        //           padding: const EdgeInsets.symmetric(
        //             horizontal: 25,
        //             vertical: 10,
        //           ),
        //           child: Column(
        //             crossAxisAlignment: CrossAxisAlignment.start,
        //             children: [
        //               Text(
        //                 "Szállítási cím:",
        //                 style: TextStyle(
        //                   color: Theme.of(context).colorScheme.primary,
        //                   fontWeight: FontWeight.bold,
        //                 ),
        //               ),
        //               const SizedBox(height: 5),
        //               GestureDetector(
        //                 onTap: () {
        //                   Navigator.push(
        //                     context,
        //                     MaterialPageRoute(
        //                       builder: (context) =>  AddressPicker(),
        //                     ),
        //                   );
        //                 },
        //                 child: Container(
        //                   width: double.infinity,
        //                   padding: const EdgeInsets.all(12),
        //                   decoration: BoxDecoration(
        //                     color: Theme.of(context).colorScheme.secondary,
        //                     borderRadius: BorderRadius.circular(8),
        //                     border:
        //                         restaurant.deliveryAddress ==
        //                                 'Válassz szállítási címet!'
        //                             ? Border.all(color: Colors.red, width: 2)
        //                             : null,
        //                   ),
        //                   child: Row(
        //                     children: [
        //                       Expanded(
        //                         child: Text(
        //                           restaurant.deliveryAddress,
        //                           style: TextStyle(
        //                             color:
        //                                 restaurant.deliveryAddress ==
        //                                         'Válassz szállítási címet!'
        //                                     ? Colors.red
        //                                     : Theme.of(
        //                                       context,
        //                                     ).colorScheme.inversePrimary,
        //                             fontWeight: FontWeight.w500,
        //                           ),
        //                         ),
        //                       ),
        //                       Icon(
        //                         Icons.arrow_forward_ios,
        //                         size: 16,
        //                         color: Theme.of(context).colorScheme.primary,
        //                       ),
        //                     ],
        //                   ),
        //                 ),
        //               ),
        //             ],
        //           ),
        //         ),

        //       // button to pay
        //       if (userCart.isNotEmpty)
        //         Padding(
        //           padding: const EdgeInsets.only(
        //             bottom: 25,
        //             left: 25,
        //             right: 25,
        //           ),
        //           child: CustomButton(
        //             onTap: () {
        //               // validate address before proceeding
        //               if (restaurant.deliveryAddress ==
        //                   'Válassz szállítási címet!') {
        //                 // error message if there is no delivery address
        //                 showDialog(
        //                   context: context,
        //                   builder:
        //                       (context) => AlertDialog(
        //                         title: Text("Szükség van a szállítási címre!"),
        //                         content: Text(
        //                           "Válassz szállítási címet a fizetés előtt!",
        //                         ),
        //                         actions: [
        //                           // cancel button
        //                           TextButton(
        //                             onPressed: () => Navigator.pop(context),
        //                             child: const Text("Mégse"),
        //                           ),

        //                           // add address button
        //                           TextButton(
        //                             onPressed: () {
        //                               Navigator.pop(context); // Close dialog
        //                               // Navigate to address picker
        //                               Navigator.push(
        //                                 context,
        //                                 MaterialPageRoute(
        //                                   builder:
        //                                       (context) =>
        //                                            AddressPicker(),
        //                                 ),
        //                               );
        //                             },
        //                             child: const Text("Szállítási cím hozzáadása"),
        //                           ),
        //                         ],
        //                       ),
        //                 );
        //               } else {
        //                 // address is valid, proceed to checkout
        //                 Navigator.push(
        //                   context,
        //                   MaterialPageRoute(
        //                     builder: (context) => const PaymentPage(),
        //                   ),
        //                 );
        //               }
        //             },
        //             text: "Tovább a fizetéshez",
        //           ),
        //         ),
        //     ],
        //   ),
        // );
      },
    );
  }
}
