import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_order_app/components/orders_tabs.dart';
import 'package:food_order_app/constants.dart';
import 'package:food_order_app/controllers/tab_controller.dart';
import 'package:food_order_app/dimensions.dart';
import 'package:food_order_app/pages/home_page.dart';
import 'package:food_order_app/widgets/custom_container.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class UserOrders extends StatefulWidget {
  const UserOrders({super.key});

  @override
  State<UserOrders> createState() => _UserOrdersState();
}

class _UserOrdersState extends State<UserOrders> with TickerProviderStateMixin{
  late final TabController _tabController = TabController(length: orderList.length, vsync: this);  

  @override
  Widget build(BuildContext context) {
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
                      // onTap: () {
                      //   final tabController = Get.find<currentTabController>();
                      //   tabController.setTabIndex = 0;
                      //   Navigator.pop(context);
                      // }, //TODO: fix
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
      body: CustomContainer(containerContent: 
        Column(
          children: [
            SizedBox(height: 10.h),
            OrdersTabs(tabController: _tabController),
            SizedBox(height: 10.h),
            SizedBox(
              height: Dimensions.screenHeight*0.7,
              child: TabBarView(
                controller: _tabController,
                children: [
                Container(
                  color: Colors.red,
                ),
                Container(
                  color: Colors.green,
                ),
                Container(),
                Container(),
                Container(),
              ]),
            )
          ],
        ),
      ),
      );
  }
}
