import 'dart:io';
import 'package:flutter/material.dart';
import 'package:food_order_app/components/custom_button.dart';
import 'package:food_order_app/components/modal_bottom_sheet.dart';
import 'package:food_order_app/components/user_orders.dart';
import 'package:food_order_app/controllers/address_controller.dart';
import 'package:food_order_app/controllers/order_controller.dart';
import 'package:food_order_app/controllers/tab_controller.dart';
import 'package:food_order_app/models/restaurant.dart';
import 'package:food_order_app/pages/cart_page.dart';
import 'package:food_order_app/pages/new_card.dart';
import 'package:food_order_app/pages/payment_with_card.dart';
import 'package:get/get.dart';
import 'package:pay/pay.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';

class PaymentMethodPage extends StatefulWidget {
  const PaymentMethodPage({super.key});

  @override
  State<PaymentMethodPage> createState() => _PaymentMethodPageState();
}

class _PaymentMethodPageState extends State<PaymentMethodPage> {
  int _type = 1;
  PaymentConfiguration? _googlePayConfig;
  final AddressController addressController = Get.put(AddressController());

  void _handleSelect(int type) => setState(() {
        _type = type;
      });

  @override
  void initState() {
    super.initState();
    if (!Platform.isIOS) {
      _loadGooglePayConfig();
    }
  }

  Future<void> _loadGooglePayConfig() async {
    final config = await PaymentConfiguration.fromAsset('google_pay.json');
    setState(() {
      _googlePayConfig = config;
    });
  }

  @override
  Widget build(BuildContext context) {
    print("Selected addres in payment ${addressController.selectedAddressId}");
    final restaurant = Provider.of<Restaurant>(context, listen: false);
    final total = restaurant.getTotalPrice();
    Size size = MediaQuery.of(context).size;

    Widget paymentCard(
        {required int type,
        required String title,
        required Widget logo,
        Widget? trailing}) {
      bool selected = _type == type;
      return GestureDetector(
        onTap: () => _handleSelect(type),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: size.width,
          height: 70,
          margin: const EdgeInsets.only(bottom: 20),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            border: Border.all(
              color: selected ? Colors.red : Colors.grey.shade400,
              width: selected ? 2 : 0.8,
            ),
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(children: [
                logo,
                const SizedBox(width: 12),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: selected ? Colors.red : Colors.grey[700],
                  ),
                ),
              ]),
              if (trailing != null) trailing,
            ],
          ),
        ),
      );
    }

    Widget? paymentButton;
    if (_type == 1) {
      if (Platform.isIOS) {
        // Apple Pay button (not implemented here, you can add ApplePayButton if needed)
        paymentButton = Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: Text(
            "Apple Pay fizetés csak iOS-en elérhető.",
            style: TextStyle(color: Colors.grey[600]),
          ),
        );
      } else {
        paymentButton = _googlePayConfig == null
            ? const CircularProgressIndicator()
            : GooglePayButton(
                paymentConfiguration: _googlePayConfig!,
                paymentItems: [
                  PaymentItem(
                    label: 'Kosár',
                    amount: (total.toInt() + 1200).toStringAsFixed(1),
                    status: PaymentItemStatus.final_price,
                  ),
                ],
                type: GooglePayButtonType.pay,
                onPaymentResult: (result) async {
                  final orderData = {
                    "userId": GetStorage().read("userId"),
                    "orderItems": 
                      [
                        for (var item in restaurant.cart)
                          {
                            "foodId": item.food.id,
                            "quantity": item.quantity,
                            "price": item.food.price,
                            "additives": item.selectedAddons.map((addon) => addon.id).toList(),
                          }
                      ],
                    "orderTotal": total.toInt(),
                    "Fee": 1200,
                    "grandTotal": total.toInt() + 1200,
                    "deliveryAddress": addressController.selectedAddressId.value,
                    "paymentMethod": "Google Pay",
                    "paymentStatus": "Completed",
                    "deliveryStatus": "Pending",
                    
                  };
                  await placeOrder(orderData);
                  final orderNumber = await getLastOrderNumber();
                    if (orderNumber != null) {
                      print("Az utolsó rendelés száma: $orderNumber");
                    }
                  restaurant.clearCart();
                  Navigator.pop(context);
                    final tabController = Get.find<currentTabController>();
                    tabController.setTabIndex = 2;
                    showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent, 
                    enableDrag: false,
                    builder: (context) {
                      return FractionallySizedBox(
                        heightFactor: 0.75, 
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(20), 
                            topRight: Radius.circular(20),
                          ),
                          child: Material(
                            child:  ModalBottomSheet(orderNumber: orderNumber), 
                          ),
                        ),
                      );
                    },
                  );
                },

                loadingIndicator: const CircularProgressIndicator(),
              );
      }
    } else if (_type == 2) {
      paymentButton = CustomButton(
        onTap: () {
          debugPrint("Visa/MasterCard fizetés (implementáld a logikát)");
          Get.to(() => const PaymentPage());
        },
        text: "Fizetés",
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Fizetési mód"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Get.back();
          },
        ),
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const SizedBox(height: 40),
              paymentCard(
                type: 1,
                title: Platform.isIOS ? "Apple Pay" : "Google Pay",
                logo: Image.asset(
                  Platform.isIOS
                      ? "lib/images/payment_logos/apple_pay.png"
                      : "lib/images/payment_logos/google_pay.png",
                  width: 35,
                  height: 35,
                ),
              ),
              paymentCard(
                type: 2,
                title: "Visa / Master Card",
                logo: Row(
                  children: [
                    Image.asset(
                      "lib/images/payment_logos/visa.jpg",
                      width: 35,
                    ),
                    const SizedBox(width: 8),
                    Image.asset(
                      "lib/images/payment_logos/master_card.jpg",
                      width: 35,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 55),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                   Text(
                    "Kosar: ",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                  ),
                  Text(
                    "${total.toInt()} Ft",
                    style:  TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children:  [
                  Text(
                    "Szallitasi dij: ",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                       color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                  ),
                  Text(
                    "1200 Ft",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                       color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                  ),
                ],
              ),
              Divider(
                color: Theme.of(context).colorScheme.inversePrimary,
                thickness: 0.5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                   Text(
                    "Vegosszeg: ",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                       color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                  ),
                  Text(
                    "${total.toInt() + 1200} Ft",
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              if (paymentButton != null) paymentButton,
            ],
          ),
        ),
      ),
    );
  }
}
