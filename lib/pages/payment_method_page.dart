import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_order_app/components/custom_button.dart';
import 'package:food_order_app/models/restaurant.dart';
import 'package:food_order_app/pages/cart_page.dart';
import 'package:food_order_app/pages/home_page.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:food_order_app/controllers/totalPrice_controller.dart';
import 'package:provider/provider.dart';

class PaymentMethodPage extends StatefulWidget {
  const PaymentMethodPage({super.key});

  @override
  State<PaymentMethodPage> createState() => _PaymentMethodPageState();
}

class _PaymentMethodPageState extends State<PaymentMethodPage> {

  int _type = 1;
  late String total;
  void _handleRadio(Object? e) => setState((){
    _type = e as int;
  });
  
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
  final restaurant = Provider.of<Restaurant>(context, listen: false);
  final total = restaurant.getTotalPrice();
    Size size = MediaQuery.of(context).size;  
    return Scaffold(
      appBar: AppBar(
        title: const Text("Fizetési mód"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Get.offAll(() => HomePage());
          },
        ),

        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        elevation: 0,
      ),
      body: SafeArea(child: 
        Padding(
          padding: EdgeInsets.all(20.0),
          child: Center(
            child: Column(
              children: [
                SizedBox(height: 40,),
                Container(
                  width: size.width,
                  height: 55,
                  margin: EdgeInsets.only(right: 20),
                  decoration: BoxDecoration(
                    border: _type == 1 ? 
                    Border.all(width: 1, color:Colors.black) : 
                    Border.all(width: 0.3, color:Colors.grey),
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.transparent,
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Radio(
                                value: 1,
                                groupValue: _type,
                                onChanged: _handleRadio,
                                activeColor: Colors.red,
                              ),
                              Text("Google Pay", style: _type == 1 ? TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Colors.red,
                              ) : TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey,
                              ),
                            ),
                            ],
                          ),
                            Image.asset("lib/images/payment_logos/google_pay.png", 
                              width: 70, height: 70,
                              fit: BoxFit.cover,
                            ),
                      ],),
                    ),
                  ),
                ),
                SizedBox(height: 20,),
                Container(
                  width: size.width,
                  height: 55,
                  margin: EdgeInsets.only(right: 20),
                  decoration: BoxDecoration(
                    border: _type == 2 ? 
                    Border.all(width: 1, color:Colors.black) : 
                    Border.all(width: 0.3, color:Colors.grey),
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.transparent,
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Radio(
                                value: 1,
                                groupValue: _type,
                                onChanged: _handleRadio,
                                activeColor: Colors.red,
                              ),
                              Text("Visa / Master Card", style: _type == 2 ? TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Colors.red,
                              ) : TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey,
                              ),
                            ),
                            ],
                          ),
                          Spacer(),
                            Image.asset("lib/images/payment_logos/visa.jpg", 
                              width: 35,
                            ),
                            Image.asset("lib/images/payment_logos/master_card.jpg", 
                              width: 35,
                            ),
                      ],
                      ),
                    ),
                  ),
                ),
                 SizedBox(height: 55,),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Kosar: ",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey,
                                  ),
                                ),
                                Text(
                                   "$total Ft",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
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
                                Text(
                                  "Vegosszeg: ",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey,
                                  ),
                                ),
                                Text(
                                   "${total+1200} Ft",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),  
                            SizedBox(height: 90,),
                           InkWell(
                            onTap: () {},
                            child: CustomButton(
                              onTap: () {
                                Get.offAll(() => CartPage());
                              },
                              text: "Fizetes",
                            ),
                           )
              ],
            ),
          ),
        )
      ),
    );
  }
}