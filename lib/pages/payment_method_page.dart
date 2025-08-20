import 'dart:io';
import 'package:flutter/material.dart';
import 'package:food_order_app/components/custom_button.dart';
import 'package:food_order_app/models/restaurant.dart';
import 'package:food_order_app/pages/cart_page.dart';
import 'package:get/get.dart';
import 'package:pay/pay.dart';
import 'package:provider/provider.dart';

class PaymentMethodPage extends StatefulWidget {
  const PaymentMethodPage({super.key});

  @override
  State<PaymentMethodPage> createState() => _PaymentMethodPageState();

}

final Future<PaymentConfiguration> _googlePayConfigFuture =
    PaymentConfiguration.fromAsset('lib/assets/google_pay.json');


class _PaymentMethodPageState extends State<PaymentMethodPage> {
  int _type = 1;
  void _handleSelect(int type) => setState(() {
    _type = type;
  });


  @override
  Widget build(BuildContext context) {
    final restaurant = Provider.of<Restaurant>(context, listen: false);
    final total = restaurant.getTotalPrice();
    Size size = MediaQuery.of(context).size;

    Widget paymentCard({required int type, required String title, required Widget logo}) {
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
            boxShadow: selected
                ? []
                : [],
            color: Colors.white,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: selected ? Colors.red : Colors.grey[700],
                ),
              ),
              logo,
            ],
          ),
        ),
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
              Container(child: Platform.isIOS ? 
                   paymentCard(
                type: 1,
                title: "Apple Pay",
                logo: Row(
                  children: [
                    Image.asset(
                      "lib/images/payment_logos/apple_pay.png",
                      width: 35,
                    ),
                  ],
                ),
              )
               :  
              paymentCard(
                type: 1,
                title: "Google Pay",
                logo: Image.asset(
                  "lib/images/payment_logos/google_pay.png",
                  width: 70,
                  height: 70,
                  fit: BoxFit.cover,
                ),
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
             FutureBuilder<PaymentConfiguration>(
            future: _googlePayConfigFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.hasData) {
                return GooglePayButton(
                  paymentConfiguration: snapshot.data!,
                  paymentItems: const [
                    PaymentItem(
                      label: 'Total',
                      amount: '12.99',
                      status: PaymentItemStatus.final_price,
                    ),
                  ],
                  type: GooglePayButtonType.pay,
                  margin: const EdgeInsets.only(top: 15.0),
                  onPaymentResult: (result) {
                    debugPrint("Google Pay result: $result");
                  },
                  loadingIndicator: const Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              } else {
                return const CircularProgressIndicator();
              }
            },
          )
          ,
              const SizedBox(height: 55),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Kosar: ",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    "$total Ft",
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    "Szallitasi dij: ",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    "1200 Ft",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
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
                  const Text(
                    "Vegosszeg: ",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    "${total + 1200} Ft",
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 90),
              CustomButton(
                onTap: () {
                  Get.offAll(() => CartPage());
                },
                text: "Fizetes",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
