import 'package:flutter/material.dart';
import 'package:food_order_app/components/user_orders.dart';
import 'package:food_order_app/controllers/tab_controller.dart';
import 'package:food_order_app/pages/cart_page.dart';
import 'package:food_order_app/pages/food_page.dart';
import 'package:food_order_app/pages/home_page.dart';
import 'package:get/get.dart';

class MainScreen extends StatelessWidget {
  MainScreen({super.key});
  final controller = Get.find<CartController>();

  List<Widget> pageList = [
    HomePage(),
    CartPage(),
    UserOrders()
  ];

  @override
Widget build(BuildContext context) {
  final tabController = Get.put(currentTabController());
  final cartController = Get.find<CartController>();

  return Obx(() => Scaffold(
    body: pageList[tabController.tabIndex],
    bottomNavigationBar: Theme(
      data: Theme.of(context).copyWith(canvasColor: Theme.of(context).colorScheme.secondary, splashFactory: NoSplash.splashFactory, highlightColor: Colors.transparent),
      child: BottomNavigationBar(
        elevation: 0,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedIconTheme: IconThemeData(color: Colors.orange),
        unselectedIconTheme: IconThemeData(color: Colors.grey),
        onTap: (value) {
          tabController.setTabIndex = value;
        },
        currentIndex: tabController.tabIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Ételek',
          ),
          BottomNavigationBarItem(
            icon: Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(Icons.shopping_cart_outlined),
                Obx(() {
                  return cartController.cartItem.value >= 1 ?
                  Positioned(
                    right: -6,
                    top: -3,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '${cartController.cartItem}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )
                  : SizedBox.shrink();
                })
              ],
            ),
            label: 'Kosár',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: 'Rendelések',
          ),
        ],
      ),
    ),
  ));
}
}
