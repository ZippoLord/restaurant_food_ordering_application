import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_order_app/components/custom_cart_tile.dart';
import 'package:food_order_app/components/custom_forward_icon.dart';
import 'package:food_order_app/components/custom_shipping_address.dart';
import 'package:food_order_app/controllers/address_controller.dart';
import 'package:food_order_app/models/restaurant.dart';
import 'package:food_order_app/pages/address_picker_page.dart';
import 'package:food_order_app/pages/payment_method_page.dart';
import 'package:food_order_app/pages/payment_with_card.dart';
import 'package:food_order_app/widgets/custom_container.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final AddressController addressController = Get.find<AddressController>();

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
            title: Text(
              "Kosár: ${calculateTotalPrice() == '0' ? '' : '${calculateTotalPrice()} Ft'}",
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
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
                  userCart.isEmpty
                      ? Container(
                        color: Theme.of(context).colorScheme.surface,
                        child: Center(
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Lottie.asset(
                                  'lib/images/loaders/Empty cart.json',
                                  width: 250.w,
                                  height: 200.h,
                                ),
                                Text(
                              "A kosarad üres..",
                              style: TextStyle(
                                color:
                                    Theme.of(
                                      context,
                                    ).colorScheme.inversePrimary,
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.center,
                            ),
                              ],
                            )
                          ),
                        ),
                      )
                      : Column(
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

                          Obx(() {
                            final currentAddress = addressController.selectedAddress.value;
                            return Container(
                              color: Theme.of(context).colorScheme.surface,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Center(
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder:
                                                (_) => ShippingAddress(
                                                  initialPage: 2,
                                                ),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        width: 240,
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 8,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.transparent,
                                          borderRadius: BorderRadius.circular(
                                            10.r,
                                          ),
                                          border: Border.all(
                                            color: Colors.deepOrange[200]!,
                                          ),
                                        ),
                                        child: Center(
                                          child: Text(
                                            currentAddress.isEmpty
                                                ? "Válassz szállítási címet"
                                                : currentAddress,
                                            style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .inversePrimary,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  addressController
                                          .selectedAddress
                                          .value
                                          .isNotEmpty
                                      ? TextButton(
                                        onPressed: () {
                                         Get.to(() => const PaymentMethodPage());
                                        },
                                        child:const Icon(
                                          Icons.arrow_forward_ios,
                                          size: 25,
                                          color: Colors.deepOrange,
                                        ),
                                      )
                                      : Container(),
                                ],
                              ),
                            );
                          }),
                        ],
                      ),
            ),
          ),
        );
      },
    );
  }
}
