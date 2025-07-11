import 'package:flutter/material.dart';
import 'package:food_order_app/models/food.dart';

class CustomTabBar extends StatelessWidget {
  final TabController tabController;

  const CustomTabBar({
    super.key,
    required this.tabController,
  });

    List<Tab> _buildCategoryTabs() {
    return FoodCategory.values.map((category) {
      return Tab(
        child: Text(
          category.toString().split('.').last,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
      );
    }).toList();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: TabBar(
        isScrollable: true,
        controller: tabController,
        tabs: _buildCategoryTabs(),
        labelColor: Colors.red,
        unselectedLabelColor: Colors.grey,
      ),
    );
  }
}