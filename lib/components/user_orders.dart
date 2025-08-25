import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_order_app/components/orders_tabs.dart';
import 'package:food_order_app/constants.dart';
import 'package:food_order_app/controllers/tab_controller.dart';
import 'package:food_order_app/dimensions.dart';
import 'package:food_order_app/models/newmodels/hooks/fetchOrder.dart';
import 'package:food_order_app/widgets/custom_container.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:qr_flutter/qr_flutter.dart';

class UserOrders extends HookWidget {
  const UserOrders({super.key});

  @override
  Widget build(BuildContext context) {
    final OrdersController controller = Get.put(OrdersController());
    final _tabController = useTabController(initialLength: 2);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      appBar: AppBar(
        elevation: 0,
        title: Stack(
          alignment: Alignment.center,
          children: [
            Center(
              child: Text(
                "Rendeléseim",
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
            Positioned(
              left: 0,
              child: GestureDetector(
                onTap: () {
                  final tabController = Get.find<currentTabController>();
                  tabController.setTabIndex = 0;
                },
                child: Icon(
                  Icons.arrow_back_ios_rounded,
                  color: Theme.of(context).colorScheme.inversePrimary,
                  size: 20.h,
                ),
              ),
            ),
          ],
        ),
      ),
      body: CustomContainer(
        containerContent: Column(
          children: [
            SizedBox(height: 10.h),
            OrdersTabs(tabController: _tabController),
            SizedBox(height: 10.h),
            SizedBox(
              height: Dimensions.screenHeight * 0.7,
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Pending Orders
                  Obx(() {
                    final pendingOrders = controller.orders
                        .where((o) => o.deliveryStatus == 'Pending')
                        .toList();
                    if (pendingOrders.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Lottie.asset("lib/images/loaders/Order food.json"),
                            SizedBox(height: 40,),
                            Text("Nincsenek függőben lévő rendelések.", style: TextStyle(fontWeight: FontWeight.w500, color: Theme.of(context).colorScheme.inversePrimary),),
                            SizedBox(height: 80,),
                          ],
                        ),
                      );
                    }
                    return ListView.builder(
                      itemCount: pendingOrders.length,
                      itemBuilder: (context, index) {
                        final order = pendingOrders[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                          child: ListTile(
                            title: Text("Rendelés száma: ${order.orderNumber}"),
                            subtitle: Text("Összeg: ${order.grandTotal} Ft"),
                            trailing: Text(order.paymentStatus == 'Delivered'
                                ? 'Kifizetve'
                                : 'Fizetés folyamatban'),
                            onTap: () => print(order.toJson()),
                            onLongPress: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                // QR kód adata: JSON string
                                final qrData = order.toJson().toString();

                                return AlertDialog(
                                  title: const Text("Rendelés QR"),
                                  content: SizedBox(
                                    width: 250,
                                    height: 250,
                                    child: QrImageView(
                                      data: qrData,
                                      version: QrVersions.auto,
                                      size: 200,
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text("Bezár"),
                                    ),
                                  ],
                                );
                              },
                            );
                            }
                          ),
                        );
                      },
                      
                    );
                  }),
                  // Completed Orders
                  Obx(() {
                    final completedOrders = controller.orders
                        .where((o) => o.deliveryStatus == 'Delivered')
                        .toList();
                    if (completedOrders.isEmpty) {
                     return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Lottie.asset("lib/images/loaders/Delivery.json"),
                            SizedBox(height: 40,),
                            Text("Nincsenek teljesített rendelések.", style: TextStyle(fontWeight: FontWeight.w500, color: Theme.of(context).colorScheme.inversePrimary),),
                          ],
                        ),
                      );
                    }
                    return ListView.builder(
                      itemCount: completedOrders.length,
                      itemBuilder: (context, index) {
                        final order = completedOrders[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                          child: ListTile(
                            title: Text("Rendelés száma: ${order.orderNumber}"),
                            subtitle: Text("Összeg: ${order.grandTotal} Ft"),
                            trailing: Text(order.paymentStatus == 'Completed'
                                ? 'Kifizetve'
                                : 'Fizetés folyamatban'),
                            onTap: () => print(order.toJson()),
                          ),
                        );
                      },
                    );
                  }),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
