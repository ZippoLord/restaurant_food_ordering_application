import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_order_app/constants.dart';
import 'package:food_order_app/widgets/tab_widget.dart';

class OrdersTabs extends StatelessWidget {
  const OrdersTabs({
    super.key,
    required TabController tabController,
  }) : _tabController = tabController;

  final TabController _tabController;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.r),
      ),
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        dividerColor: Colors.transparent,
        indicator: BoxDecoration(
          color: Colors.deepOrange,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: Colors.deepOrange,
            width: 2,
          ),
        ),
        labelColor: Colors.white,
        labelStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.deepOrange),
        unselectedLabelColor:  Colors.grey,
        tabAlignment: TabAlignment.start,
        tabs: List.generate(orderList.length, (index) => TabWidget(text: orderList[index]))
      ),
    );
  }
}